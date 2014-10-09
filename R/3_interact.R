
#' Interactively define points or polygons using locator aka \code{\link{click}}.

#' @examples
#' \dontrun{
#' 
#' 
#' 
#' }


CZDefine <- function(n = 2) {
  	stopifnot( colorZapper_file_active())
	
	f =  dbGetQuery(options()$cz.con, "select * from files")
	
  O = list()
  
  for(i in 1:nrow(f) ) {
    fi = brick(f[i, 1])    
    plotRGB (fi)
    v = data.frame(locator(fi, type = "p", pch = "+", cex = 2, n = n))
	v
	
    names(v) = c("R", "G", "B")
	
	
    v$f = f[i]
    O[[i]] = v
    print(i)
    }
  
  do.call(rbind, O)
  
  
}
