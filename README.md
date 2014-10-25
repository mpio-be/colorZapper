[![Build Status](https://travis-ci.org/valcu/colorZapper.svg?branch=master)](https://travis-ci.org/valcu/colorZapper)

colorZapper
===========
Extract colour from photos interactively

```R
require(devtools)
install_github("rstats-db/RSQLite")
install_github("valcu/colorZapper")
```

```R
require(colorZapper)
# path to image directory
dir = system.file(package = "colorZapper", "sample")
# open/create a colorZapper file
CZopen(path = tempfile() )
# associate files with the opened file
CZaddFiles(dir)
```

```R
#interactively define points or polygons

# define 1 point per image
CZdefine(points = 1)

# check status
CZshowStatus()

# over-write points defined for Falco_peregrinus (id = 2)
CZdefine(points = 1, what  = 2)
CZshowStatus()
# define points using marks
# 2 points per mark = 4 points per image
# 'what' is set so only particular images are going to be loaded
CZdefine(points = 1, marks = c("wing", "tail"), what = 4 )
CZshowStatus()

#define polygons: 1 polygon per mark
# once a polygon is drew press ESC 
CZdefine(polygons = 1, marks = c("wing", "tail"), what = 3 )
```

```R

# extract RGB values
CZextractRGB()

# fetch data
d = CZdataFrame(fun = median)
head(d)
barplot(rep(1, nrow(d)), col = d$hexCol)

#check defined regions
 CZcheck()

```












