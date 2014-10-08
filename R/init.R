
czExists <- function(dir) { 
	getwd()
	}

	
czOpen <- function(path ) {
	con = dbConnect(dbDriver("SQLite"), dbname = path)
	
	if(file.exists(path) ) {
	#check file
	}
		
	if( ! file.exists(path)) {
	
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
	
	dbDisconnect(con)
	
	}
	
	
czDo <- function(path, query) {
	# connect, run, disconnect	
	
	
	}	
	
	
	
	
czProject <- function(dir, name = paste(basename(dir), "cz", sep = ".") ) {
		
		czInit(name)
		
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	
	