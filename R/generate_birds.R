

#' Title generate birds
#' Title generate n species (both sexes) with males (slightly) more colorful than females 
#'
#' @param n No of species
#' @param body_parts one of: "crown", "forehead", "lore", "chin", "throat", "nape", "ear-coverts", "breast", "mantle",  "scapulars", "coverts", "alula", "flight-feathers", "flank", "back", "rump", "belly", "vent", "tail".  Default to all
#' @param dir Directory to save images
#' @param res  	Resolution, in dots per inch.
#'
#' @importFrom data.table  setDT
#' @importFrom sf  plot_sf
#' @importFrom scales  rescale
#' 
#' @return dir
#' @export
#'
#' @examples
#' f = generateBirds(n = 10) 
#' f = generateBirds(n = 10, body_parts = "flight-feathers") 
#' 

generateBirds <- function(n, dir = tempdir(), body_parts, res = 10) {
		
		x = BirdBodyParts
		data.table::setDT(x)
		
		if(missing(body_parts) ) body_parts = setdiff(x$parts, c('feet', 'eye', 'bill'))

		message("Saving ", n*2,  " birds to ", dir, ' ...')


		# rnorm hsv colors
		X = data.table(ID = rep(1:n, each = nrow(x)), parts = x$parts)
		X = merge(X, x, by = 'parts', allow.cartesian  = TRUE, sort = FALSE)
		
		X[, ":=" (hf = scales::rescale(rnorm(n=.N)) , 
				  sf = scales::rescale(rnorm(n=.N)) , 
				  vf = scales::rescale(rnorm(n=.N))  ) ]

		X[, ":=" (hm = scales::rescale(rnorm(n=.N)) , 
				  sm = scales::rescale(rnorm(n=.N)) , 
				  vm = scales::rescale(rnorm(n=.N))  ) ]

		X[, female_col := hsv(hf,sf,vf), by = 1:nrow(X)]
		
		X[, male_col := hsv(hm,sm,vm), by = 1:nrow(X)]
		
		X[!parts%in% body_parts, ':=' (female_col= 'grey', male_col = 'grey')]



		# save images as png
		for(i in unique(X$ID))	{
			xi = X[ID == i]
			# save female
			bitmap(file = paste0(dir,"/", sprintf("%02d", i), '_f.png')  , type = "pngalpha", res = res)
				par(mar = c(0,0,0,0) )
				plot(xi$geometry, col = xi$female_col, main = NA, border = NA)
				dev.off()
				
			# save male
			bitmap(file = paste0(dir,"/", sprintf("%02d", i), '_m.png')  , type = "pngalpha", res = res)
				par(mar = c(0,0,0,0) )
				plot(xi$geometry, col = xi$male_col, main = NA, border = NA)
				dev.off()
			

		}

		message('done\n')

		dir




}