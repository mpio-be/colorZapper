
# TODO: save project to inst

require(colorZapper)
# path to image directory
dir = system.file(package = "colorZapper", "sample")
# open/create a colorZapper file
cz_file = tempfile(fileext = '.sqlite')
CZopen(path = cz_file)
# associate files with the opened file
CZaddFiles(dir)

CZdefine(points = 1)

CZdefine(polygons = 1, marks = c("wing", "tail") )


CZextractROI()

