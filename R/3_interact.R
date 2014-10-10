
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
	d = dbGetQuery(options()$cz.con, "
	select distinct f.id, 
		CASE WHEN instr(wkt, 'MULTIPOINT')	THEN 'points' 
			WHEN instr(wkt, 'MULTIPOLYGON')	THEN  'polygons' ELSE 'image' END as selected,
			path fileName
				from files f left join ROI r on f.id = r.id")
	d$fileName = gsub("((\\.(?i)(jpg|jpeg|png|gif|bmp|tif|tiff))$)", "", basename(d$fileName) )
	d
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

setGeneric("CZdefine", function(points, polygons, what, ...) standardGeneric("CZdefine") )


# points & no marks
setMethod("CZdefine",
signature = c(points = "numeric", polygons = "missing", what = "missing"),
	definition = function(points, ...) {
		stopifnot( colorZapper_file_active())
		
	f =  dbGetQuery(options()$cz.con, "select * from files f where f.id not in (select distinct id from ROI where instr(wkt, 'MULTIPOINT') = 1 )")

	if(nrow(f) == 0) stop("You pushed points on all images here.")
	
	  
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

	CZShowStatus()



	
	
 }
























