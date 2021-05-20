#' db as a list of data.frame-s
#' @export
db2list <- function(con) {
    tnams = dbGetQuery(con, "SELECT name FROM sqlite_master WHERE type='table'")
    sapply(tnams$name, function(x)  dbGetQuery(con, paste("SELECT * FROM", x) ) )
}

#' Show db status
#' Returns a data.frame containing the status of the current CZ project. 
#' @export
#' @examples
#'  CZopen_example()
#'  CZshowStatus()

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
#' Fetch colorZapper RGB data
#' @param what 'ROI' (gets the data of ROI-s defined interactively) 
#'              or 'ALL' (extracts the color of from all images.)
#' @export
#' @examples
#'  
#' registerDoParallel(2)
#' CZopen_example()
#' CZextractROI()
#' CZextractALL()
#' stopImplicitCluster()
#' d = CZdata()
#' 
#'  }
CZdata <- function(what) {
    stopifnot( colorZapper_file_active())

    if(what == 'ROI')
        sql = "SELECT R, G, B, f.id, w.mark, f.path FROM ROI_RGB  c 
    JOIN  ROI w ON c.roi_PK = w.pk
    JOIN files f  ON f.id = w.id"
    if(what == 'ALL')                    
        sql = "SELECT R, G, B, f.id, f.path FROM ALL_RGB a 
    JOIN files f  ON f.id = a.all_pk"

    dbGetQuery(getOption('cz.con'), sql) %>%  data.table


}



