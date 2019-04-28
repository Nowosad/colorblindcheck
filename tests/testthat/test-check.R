context("palette_check")
test_that("output structure is correct", {
        expect_equal(dim(palette_check(rainbow_pal)), c(4, 8))
})
