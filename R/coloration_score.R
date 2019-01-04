# ==========================================================================
# Compute color scores by mark and save to color_scores
# Nature 527.7578 (2015): 367-370
# ==========================================================================



#' Compute color scores
#' @examples
#' /donotrun{
#' 
#' f = generateBirds(n = 100) 
#' cz_file = tempfile(fileext = '.sqlite')
#' CZopen(path = cz_file)
#' CZaddFiles(f)
#' CZextractALL()
#' d = CZdata(what = 'ALL')
#' d[, sex := stringr::str_split(path, '_', simplify = TRUE)[2], by = 1:nrow(d)]
#' 
#' x =color_scores(d, maleLevel = 'm.png', prob = 0.05)
#' }
#' 
#' @importFrom data.table  copy set setnames melt .I
#' @importFrom stringr  str_split
#' @export



color_scores <- function(d, rgb = c('R','G','B'), id = 'id', sex = 'sex', maleLevel , group = mean, prob = 0.01 , ... ) {

	# group by id and sex
		x = d[, c(rgb, id, sex), with = FALSE]
		setnames(x, c('R','G','B', 'id', 'sex') )

		x = x[, .(R = group(R, ...), G = group(G, ...), B = group(B, ...)), by = .(id,sex)]
		x[, k := .I]

	# compute all distances 
		dst = x[, .(R,G,B) ] %>% dist(method = "euclidean", diag = FALSE) 
		dst = melt(as.matrix(dst),  na.rm = TRUE ) %>% data.table %>% .[value > 0]
		setnames(dst, c('k1','k2', 'v') )

	# compute scores
	for(i in x$k) {
		dsti = dst[k1 ==i]
		# setorder(dsti, v)

		q = dsti[, quantile(v, probs = 1-prob, na.rm = TRUE)]

		# subset
		ss = dsti[v>=q, k2]
		nmales = x[id %in% ss & sex== maleLevel] %>% nrow

		# score: prop male-like
		csc = nmales/length(ss)

		set(x, i = i, 'col_score', csc)
	
		}


		x
	
	}



















