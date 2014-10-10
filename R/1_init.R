
czIsValid <- function(con) { 
  
  stopifnot(  dbIsValid(con) )
  
  true_format = list(
    nfo = c("user", "create", "version"), 
    files = c("path", "id"), 
	ROI = c("id", "wkt", "mark", "pk"),
	RGB = c("R", "G", "B", "pk")
	
	)
  
  this_format = sapply(dbListTables(con), function(x) dbListFields(con, x))
  
  identical(true_format, this_format[names(true_format)])
  
	}
	
czopen <- function(path) {
  con = dbConnect(dbDriver("SQLite"), path)

  freshDB = length(dbListTables(con)) == 0
  
  if( freshDB ) {
  
  # nfo
  nfo = data.frame(
  	user = as.character(Sys.info()[["user"]]) ,
  	create = as.character(Sys.time()),
  	version = as.character(packageVersion("colorZapper")) )
  
  dbSendQuery(con, 
  'CREATE TABLE "nfo" (
  	"user" VARCHAR, 
  	"create" DATETIME, 
  	"version" CHAR)')	
  
  dbWriteTable(con, "nfo", nfo, row.names = FALSE, append = TRUE)
  
  # files table	
  dbSendQuery(con, 
  	'CREATE  TABLE files (
  	"path" VARCHAR, 
  	"id" INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL )')
  
  # ROI
  dbSendQuery(con,'
  CREATE TABLE "ROI" (
	"id" INTEGER NOT NULL , 
	"wkt" TEXT NOT NULL , 
	"mark" VARCHAR, 
	"pk" INTEGER PRIMARY KEY  AUTOINCREMENT)
  ')
  
  # RGB
  dbSendQuery(con,'
  CREATE TABLE "RGB" (
	"R" float, 
	"G" float, 
	"B" float, 
	"pk" INTEGER PRIMARY KEY NOT NULL   )
  ')
  
   dbClearResult(con)
  
  }	

  return(con)
	
	}

colorZapper_file_active <- function() {
 if( inherits(options()$cz.con, "SQLiteConnection" ) && 
	dbIsValid(options()$cz.con) && 
	czIsValid(options()$cz.con) ) TRUE else FALSE
	}
	
# user level

CZopen <- function(path) {
		
		invisible(suppressWarnings(try(dbDisconnect(options()$cz.con), silent = TRUE)))
		options( cz.con = czopen(path = path) )
		return(colorZapper_file_active()	)

	}
	
CZclose <- function() {
	dbDisconnect(options()$cz.con)
	}
		
		
		
		
		
		
		
	
	