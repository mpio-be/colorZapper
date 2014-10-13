#' Define regions of interest.
#'
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









setGeneric("CZdefine", function(points, polygons,  ...) standardGeneric("CZdefine") )


# points
setMethod("CZdefine",
signature = c(points = "numeric", polygons = "missing"),
	definition = function(points , marks = NA, what, ...) {
	stopifnot( colorZapper_file_active() )
	
	qstr = "select * from files f where f.id not in (select distinct id from ROI where instr(wkt, 'MULTIPOINT') = 1 )"
	if(!missing(what)) 
	 qstr = paste("select * from files f where f.id in", paste('(', paste(what, collapse = ","), ')') )
	
	f =  dbGetQuery(options()$cz.con, qstr)
	
	if(missing(what) & nrow(f) == 0) stop("You pushed points on all images here.")
		
	for(i in 1:nrow(f) ) {
		bi = brick (f[i, 'path'], crs = NA, nl = 3)    
		
		plotRGB (bi, maxpixels = Inf)
		
		for(j in 1:length(marks) ) {
			v = locator(type = "p", n = points, ...) 
			v = paste("MULTIPOINT(", paste("(", v$x, v$y, ")", collapse = ","), ")")
			
			points(readWKT(v), cex = 2)
			
			d = data.frame( id = f[i, 'id'], wkt = v, mark = marks[j]  , pk = NA)
			dbWriteTable(options()$cz.con, "ROI", d, row.names = FALSE, append = TRUE)	
			}
		
		if(Sys.getenv("RSTUDIO") == "1") dev.off()
		
		
		flush.console() 
		cat(i, "of", nrow(f), "\n" )
	
	}
}
)

# polygons
setMethod("CZdefine",
signature = c(points = "missing", polygons = "numeric"),
	definition = function(polygons , marks = NA, what, ...) {
	stopifnot( colorZapper_file_active() )
	
	qstr = "select * from files f where f.id not in (select distinct id from ROI where instr(wkt, 'MULTIPOLYGON') = 1 )"
	if(!missing(what)) 
	 qstr = paste("select * from files f where f.id in", paste('(', paste(what, collapse = ","), ')') )
	
	f =  dbGetQuery(options()$cz.con, qstr)
	
	if(missing(what) & nrow(f) == 0) stop("You painted polygons on all images here.")
	
	
	for(i in 1:nrow(f) ) {
		bi = brick (f[i, 'path'], crs = NA, nl = 3)    
		marksCol = as.numeric(factor(marks))
		plotRGB (bi, maxpixels = Inf)
		
		for(j in 1:length(marks) ) {

			P = vector(mode = "list", length = polygons)
			
			nj = 0
			while(nj < polygons) {
				nj = nj+1
				P[[nj]]  = locator(type = "l")
				}
			
			gp = lapply(P, function(p) { list( x = c(p$x, p$x[1]),y = c(p$y, p$y[1]) ) } )
			gp = sapply(gp, function(p) paste(p$x, p$y, collapse = ",") )
			gp = paste('((', gp, '))', collapse = ",")
			gp = paste('MULTIPOLYGON(', gp, ')')
			
			plot(readWKT(gp), border = 2, col = adjustcolor(marksCol[j], .2), add = T)
			
			d = data.frame( id = f[i, 'id'], wkt = gp, mark = marks[j], pk = NA)
			dbWriteTable(options()$cz.con, "ROI", d, row.names = FALSE, append = TRUE)	
			
			}
				
		if(Sys.getenv("RSTUDIO") == "1") dev.off()
		flush.console() 
		cat(i, "of", nrow(f), "\n" )
	
	}

	
	
	}
)



 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 























