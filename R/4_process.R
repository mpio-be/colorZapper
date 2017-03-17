#' Extract data
#' Extract data from regions of interest.
#' @export
#' @examples
#' \dontrun{
#'  CZextractROI()
#'  }
CZextractROI <- function(parralel = TRUE) {
	stopifnot( colorZapper_file_active())
	
	dbGetQuery(getOption('cz.con'), "DELETE FROM ROI_RGB")
	dbGetQuery(getOption('cz.con'), "VACUUM") 

	if(parralel) {
		cl = makePSOCKcluster(detectCores()-1); registerDoParallel(cl)
		on.exit(stopCluster(cl))
		on.exit(registerDoSEQ() )
		}
	
	# data
	d = dbGetQuery(getOption('cz.con'), "SELECT distinct f.id, f.path, w.pk, w.WKT from files f JOIN ROI w on f.ID = w.ID	")
	dl = split(d, d$id)
	

 	O = foreach(i = 1:length(dl), .packages = c('RSQLite', 'data.table','rgeos','raster')) %dopar% {
		ri = brick (  dl[[i]]$path[1]  , crs = NA, nl = 3) 
		
		wi = lapply(dl[[i]]$wkt,  readWKT)
		
		res = mapply( FUN = 
              function(x, id) { 
                res = raster::extract(ri, x, method='bilinear')
                if( inherits(res, "list") ) res = res[[1]]
                cbind(res , id)
                }, x =  wi, id = dl[[i]]$pk, SIMPLIFY = FALSE)
		data.frame(res[[1]])
	}	

	O = rbindlist(O)
	setnames(O, c("R", "G", "B", "roi_pk")	 )
		
	dbWriteTable(getOption('cz.con'), "ROI_RGB", O, row.names = FALSE, append = TRUE)
				
	}


#' Extract data
#' Extract data from the entire image
#' @export
#' @examples
#' \dontrun{
#'  CZextractALL()
#'  }
CZextractALL <- function(parralel = TRUE) {
	stopifnot( colorZapper_file_active())
	
	dbGetQuery(getOption('cz.con'), "DELETE FROM ALL_RGB")
	dbGetQuery(getOption('cz.con'), "VACUUM") 

	if(parralel) {
		cl = makePSOCKcluster(detectCores()-1); registerDoParallel(cl)
		on.exit(stopCluster(cl))
		on.exit(registerDoSEQ() )
		}
	
	# data
	d = dbGetQuery(getOption('cz.con'), "SELECT * from files")
	dl = split(d, d$id)
	

 	O = foreach(i = 1:length(dl), .packages = c('RSQLite', 'data.table','rgeos','raster')) %dopar% {
		ri = brick (  dl[[i]]$path[1]  , crs = NA, nl = 3) 
		o = data.table(ri[])
		o[, path := dl[[i]]$id[1] ]
		o
    }	
	O = rbindlist(O)
	setnames(O, c("R", "G", "B", "all_pk")	 )
		
	dbWriteTable(getOption('cz.con'), "ALL_RGB", O, row.names = FALSE, append = TRUE)
				
	}














