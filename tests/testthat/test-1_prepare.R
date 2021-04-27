


test_that("Project exists in .GlobalEnv. ", {
    CZopen(path = tempfile() )

    expect_true( colorZapper_file_active() )

    })    

test_that("A corrupt project is correctly identified. ", {
    cz = tempfile() 
    CZopen(path = cz)
    DBI::dbExecute(getOption('cz.con'), 'DROP table nfo')
    expect_false( colorZapper_file_active() )
    })


