
czplot <-function(r) {
	plotRGB (r, maxpixels = Inf)
	}
	
czlocator <-function(type, ... ) {
	res = locator(...) 
	if(Sys.getenv("RSTUDIO") == "1") dev.off()
	
	switch(type, 
	p = paste("MULTIPOINT(", paste("(", res$x, res$y, ")", collapse = ","), ")"), 
	l = NA)
	
	
	}
	
	
#' photo ID-s
#' Show processed files
#' examples
#' \donotrun{
#'  
#'  
#'  }
#'  

CZShowStatus <- function() {
	stopifnot( colorZapper_file_active())
	dbGetQuery(options()$cz.con, "select * from files f left join ROI r on f.id = r.id")
	
	} 
	
#' Define regions of interest.
#' Interactively define points or polygons using mouse clicks.
#' @examples
#' \dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' CZopen(path = tempfile() )
#' CZaddFiles(dir)
#' CZdefine(points = 1)
#' 
#' }

setGeneric("CZdefine", function(points, polygons, ...) standardGeneric("CZdefine") )


# points & no marks
setMethod("CZdefine",
signature = c(points = "numeric", polygons = "missing"),
	definition = function(points, ...) {
		stopifnot( colorZapper_file_active())
		
	f =  dbGetQuery(options()$cz.con, "select * from files")

	  
	  for(i in 1:nrow(f) ) {
		bi = brick (f[i, 'path'], crs = NA, nl = 3)    
		czplot(bi)
		v = czlocator(n = points, type = 'p')		# ...

		d = data.frame( id = f[i, 'id'], wkt = v, mark = NA, pk = NA)
		
		dbWriteTable(options()$cz.con, "ROI", d, row.names = FALSE, append = TRUE)	
			
		flush.console() 
		cat(i, "of", nrow(f), "\n" )
		
		}
	}
)








if(FALSE) {
	require(colorZapper)
	dir = system.file(package = "colorZapper", "sample")
	CZopen(path = tempfile() )
	CZaddFiles(dir)
	CZdefine(points = 2)

	dbGetQuery(options()$cz.con, "select * from ROI")

 }
























