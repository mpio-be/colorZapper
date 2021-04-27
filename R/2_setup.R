
#' Associate images to a colorZapper file.
#' @param dir directory containing images. When re-setting dir with CZsetwd() the default is the current working directory.
#' @return TRUE
#' @note CZaddFiles() can be run only once. 
#' @export
#' @importFrom RSQLite dbGetQuery 
#' @examples
#'\dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' p = tempfile() 
#' CZopen(path = p)
#' CZaddFiles(dir)
#' CZsetwd()
#' 
#' }
CZaddFiles <- function(dir) {
    stopifnot( colorZapper_file_active())
    
    b = dbGetQuery(getOption('cz.con'), "SELECT basedir from nfo")$basedir
    if(!is.na(b)) stop('Files were already added to this project. If you want to change the base directory run CZsetwd(new_directory)')

    dbExecute(getOption('cz.con'), paste('UPDATE nfo set basedir = ', shQuote(dir)) )

    f = data.frame(path = 
        list.files(dir, recursive = TRUE, full.names = FALSE, 
            pattern= "((\\.(?i)(jpg|jpeg|png|gif|bmp|tif|tiff))$)"), id = NA )
    
    dbWriteTable(getOption('cz.con'), "files", f, row.names = FALSE, append = TRUE)

    
    n = dbGetQuery(getOption('cz.con'), "select count(*) from files")[1,1]
    message( paste(n, "image files") )

    n
    
}
    
#' @rdname CZaddFiles
#' @export

CZsetwd <- function(dir = getwd() ) {
    stopifnot( colorZapper_file_active())
    o = dbExecute(getOption('cz.con'), paste('UPDATE nfo set basedir = ', shQuote(dir)) )
    if(o == 1) message('CZ image directory set to ', shQuote(dir)) else
    stop('Could not change the current CZ image directory.')

    }
