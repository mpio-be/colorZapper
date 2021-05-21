

czopen <- function(path) {
  con = dbConnect(dbDriver("SQLite"), path)
  initExtension(con)

  freshDB = length(dbListTables(con)) == 0
  
  if( freshDB ) {

  # nfo
    nfo      = data.frame(
      user    = as.character(Sys.info()[["user"]]) ,
      create  = as.character(Sys.time()),
      version = as.character(packageVersion("colorZapper"), 
      basedir = NA) )

    dbExecute(con, 
      'CREATE TABLE "nfo" (
          "user"   VARCHAR, 
          "create"  DATETIME, 
          "version" CHAR, 
          "basedir" CHAR)') 

    dbWriteTable(con, "nfo", nfo, row.names = FALSE, append = TRUE)

  # files table 
    dbExecute(con, 
      'CREATE  TABLE files (
          "path" VARCHAR, 
          "id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL )')

  # ROI
    dbExecute(con,'
      CREATE TABLE "ROI" (
          "id" INTEGER NOT NULL , 
          "wkt" TEXT NOT NULL , 
          "mark" VARCHAR, 
          "pk" INTEGER PRIMARY KEY  AUTOINCREMENT)
          ')

  # ROI_RGB
    dbExecute(con,'
      CREATE TABLE "ROI_RGB" (
          "R" float, 
          "G" float, 
          "B" float, 
          "roi_pk" INTEGER NOT NULL   )
          ')  

  # ALL_RGB
    dbExecute(con,'
      CREATE TABLE "ALL_RGB" (
          "R" float, 
          "G" float, 
          "B" float, 
          "all_pk" INTEGER NOT NULL   ) -- all_pk is the the id in the files table
          ')


  } 
  return(con)
  
}

#' Open a colorZapper file.
#' Setup a new colorZapper project or open an existing file.
#' @param path      file path.
#' @param overwrite when TRUE, start from scratch; default to FALSE.
#' @export
#' @importFrom RSQLite dbIsValid dbExecute dbConnect dbDisconnect dbDriver 
#'             initExtension dbWriteTable dbListTables dbListFields
#' @examples
#'\dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' CZopen(path = tempfile() )
#' 
#' }

CZopen <- function(path, overwrite = FALSE) {
  invisible(suppressWarnings(try(dbDisconnect(getOption('cz.con')), silent = TRUE)))
  if(overwrite) file.remove(path)
  options( cz.con = czopen(path = path) )
  return(colorZapper_file_active()  )
  }

czIsValid <- function(con) { 

  stopifnot(  dbIsValid(con) )
  
  true_format = list(
    nfo     = c("user", "create", "version", "basedir"), 
    files   = c("path", "id"), 
    ROI     = c("id", "wkt", "mark", "pk"),
    ROI_RGB = c("R", "G", "B", "roi_pk"), 
    ALL_RGB = c("R", "G", "B", "all_pk")
  )
  
  this_format = sapply(dbListTables(con), function(x) dbListFields(con, x))
  
  identical(true_format, this_format[names(true_format)])
  
  }


#' Checks for an active colorZapper project.
#' Is there a valid colorZapper project open?
#' @export
colorZapper_file_active <- function() {
 if( inherits(getOption('cz.con'), "SQLiteConnection" ) && 
  dbIsValid(getOption('cz.con')) && 
  czIsValid(getOption('cz.con')) ) TRUE else FALSE
  }


#' Open the example colorZapper file.
#' The file open by CZopen_example() has the interactive ROI-s defined; it is used for testing the non-interactive functions. 
#' @export
#' @examples
#' require(colorZapper)
#' CZopen_example()

CZopen_example <- function() {
  tf = tempfile()
  file.copy(system.file('cz_example', 'colorZapper.sqlite', package = 'colorZapper'), tf)
  CZopen(tf)

  CZsetwd(system.file( 'sample', package = 'colorZapper'))

  invisible(tf)

  }










