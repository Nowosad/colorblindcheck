context("palette_check")
test_that("output structure is correct", {
  expect_equal(dim(palette_check(rainbow_pal)), c(4, 8))
})

test_that("plot works", {
  skip_on_cran()
  B1 = function() palette_check(rainbow_pal, plot = TRUE)
  vdiffr::expect_doppelganger("b1", B1)
  
  B2 = function() palette_check(sunset_pal, plot = TRUE)
  vdiffr::expect_doppelganger("b2", B2)
})