
.onLoad <- function(libname, pkgname) {
	
	wd = getwd()
	# czproj = czExists(wd)
  czproj = wd
	
	options(cz.project = czproj)

	packageStartupMessage( paste("Found colorZapper project", shQuote("foo"), "at", wd) )
	
	}

























