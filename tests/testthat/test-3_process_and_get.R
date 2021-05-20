

test_that("CZextract* function works", {
    registerDoParallel(2)
    CZopen_example()
    expect_true( CZextractROI() )
    expect_true( CZextractALL() )

    stopImplicitCluster()

    })



test_that("CZdata gets a data.table", {
     d = CZdata()
     expect_s3_class(d,  'data.table')
    })




