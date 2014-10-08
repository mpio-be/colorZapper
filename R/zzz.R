#' Color zapper.
#'
#' @section Package options:
#'
#' colorZapper description:
#'
#' colorZapper session:
#'
#' \itemize{
#' \item \code{zzz}: path to use for \code{\link{zzz}}
#' }
	
#' @docType package
#' @name colorZapper

.onLoad <- function(libname, pkgname) {
	
	wd = getwd()
	# czproj = czExists(wd)
  czproj = wd
	
	options(cz.project = czproj)

	packageStartupMessage( paste("Found colorZapper project", shQuote("foo"), "at", wd) )
	
	}

























