#' Define regions of interest.
#' Interactively define points or polygons using mouse clicks.
#' @export
#' @importFrom RSQLite dbGetQuery
#' @importFrom raster plotRGB nbands brick
#' @importFrom rgeos plot readWKT
#' @examples \dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' CZopen(path = tempfile() )
#' CZaddFiles(dir)
#' CZdefine(points = 1)
#' }
setGeneric("CZdefine", function(points, polygons,  ...) standardGeneric("CZdefine") )

# points
#' @export
setMethod("CZdefine",
    signature = c(points = "numeric", polygons = "missing"),
    definition = function(points , marks = NA, what, ...) {
        stopifnot( colorZapper_file_active() )

        qstr = "select * from files f WHERE f.id not in (select distinct id from ROI WHERE instr(wkt, 'MULTIPOINT') = 1 )"
        if(!missing(what)) 
            qstr = paste("select * from files f WHERE f.id in", paste('(', paste(what, collapse = ","), ')') )

        f =  dbGetQuery(getOption('cz.con'), qstr)
        
        if(missing(what) & nrow(f) == 0) stop("You pushed points on all images here.")

        basedir = dbGetQuery(getOption('cz.con'), "SELECT basedir from nfo")$basedir
        f$path = paste(basedir, f$path, sep = '/')

        for(i in 1:nrow(f) ) {

            bi = brick(f[i, 'path'] )

            if( nbands(bi) != 3) 
                warning(basename(f[i, 'path']), ' has ', nbands(bi), ' bands but 3 are expected.')



            raster::plotRGB (bi, maxpixels = Inf)

            for(j in 1:length(marks) ) {
                v = locator(type = "p", n = points, ...) 
                v = paste("MULTIPOINT(", paste("(", v$x, v$y, ")", collapse = ","), ")")

                points(rgeos::readWKT(v), cex = 2)

                d = data.frame( id = f[i, 'id'], wkt = v, mark = marks[j]  , pk = NA)
                dbWriteTable(getOption('cz.con'), "ROI", d, row.names = FALSE, append = TRUE)   
            }

            if(Sys.getenv("RSTUDIO") == "1") dev.off()


                flush.console() 
            cat(i, "of", nrow(f), "\n" )

        }
        })

# polygons
#' @export
setMethod("CZdefine",
    signature = c(points = "missing", polygons = "numeric"),
    definition = function(polygons , marks = NA, what, ...) {
        stopifnot( colorZapper_file_active() )

        qstr = "select * from files f WHERE f.id not in (select distinct id from ROI WHERE instr(wkt, 'MULTIPOLYGON') = 1 )"
        if(!missing(what)) 
            qstr = paste("select * from files f WHERE f.id in", paste('(', paste(what, collapse = ","), ')') )

        f =  dbGetQuery(getOption('cz.con'), qstr)
        
        if(missing(what) & nrow(f) == 0) stop("You painted polygons on all images here.")
        
        basedir = dbGetQuery(getOption('cz.con'), "SELECT basedir from nfo")$basedir
        f$path = paste(basedir, f$path, sep = '/')

        for(i in 1:nrow(f) ) {
            bi = brick(f[i, 'path'] )

            if( raster::nbands(bi) != 3) 
                warning(basename(f[i, 'path']), ' has ', nbands(bi), ' bands but 3 are expected.')


            marksCol = as.numeric(factor(marks))
            raster::plotRGB (bi, maxpixels = Inf)

            for(j in 1:length(marks) ) {

                P = vector(mode = "list", length = polygons)

                nj = 0
                while(nj < polygons) {
                    nj = nj+1
                    P[[nj]]  = locator(type = "l")
                }

                gp = lapply(P, function(p) { list( x = c(p$x, p$x[1]),y = c(p$y, p$y[1]) ) } )
                gp = sapply(gp, function(p) paste(p$x, p$y, collapse = ",") )
                gp = paste('((', gp, '))', collapse = ",")
                gp = paste('MULTIPOLYGON(', gp, ')')

                plot(rgeos::readWKT(gp), border = 2, col = adjustcolor(marksCol[j], .2), add = TRUE)

                d = data.frame( id = f[i, 'id'], wkt = gp, mark = marks[j], pk = NA)
                dbWriteTable(getOption('cz.con'), "ROI", d, row.names = FALSE, append = TRUE)   

            }
            
            if(Sys.getenv("RSTUDIO") == "1") dev.off()
                flush.console() 
            cat(i, "of", nrow(f), "\n" )

        }



    }
    )

#' Check out defined ROI-s
#' Check out defined ROI-s
#' @export
#' @examples
#' \dontrun{
#' require(colorZapper)
#' dir = system.file(package = "colorZapper", "sample")
#' CZopen(path = tempfile() )
#' CZaddFiles(dir)
#' CZdefine(points = 1)
#' CZdefine(polygons = 1, what = 1)
#' CZcheck()
#' }
CZcheck <- function(file = tempfile(fileext = ".pdf") ) {
    stopifnot( colorZapper_file_active())

    d = db2list(getOption('cz.con'))


    pdf(file)
    pb = txtProgressBar(1, length(d$files$id), style=3)
    message('Printing images and marks to pdf ...')

    for(i in d$files$id ) {
        
        setTxtProgressBar(pb, i)

        fi = d$files[d$files$id == i, 'path'] 
        ri = raster::brick( fi ) 
        roii = lapply(d$ROI[d$ROI$id == i, 'wkt'], rgeos::readWKT)
        
        plotRGB(ri, margins = TRUE, main = basename(fi) )

        for(j in roii) {
            if( inherits(j, "SpatialPoints") ) 
                points(j, col = "red", cex = 2) else
            plot(j, border = "red", lwd = 2, col = adjustcolor("red", 0.4) , add = TRUE)
        }


    }

    dev.off()
    message("Trying to open", file)
    system(file)

}






