#  https://github.com/Rdatatable/data.table/issues/850
utils::globalVariables(c(
	'.', 
	'.N',
	'a',
	'B',
	'bitmap',
	'dist',
	'female_col',
	'G',
	'head',
	'hexCol',
	'hf',
	'hm',
	'hsv',
	'i',
	'ID',
	'k',
	'k1',
	'male_col',
	'par',
	'parts',
	'path',
	'R',
	'rnorm',
	'sf',
	'sm',
	'v',
	'value',
	'vf',
	'vm'
	))




#' @import methods RSQLite  doParallel  foreach  data.table  magrittr  raster  rgeos exactextractr  sf  stringr  scales
NULL
#' @importFrom grDevices    adjustcolor  dev.off  pdf  rgb  rgb2hsv bitmap hsv
NULL
#' @importFrom graphics     par locator  mtext  points plot
NULL
#' @importFrom utils        head flush.console  packageVersion
NULL
#' @importFrom stats        dist  rnorm
NULL




.onLoad <- function(libname, pkgname) {
	
	wd = getwd()
	# packageStartupMessage( paste("Found colorZapper project", shQuote("foo"), "at", wd) )
	
	}

#'  Color zapper.
#' Color zapper.
#'
#' @author
#' Mihai Valcu \email{valcu@@orn.mpg.de},
#' James Dale \email{J.Dale@@massey.ac.nz}
#'
#' Maintainer: Mihai Valcu \email{valcu@@orn.mpg.de}
#' @name colorZapper
#' @docType package


#' @name BirdBodyParts
#' @title A dataset containing body parts polygons of a generic songbird.  
#' @docType data
#' @format A data frame with 25 rows and 2 variables:
#' \describe{
#'   \item{parts}{body part: crown, forehead, ..., feet, tail}
#'   \item{geometry}{polygon geometry, sf::sfc class}
#' }
#' @keywords data
NULL