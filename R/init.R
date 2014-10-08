
czIsValid <- function(con) { 
  
  stopifnot(  dbIsValid(con) )
  
  true_format = list(
    files = c("path", "id"), 
    nfo = c("user", "create", "version"))
  
  this_format = sapply(dbListTables(con), function(x) dbListFields(con, x))
  
  identical(true_format, this_format)
  
	}
	
czOpen <- function(path) {
  con = dbConnect(dbDriver("SQLite"), path)

  freshDB = length(dbListTables(con)) == 0
  
  if( freshDB ) {
  
  # nfo
  nfo = data.frame(
  	user = as.character(Sys.info()[["user"]]) ,
  	create = Sys.time(),
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
  	"id" INTEGER PRIMARY KEY  NOT NULL  UNIQUE )')
  
  # points
  
  # polys
  
  # RGB
  
  
  
  }	
	
  if( !czIsValid(con) ) stop("This is not a valid colorZapper project!")

  return(con)
	
	}
	
czAddFiles <- function(path = "", dir)	{
  con = czOpen(path)
  on.exit(dbDisconnect(con))
  
  
}
	
czCheckFiles <-function(path, dir) {
  # check for !intersection(lfdb, fl_ondisk)
  }		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	