


test_that("Image file info is loaded correctly ", {
    dir = system.file(package = "colorZapper", "sample")
    p = tempfile() 
    CZopen(path = p)
    
    expect_equal( CZaddFiles(dir), length(list.files(dir, pattern = '.jpg')) )

    czwd = DBI::dbGetQuery(getOption('cz.con'), 'SELECT basedir from nfo')$basedir
    expect_equal(czwd, dir)

    })


test_that("Base directory can be changed", {
    dir = system.file(package = "colorZapper", "sample")
    p = tempfile() 
    CZopen(path = p)
    CZsetwd('/temp/')

    })



test_that("CZopen_example works", {
    CZopen_example()
    expect_true(colorZapper_file_active() )

    })


