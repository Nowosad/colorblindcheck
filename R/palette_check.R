#' Compare Palette with Color Vision Deficiencies
#' 
#' Comparision of the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia.
#'
#' @param x A vector of hexadecimal color descriptions
#' @param tolerance The minimal value of acceptable difference between the colors to distinguish between them. As the default, minimal distance between colors in the original input palette is given.
#' @param plot If TRUE, display a plot comparing the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia
#' @param bivariate If TRUE (and plot = TRUE), display a bivariate plot (plot where colors are located in columns and rows) comparing the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia
#' @param severity Severity of the color vision defect, a number between 0 and 1
#' @param ... Other arguments passed on to [palette_dist()] to control the color metric
#'
#' @return A data.frame with 4 observations and 8 variables:
#' * name: orginal input color palette (normal), deuteranopia, protanopia, and tritanopia
#' * n: number of colors
#' * tolerance: minimal value of acceptable difference between the colors to distinguish between them
#' * ncp: number of color pairs
#' * ndcp: number of differentiable color pairs (color pairs with distances above the tolerance value)
#' * min_dist: minimal distance between colors
#' * mean_dist: average distance between colors
#' * max_dist: maximal distance between colors
#' 
#' Additionally, a plot comparing the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia can be shown.
#' @export
#'
#' @examples
#' rainbow_pal = rainbow(n = 7)
#' rainbow_pal
#' palette_check(rainbow_pal, plot = TRUE)
#' 
#' x = rcartocolor::carto_pal(11, "Vivid")
#' palette_check(x)
#' palette_check(x, plot = TRUE)
#' palette_check(x, tolerance = 1)
#' palette_check(x, tolerance = 10, metric = 1976)
#' palette_check(x, plot = TRUE, severity = 0.5)
#' 
#' y = rcartocolor::carto_pal(4, "Sunset")
#' palette_check(y, plot = TRUE, bivariate = TRUE, severity = 0.5)
palette_check = function(x, tolerance = NULL, plot = FALSE, bivariate = FALSE, severity = 1, ...){

  x_dist = palette_dist(x)
  deu_dist = palette_dist(x, cvd = "deu", severity = severity, ...)
  pro_dist = palette_dist(x, cvd = "pro", severity = severity, ...)
  tri_dist = palette_dist(x, cvd = "tri", severity = severity, ...)
  
  # number of colors
  nc = length(x)

  # number of color pairs
  ncp = length(x) * (length(x) - 1) / 2

  # difference tolerance
  if (is.null(tolerance)){
    tolerance = min(x_dist, na.rm = TRUE)
  }

  # number of differentiable color pairs 
  # deuteranopia
  x_ncp = ncp - sum(x_dist < tolerance, na.rm = TRUE)
  deu_ncp = ncp - sum(deu_dist < tolerance, na.rm = TRUE)
  pro_ncp = ncp - sum(pro_dist < tolerance, na.rm = TRUE)
  tri_ncp = ncp - sum(tri_dist < tolerance, na.rm = TRUE)
  
  # distance_hists = c(
  #   spark_hist(x_dist),
  #   spark_hist(deu_dist),
  #   spark_hist(pro_dist),
  #   spark_hist(tri_dist)
  # )
  if (plot && bivariate){
    palette_bivariate_plot(x, severity = severity)
  } else if (plot){
    palette_plot(x, severity = severity)
  }
  
  output = data.frame(
    name = c("normal", "deuteranopia", "protanopia", "tritanopia"),
    n = nc,
    tolerance = tolerance,
    ncp = ncp,
    ndcp = c(x_ncp, deu_ncp, pro_ncp, tri_ncp),
    min_dist = c(min(x_dist, na.rm = TRUE), min(deu_dist, na.rm = TRUE), 
                 min(pro_dist, na.rm = TRUE), min(tri_dist, na.rm = TRUE)),
    mean_dist = c(mean(x_dist, na.rm = TRUE), mean(deu_dist, na.rm = TRUE),
                  mean(pro_dist, na.rm = TRUE), mean(tri_dist, na.rm = TRUE)),
    max_dist = c(max(x_dist, na.rm = TRUE), max(deu_dist, na.rm = TRUE), 
                 max(pro_dist, na.rm = TRUE), max(tri_dist, na.rm = TRUE))
    # distances = distance_hists
  )
  
  oopts = options(digits = 2)
  on.exit(options(oopts)) 
  
  output

}

