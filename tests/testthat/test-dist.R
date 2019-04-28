context("palette_dist")
test_that("dist is calculated", {
        expect_equal(dim(palette_dist(rainbow_pal)), c(7, 7))
        expect_equal(dim(palette_dist(rainbow_pal)), dim(palette_dist(rainbow_pal, cvd = "deu")))
})
