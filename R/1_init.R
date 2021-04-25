

czopen <- function(path) {
  con = dbConnect(dbDriver("SQLite"), path)
  initExtension(con)

  freshDB = length(dbListTables(con)) == 0
  
  if( freshDB ) {

  # nfo
    nfo = data.frame(
      user = as.character(Sys.info()[["user"]]) ,
      create = as.character(Sys.time()),
      version = as.character(packageVersion("colorZapper")) )

    dbExecute(con, 
      'CREATE TABLE "nfo" (
        "user" VARCHAR, 
        "create" DATETIME, 
        "version" CHAR)') 

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
#' Open a colorZapper file.
#' @export
#' @examples
#'\dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' CZopen(path = tempfile() )
#' 
#' }
CZopen <- function(path) {
  invisible(suppressWarnings(try(dbDisconnect(getOption('cz.con')), silent = TRUE)))
  options( cz.con = czopen(path = path) )
  return(colorZapper_file_active()  )
  }



czIsValid <- function(con) { 

  stopifnot(  dbIsValid(con) )
  
  true_format = list(
    nfo     = c("user", "create", "version"), 
    files   = c("path", "id"), 
    ROI     = c("id", "wkt", "mark", "pk"),
    ROI_RGB = c("R", "G", "B", "roi_pk"), 
    ALL_RGB = c("R", "G", "B", "all_pk")
  )
  
  this_format = sapply(dbListTables(con), function(x) dbListFields(con, x))
  
  identical(true_format, this_format[names(true_format)])
  
  }


#' Checks for an active colorZapper project.
#' Checks for an active colorZapper project.
#' @export
colorZapper_file_active <- function() {
 if( inherits(getOption('cz.con'), "SQLiteConnection" ) && 
  dbIsValid(getOption('cz.con')) && 
  czIsValid(getOption('cz.con')) ) TRUE else FALSE
  }









