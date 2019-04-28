library(testthat)
library(colorblindcheck)
rainbow_pal = rainbow(n = 7)
rainbow_pal

test_check("colorblindcheck")
