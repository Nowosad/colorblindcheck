#' Title
#'
#' @param x 
#' @param tolerance 
#' @param ... 
#'
#' @return
#' @export
#'
#' @examples
#' x = rcartocolor::carto_pal(11, "Vivid")
#' palette_check(x)
#' palette_check(x, tolerance = 1)
#' palette_check(x, tolerance = 10, metric = 2000)
palette_check = function(x, tolerance = NULL, ...){

  x_dist = palette_dist(x)
  deu_dist = palette_dist(x, cvd = "deu")
  pro_dist = palette_dist(x, cvd = "pro")
  tri_dist = palette_dist(x, cvd = "tri")
  
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
  
  data.frame(
    name = c("normal", "deuteranopia", "protanopia", "tritanopia"),
    n = nc,
    ncp = ncp,
    ndcp = c(x_ncp, deu_ncp, pro_ncp, tri_ncp)
  )
}

