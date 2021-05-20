

test_that("CZextract* function works", {
    registerDoParallel(1)
    CZopen_example()
    expect_true( CZextractROI() )
    expect_true( CZextractALL() )

    stopImplicitCluster()

    })



test_that("CZdata gets a data.table", {
     d = CZdata(what = 'ROI')
     expect_s3_class(d,  'data.table')
     
     d = CZdata(what = 'ALL')
     expect_s3_class(d,  'data.table')



    })




