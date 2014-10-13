#' Show db status
#' Show db status
#'
#' @examples
#' \dontrun{
#'  CZshowStatus()
#'  }
CZshowStatus <- function() {
	stopifnot( colorZapper_file_active())
	d = dbGetQuery(options()$cz.con, "
	SELECT count(id) replicates, id, processed, mark, fileName FROM 
		(select f.id, CASE WHEN r.id is null then 0  else 1 END as processed, mark, 
			CASE WHEN instr(wkt, 'MULTIPOINT')	THEN 'points' 
				WHEN instr(wkt, 'MULTIPOLYGON')	THEN  'polygons'  END as selected,
				path fileName
					from files f left join ROI r on f.id = r.id )
	GROUP BY id, mark, fileName  	
	")
				
				
	d$fileName = gsub("((\\.(?i)(jpg|jpeg|png|gif|bmp|tif|tiff))$)", "", basename(d$fileName) )
	d
} 


#' colorZapper data
#' colorZapper data
#'
#' @examples
#' \dontrun{
#'  CZdata(fun = median)
#'  }

CZdataFrame <- function(fun = median) {
  
	f = as.character(substitute(fun))
	d = dbGetQuery(options()$cz.con, paste(
	  '
	  SELECT R, G, B, f.ID, w.mark, f.path, wkt
		FROM
		(SELECT', f,'(R) R,', f,'(G) G,', f,'(B) B, roi_pk FROM RGB group by roi_pk) c
	  JOIN 
		ROI w
	  ON c.roi_PK = w.pk
	  JOIN files f 
		ON f.id = w.id
	  order by f.id
	  ') )
	#hsv
	d = cbind(d, data.frame(t( rgb2hsv(  t(d[, c("R", "G", "B")])  ))) )
	# hex
	d$hexCol = rgb(d$R, d$G, d$B, maxColorValue = 255)
	
	d = d[, c("R", "G", "B", "h", "s", "v","hexCol", "id", "mark", "path", "wkt") ]

	d[is.na(d$mark), "mark"] = "not_defined"
	d

}


















