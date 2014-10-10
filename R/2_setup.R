
#' Associate images to a colorZapper file.
#'
#' @param dir directory containing images
#' @return TRUE
#'
#' @note duplicated files are dropped silently

#' @examples
#'\dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' CZopen(path = tempfile() )
#' CZaddFiles(dir)
#' 
#' }
#' 
#' 
CZaddFiles <- function(dir)	{
	stopifnot( colorZapper_file_active())
	
	f = data.frame(path = 
		list.files(dir, recursive = TRUE, full.names = TRUE, 
		pattern= "((\\.(?i)(jpg|jpeg|png|gif|bmp|tif|tiff))$)"), id = NA )
	
	dbWriteTable(options()$cz.con, "files", f, row.names = FALSE, append = TRUE)
	
	# remove duplicates
	dbGetQuery(options()$cz.con, 
			"delete   from files where  id not in
				(select  min(id) from files group by path)")
	
	n = dbGetQuery(options()$cz.con, "select count(*) from files")[1,1]
	message( paste(n, "image files") )
  
}
	

	
	