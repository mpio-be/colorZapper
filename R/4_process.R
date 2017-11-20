#' Extract data
#' Extract data from regions of interest.
#' @export
#' @examples
#' \dontrun{
#'  CZextractROI()
#'  }
CZextractROI <- function(parralel = TRUE) {
	stopifnot( colorZapper_file_active())
	
	dbExecute(getOption('cz.con'), "DELETE FROM ROI_RGB")
	dbExecute(getOption('cz.con'), "VACUUM") 


	pb = tempfile(fileext = '.txt')
	message("To follow progress monitor", sQuote(pb), "\n  e.g.,in linux, with\n tail -f ",pb," | grep --line-buffered -Eo '[0-9]+' | sort -rn | head -n 1 " )



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
		
		cat(i, file = pb, append = TRUE)
		o = data.table(do.call(rbind, res))
		if(nrow(o) < 4) stop('Only ', ncol(o)-1, ' channels found, expecting RGB')
		o
	 }	

	O = rbindlist(O)
	setcolorder(O, c('id', setdiff(names(O), 'id') ))

	if(nrow(O) > 4) { 
		warning('More than three (RGB?) channels found; ignoring channel(s) 5 through ', ncol(O) )
		 O = O[, 1:4]	
	}


	setnames(O, c("roi_pk", "R", "G", "B")	 )
		
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
	
	dbExecute(getOption('cz.con'), "DELETE FROM ALL_RGB")
	dbExecute(getOption('cz.con'), "VACUUM") 

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














