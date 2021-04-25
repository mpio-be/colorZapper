#' db as a list of data.frame-s
#' @export
#' @importFrom magrittr %>%
#' @examples
#' \dontrun{
#'  db2list(con)
#'  }
db2list <- function(con) {
    tnams = dbGetQuery(con, "SELECT name FROM sqlite_master WHERE type='table'")
    sapply(tnams$name, function(x)  dbGetQuery(con, paste("SELECT * FROM", x) ) )
}

#' Show db status
#' Show db status
#' @export
#' @examples
#' \dontrun{
#'  CZshowStatus()
#'  }
CZshowStatus <- function() {
    stopifnot( colorZapper_file_active())
    d = dbGetQuery(getOption('cz.con'), "
        SELECT count(id) replicates, id, processed, mark, fileName FROM 
        (select f.id, CASE WHEN r.id is null then 0  else 1 END as processed, mark, 
        CASE WHEN instr(wkt, 'MULTIPOINT')  THEN 'points' 
        WHEN instr(wkt, 'MULTIPOLYGON') THEN  'polygons'  END as selected,
        path fileName
        from files f left join ROI r on f.id = r.id )
        GROUP BY id, mark, fileName     
        ")
    
    
    d$fileName = gsub("((\\.(?i)(jpg|jpeg|png|gif|bmp|tif|tiff))$)", "", basename(d$fileName), 
        ignore.case = TRUE )
    d
} 

#' colorZapper data
#' colorZapper data
#' @export
#' @examples
#' \dontrun{
#'  CZdata(what = 'ROI')
#'  }
CZdata <- function(what = c('ROI', 'ALL')) {
    stopifnot( colorZapper_file_active())

    if(what == 'ROI')
        sql = "SELECT R, G, B, f.id, w.mark, f.path FROM ROI_RGB  c 
    JOIN  ROI w ON c.roi_PK = w.pk
    JOIN files f  ON f.id = w.id"
    if(what == 'ALL')                    
        sql = "SELECT R, G, B, f.id, f.path FROM ALL_RGB a 
    JOIN files f  ON f.id = a.all_pk"

    d = dbGetQuery(getOption('cz.con'), sql) %>%  data.table

    d[!is.na(R), hexCol := rgb(R, G, B, maxColorValue = 255) ]
    
    cbind(d, data.frame(t( rgb2hsv(  t(d[, c("R", "G", "B")])  ))) )


}



