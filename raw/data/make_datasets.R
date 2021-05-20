

require(colorZapper)
CZopen(path = './raw/data/colorZapper.sqlite', overwrite = TRUE)
CZaddFiles(system.file(package = 'colorZapper', 'sample'))

CZdefine(points = 1, marks = 'head') # the 5th point is out of image
CZdefine(polygons = 1, marks = c('wing', 'tail') ) 
CZdefine(polygons = 1, marks = c('wing', 'tail'), what = 5 ) # make last 2 polygons self-intersecting

CZsetwd(NA)

file.copy('./raw/data/colorZapper.sqlite', './inst/cz_example', overwrite = TRUE)




