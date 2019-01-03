

.onLoad <- function(libname, pkgname) {
	
	wd = getwd()
	# packageStartupMessage( paste("Found colorZapper project", shQuote("foo"), "at", wd) )
	
	}

#  https://github.com/Rdatatable/data.table/issues/850
utils::globalVariables(c('hexCol', 'R', 'G', 'B', 'i', 'path', 'ID'))

#' @import RSQLite

#' @importFrom grDevices    adjustcolor  dev.off  pdf  rgb  rgb2hsv
NULL
#' @importFrom graphics     locator  mtext  points plot
NULL
#' @importFrom utils        flush.console  packageVersion
NULL



