

require(colorZapper)
CZopen(path = './raw/data/colorZapper.sqlite')
CZaddFiles(system.file(package = 'colorZapper', 'sample'))

CZdefine(points = 1, marks = 'head')
CZdefine(polygons = 1, marks = c('wing', 'tail') )


CZextractROI()

