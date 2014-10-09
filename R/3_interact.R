
#' Define regions of interest.
#' Interactively define points or polygons using mouse clicks.

#' \dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' CZOpen(path = tempfile() )
#' CZAddFiles(dir)
#' CZDefine(points = 1)
#' 
#' }

setGeneric("CZDefine", function(points, polygons, ...) standardGeneric("CZDefine") )

# points & no marks
setMethod("CZDefine",
signature = c(points = "numeric", polygons = "missing"),
	definition = function(points, ...) {
		stopifnot( colorZapper_file_active())
		
	f =  dbGetQuery(options()$cz.con, "select * from files")

	  
	  for(i in 1:nrow(f) ) {
		fi = brick (f[i, 'path'], crs = NA, nl = 3)    
		plotRGB (fi, maxpixels = Inf)
		v = locator(fi, type = "p", n = points) # ...

		d = data.frame( 
			id = f[i, 'id'],
			wkt = paste("MULTIPOINT(", paste("(", v$x, v$y, ")", collapse = ","), ")"),
			mark = NA, 
			pk = NA)
		
		 dbWriteTable(options()$cz.con, "ROI", d, row.names = FALSE, append = TRUE)	
			
		flush.console() 
		cat(i, "of", nrow(f), "\n" )
		
		# write to db
		
		
		
		flush.console() 
		
		
		
		}
	  


	}
)








if(FALSE) {
	dir = system.file(package = "colorZapper", "sample")
	CZOpen(path = tempfile() )
	CZAddFiles(dir)
	CZDefine(points = 1)

	dbGetQuery(options()$cz.con, "select * from ROI")

 }
























