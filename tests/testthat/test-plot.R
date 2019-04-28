context("palette_plot")
test_that("plot works", {
        skip_on_cran()
        A1 = function() palette_plot(rainbow_pal)
        vdiffr::expect_doppelganger("a1", A1)
})
