[![Build Status](https://travis-ci.org/valcu/colorZapper.svg?branch=master)](https://travis-ci.org/valcu/colorZapper)

colorZapper
===========
Color extraction utilities


```Schene
require(devtools)
install_github("rstats-db/RSQLite")
install_github("valcu/colorZapper")
```


```Schene
require(colorZapper)
dir = system.file(package = "colorZapper", "sample")
CZopen(path = tempfile() )
CZaddFiles(dir)

CZdefine(points = 2)
CZdefine(polygons = 1)
CZdefine(polygons = 1, marks = c("wing", "tail"), what = 2 )

CZshowStatus()
CZextractRGB()
d = CZdata()
```
