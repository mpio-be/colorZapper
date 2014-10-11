



	require(colorZapper)
	dir = system.file(package = "colorZapper", "sample")
	CZopen(path = tempfile() )
	CZaddFiles(dir)
	
	# points, all images, no defined marks
	CZdefine(points = 1)
	# points, all images, marks
	CZdefine(points = 1, marks = c("wing", "tail") )
	# points, selected images
	CZdefine(points = 2, what = c(1,3) )
	#selected images & marks
	CZdefine(points = 2, marks = c("wing", "tail"), what = c(1,3) )


	# polygons, all images, no defined marks
	CZdefine(polygons = 1)
	# polygons, all images, marks
	CZdefine(polygons = 1, marks = c("wing", "tail") )
	# polygons, selected images
	CZdefine(polygons = 2, what = c(1,3) )
	#selected images & marks
	CZdefine(polygons = 2, marks = c("wing", "tail"), what = 4)


	CZshowStatus()

	
	###
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
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	