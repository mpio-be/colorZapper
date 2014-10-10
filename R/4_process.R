


#' extract RGB
#' extract RGB
#' examples
#' \donotrun{
#'  
#'  
#'  }
#'  

# TODO fix for polygons

CZextractRGB <- function() {
	stopifnot( colorZapper_file_active())
	
	dbGetQuery(options()$cz.con, "DELETE FROM RGB")
	dbGetQuery(options()$cz.con, "VACUUM") 
	
	d = dbGetQuery(options()$cz.con, "SELECT distinct f.id, f.path, w.pk, w.WKT from files f JOIN ROI w on f.ID = w.ID	")
	
	dl = split(d, d$id)
	
	O = list()
	
	for(i in 1:length(dl) ) {
		ri = brick (  dl[[i]]$path[1]  , crs = NA, nl = 3) 
		
		wi = lapply(dl[[i]]$wkt,  readWKT)
		
		res = mapply( FUN = function(x, id) cbind( extract(ri, x, method='bilinear'), id), x =  wi, id = dl[[i]]$pk, SIMPLIFY = FALSE)
		
		O[[i]] = do.call(rbind, res)
		}	

	O = do.call(rbind, O)
	O = data.frame(O)
	names(O) = c("R", "G", "B", "roi_pk")	
		
	dbWriteTable(options()$cz.con, "RGB", O, row.names = FALSE, append = TRUE)
				
}














