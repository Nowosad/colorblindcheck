#' Title
#'
#' @param x 
#' @param tolerance 
#' @param plot
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
#' x = rcartocolor::carto_pal(11, "Vivid")
#' palette_check(x)
#' palette_check(x, plot = TRUE)
#' palette_check(x, tolerance = 1)
#' palette_check(x, tolerance = 10, metric = 1976)
palette_check = function(x, tolerance = NULL, plot = FALSE, ...){

  x_dist = palette_dist(x)
  deu_dist = palette_dist(x, cvd = "deu", ...)
  pro_dist = palette_dist(x, cvd = "pro", ...)
  tri_dist = palette_dist(x, cvd = "tri", ...)
  
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
  
  if (plot){
    palette_plot(x)
  }
  
  output = data.frame(
    name = c("normal", "deuteranopia", "protanopia", "tritanopia"),
    n = nc,
    tolerance = tolerance,
    ncp = ncp,
    ndcp = c(x_ncp, deu_ncp, pro_ncp, tri_ncp),
    min_dist = c(min(x_dist, na.rm = TRUE), min(deu_dist, na.rm = TRUE), min(pro_dist, na.rm = TRUE), min(tri_dist, na.rm = TRUE)),
    mean_dist = c(mean(x_dist, na.rm = TRUE), mean(deu_dist, na.rm = TRUE), mean(pro_dist, na.rm = TRUE), mean(tri_dist, na.rm = TRUE)),
    max_dist = c(max(x_dist, na.rm = TRUE), max(deu_dist, na.rm = TRUE), max(pro_dist, na.rm = TRUE), max(tri_dist, na.rm = TRUE))
    # distances = distance_hists
  )
  
  oopts = options(digits = 2)
  on.exit(options(oopts)) 
  
  output

}

