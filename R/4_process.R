#' Extract data
#' Extract data from regions of interest.
#' @export

#' @importFrom raster      brick extract
#' @importFrom rgeos       readWKT
#' @importFrom data.table  data.table rbindlist setcolorder setnames :=
#' @importFrom parallel    makePSOCKcluster  detectCores stopCluster 
#' @importFrom doParallel  registerDoParallel 
#' @importFrom foreach     %dopar%  foreach registerDoSEQ

#' @examples 
#' \dontrun{
#'  CZextractROI()
#'  }
CZextractROI <- function(parallel = FALSE) {
	stopifnot( colorZapper_file_active())
	
	dbExecute(getOption('cz.con'), "DELETE FROM ROI_RGB")
	dbExecute(getOption('cz.con'), "VACUUM") 



	if(parallel) {
		pb = tempfile(fileext = '.txt')
		message("To follow progress monitor", sQuote(pb), "\n  e.g.,in linux, with\n tail -f ",pb)
		cl = makePSOCKcluster(detectCores()-1); registerDoParallel(cl)
		on.exit(stopCluster(cl))
		on.exit(registerDoSEQ() )
		}
	
	# data
	d = dbGetQuery(getOption('cz.con'), "SELECT distinct f.id, f.path, w.pk, w.WKT from files f JOIN ROI w on f.ID = w.ID	")
	dl = split(d, d$id)
	

 	O = foreach(i = 1:length(dl), .packages = 'colorZapper') %dopar% {

 		if(!parallel) print(i)
 		if(parallel) cat(i, ',', sep = '', file = pb, append = TRUE)


		ri = brick (  dl[[i]]$path[1]  ) 
		
		wi = lapply(dl[[i]]$wkt,  rgeos::readWKT)
		
		res = mapply( FUN = 
              function(x, id) { 
                #resi = raster::extract(ri, x, method='bilinear', df = TRUE)

                resi = exactextractr::exact_extract(ri, st_as_sf(x) , force_df = TRUE, progress = FALSE)

                if( inherits(resi, "list") ) resi = resi[[1]]

                o = data.table(resi)
                cbind(o, id)

                }, x =  wi, id = dl[[i]]$pk, SIMPLIFY = FALSE)
		
		o = rbindlist(res)
		
		o[, coverage_fraction := NULL] 
		if(ncol(o) < 4) stop('Only ', ncol(o)-1, ' channels found, expecting 3 (RGB)')
		o
	 }	

	O = rbindlist(O, use.names=FALSE)
	setcolorder(O, c('id', setdiff(names(O), 'id') ))

	if(ncol(O) > 4) { 
		warning('More than three (RGB?) channels found; ignoring channel(s) 5 through ', ncol(O) )
		 O = O[, 1:4]	
	}

	setnames( O, c("roi_pk", "R", "G", "B")	 )
	setcolorder( O, c( "R", "G", "B", "roi_pk")	 )

		
	dbWriteTable(getOption('cz.con'), "ROI_RGB", O, row.names = FALSE, append = TRUE)
				
	}


#' Extract data
#' Extract data from the entire image
#' @export
#' @examples
#' \dontrun{
#'  CZextractALL()
#'  }
CZextractALL <- function(parallel = FALSE) {
	stopifnot( colorZapper_file_active())
	
	dbExecute(getOption('cz.con'), "DELETE FROM ALL_RGB")
	dbExecute(getOption('cz.con'), "VACUUM") 

	if(parallel) {
		pb = tempfile(fileext = '.txt')
		message("To follow progress monitor", sQuote(pb), "\n  e.g.,in linux, with\n tail -f ",pb)
		cl = makePSOCKcluster(detectCores()-1); registerDoParallel(cl)
		on.exit(stopCluster(cl))
		on.exit(registerDoSEQ() )
		}
	
	# data
	d = dbGetQuery(getOption('cz.con'), "SELECT * from files")
	dl = split(d, d$id)
	

 	O = foreach(i = 1:length(dl), .packages = 'colorZapper') %dopar% {
		
		if(!parallel) print(i)
		if(parallel) cat(i, ',', sep = '', file = pb, append = TRUE)			

		ri = brick (  dl[[i]]$path[1]  ) 
		o = data.table(ri[])
		o[, path := dl[[i]]$id[1] ]
		o
    }
    	
	O = rbindlist(O, use.names=FALSE)

	if(!ncol(O) %in% c(4,5)) {
		print(head(O))
		stop("Unknown image format")
		}

	if(ncol(O) == 4) 
		setnames(O, c("R", "G", "B", "all_pk") )


	if(ncol(O) == 5) {
		message('Four channels found. Assuming channel 4 sets transparency.')
		setnames(O, c("R", "G", "B", "a", "all_pk")	 )
		O = O[a > 0]
		O[, a:= NULL]
		}

		
	dbWriteTable(getOption('cz.con'), "ALL_RGB", O, row.names = FALSE, append = TRUE)
				
	}


#' Remove entries
#' Remove entries associated with given images
#' @export

CZrm <- function(fileNam) {
	stopifnot( colorZapper_file_active())
	
	
	ids = 	dbGetQuery(getOption('cz.con'), 'SELECT * from files ') %>% setDT
	ids = ids[basename(path)  %in% fileNam]

	if(nrow(ids) == 0) 
		stop('None of the files exist in this project.')

	if(nrow(ids) != length(fileNam)) 
		warning('Some files do not exist in this project. Known files: \n', paste(basename(ids$path), collapse = '\n'))

	rmids = paste(ids$id, collapse = ',')

	o = dbExecute(getOption('cz.con'), paste("DELETE FROM ROI where id in (", rmids, ')') )
	print(o)
	
	message('You need to run the CZextract* functions again!')		

	dbExecute(getOption('cz.con'), "DELETE FROM ALL_RGB")
	dbExecute(getOption('cz.con'), "DELETE FROM ROI_RGB")


	dbExecute(getOption('cz.con'), "VACUUM") 


				
	}












