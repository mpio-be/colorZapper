
#' simple color extraction in a loop, invoking locator aka \code{\link{click}}.
#'
#' @param string directory containing images
#' @param N number of points per image to extract
#' @return \code{data.frame} containing the file path and the RGB

#' @examples
#' \dontrun{
#' zap()
#' 
#' 
#' }


zap <- function(path = system.file(package = "colorZapper", "sample"), N = 3) {
  
  f = list.files(path, full.names = TRUE, pattern= "((\\.(?i)(jpg|jpeg|png|gif|bmp|tif|tiff))$)")

  O = list()
  
  for(i in 1:length(f) ) {
    fi = stack(f[i])    
    plotRGB (fi)
    v = data.frame(click(fi, type = "p", pch = "+", n = N))
    names(v) = c("R", "G", "B")
    v$f = f[i]
    O[[i]] = v
    print(i)
    }
  
  do.call(rbind, O)
  
  
}


