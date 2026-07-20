context("palette_dist")
test_that("dist is calculated", {
  expect_equal(dim(palette_dist(rainbow_pal)), c(7, 7))
  expect_equal(dim(palette_dist(rainbow_pal)), dim(palette_dist(rainbow_pal, cvd = "deu")))
})

test_that("image_to_palette returns hex colors", {
  skip_if_not_installed("magick")
  img <- magick::image_blank(width = 50, height = 50, color = "#FF0000")
  pal <- image_to_palette(img, n_colors = 1)
  expect_type(pal, "character")
  expect_equal(length(pal), 1)
  expect_true(grepl("^#([A-Fa-f0-9]{6})$", pal))
})

test_that("image_to_palette returns colors sorted by representativeness", {
  skip_if_not_installed("magick")
  red <- magick::image_blank(width = 50, height = 50, color = "#FF0000")
  green <- magick::image_blank(width = 10, height = 50, color = "#00FF00")
  img <- magick::image_composite(red, green, operator = "over", offset = "+0+0")
  pal <- image_to_palette(img, n_colors = 2)
  expect_equal(length(pal), 2)
  expect_equal(pal[1], "#FF0000")
})
