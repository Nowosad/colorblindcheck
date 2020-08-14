library(testthat)
library(colorblindcheck)
rainbow_pal = rainbow(n = 7)
rainbow_pal

sunset_pal = rcartocolor::carto_pal(4, "Sunset")
sunset_pal

test_check("colorblindcheck")
