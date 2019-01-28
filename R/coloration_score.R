# ==========================================================================
# Compute color scores by mark and save to color_scores
# Nature 527.7578 (2015): 367-370
# ==========================================================================



#' Compute color scores
#' @examples
#' \dontrun{
#' 
#' f = generateBirds(n = 100) 
#' cz_file = tempfile(fileext = '.sqlite')
#' CZopen(path = cz_file)
#' CZaddFiles(f)
#' CZextractALL()
#' d = CZdata(what = 'ALL')
#' d[, sex := stringr::str_split(path, '_', simplify = TRUE)[2], by = 1:nrow(d)]
#' d = d[, .(R = mean(R), G = mean(G), B = mean(B)), by = .(id,sex, path)]
#' 
#' x =color_scores(d, maleLevel = 'm.png', prob = 0.05)
#' 
#' z = merge(x[, .(id, col_score)], d, by = 'id')
#' z[, col := rgb(R,G,B, maxColorValue = 255), by = 1:nrow(z)]
#' setorder(z, col_score)
#' scales::show_col(z$col, borders = NA, labels = FALSE)
#' 
#' }
#' 
#' @importFrom data.table  copy set setnames setorder melt .I
#' @importFrom stringr  str_split
#' @export



color_scores <- function(d, rgb = c('R','G','B'), id = 'id', sex = 'sex', maleLevel , prob = 0.01 , ... ) {

	# align
		x = d[, c(rgb, id, sex), with = FALSE]
		setnames(x, c('R','G','B', 'id', 'sex') )

		x[, k := .I]

	 # N
	 N = ceiling(prob * nrow(x)	) %>% round
	 if(N < 3) warning("color score is based on ", N, " points only, increase prob ?")



	# compute all distances 
		dst = x[, .(R,G,B) ] %>% dist(method = "euclidean", diag = FALSE) 
		dst = melt(as.matrix(dst),  na.rm = TRUE ) %>% data.table %>% .[value > 0]
		setnames(dst, c('k1','k2', 'v') )

	# compute scores
	for(i in x$k) {
		dsti = dst[k1 ==i]
		setorder(dsti, -v) # or otherwise use quantile()

		o = merge(dsti[1:N], x[, .(k, sex)], by.x = 'k2', by.y = 'k'  )

		# score: prop male-like
		csc = o[sex== maleLevel] %>% nrow / nrow(o)

		set(x, i = i, 'col_score', csc)
	
		}


		x
	
	}



















