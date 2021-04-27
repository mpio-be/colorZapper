

require(colorZapper)
CZopen(path = './raw/data/colorZapper.sqlite', overwrite = FALSE)
CZaddFiles(system.file(package = 'colorZapper', 'sample'))

CZdefine(points = 1, marks = 'head')
CZdefine(polygons = 1, marks = c('wing', 'tail') )

CZextractROI()
CZextractALL()

CZsetwd(NA)

file.copy('./raw/data/colorZapper.sqlite', './inst/cz_example', overwrite = TRUE)




