

#' Title generate birds
#' Title generate n species (both sexes) with males (slightly) more colorful than females 
#'
#' @param n No of species
#' @param body_parts one of: "crown", "forehead", "lore", "chin", "throat", "nape", "ear-coverts", "breast", "mantle", "scapulars", "coverts", "alula", "flight-feathers", "flank", "back", "rump", "belly", "vent", "tail". Default to all

#' @param dir Directory to save images
#'
#' @return dir
#' @export
#'
#' @examples
#'\dontrun{
#' f = generateBirds(n = 10) 
#' cz_file = tempfile(fileext = '.sqlite')
#' CZopen(path = cz_file)
#' CZaddFiles(f)
#' CZextractALL()
#' d = CZdata(what = 'ALL')
#' 
#' 
#' 
#' 
#' 
#'} 
generateBirds <- function(n, dir = tempdir(), body_parts) {
		
		x = colorZapper:::BirdBodyParts
		setDT(x)
		
		if(missing(body_parts) ) body_parts = setdiff(x$parts, c('feet', 'eye', 'bill'))

		message("Saving ", n*2,  " birds to ", dir, ' ...')

		x[, id := 1:nrow(x)]

		x[!parts%in% body_parts, col := 'grey']

		# male parts
		maleParts = x[parts%in% body_parts, sample(parts, 5) %>% as.character ]
		
		ff = function() {
			runif(1, max = sample( seq(0.1, 1, by = 0.01), 1 ) )
			}

		# save images as png
		for(i in 1:n)	{
		  x[, ":=" (h = ff(), s = ff(), v = ff() ), by = id]		
   		x[parts%in% body_parts, col := hsv(h,s,v), by = id]

   		# save female
   		bitmap(file = paste0(dir,"/", sprintf("%02d", i), '_f.png')  , type = "pngalpha")
			par(mar = c(0,0,0,0) )
			plot(x$geometry, col = x$col, main = NA, border = NA)
			dev.off()

			# save male
			bitmap(file = paste0(dir,"/", sprintf("%02d", i), '_m.png')  , type = "pngalpha")
			par(mar = c(0,0,0,0) )
			x[parts%in%maleParts, ':=' (h=0.9, s = 0.5)]
			x[parts%in%maleParts, col := rgb(h,s,v), by = id]
			plot(x$geometry, col = x$col, main = NA, border = NA)
			dev.off()

		}

		message('done\n')

		dir




}