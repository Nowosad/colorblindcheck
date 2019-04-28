#' Distance Between Colors
#' 
#' Calculation of the distances between the colors in the input palette.
#' It also allows for calculation of the distances between the colors in a simulations of the  color vision deficiency - deuteranopia, protanopia, and tritanopia.
#'
#' @param x A vector of hexadecimal color descriptions
#' @param cvd A type of color vision deficiency (CVD): "pro" (protanomaly), "deu" (deutanomaly), or "tri" (tritanomaly)
#' @param severity Severity of the color vision defect, a number between 0 and 1
#' @param metric A vector of color metric specifiers. Valid values are '1976', '1994', and '2000' (default), which refer to the year the metric  was recommended by the CIE
#'
#' @return A matrix of distances between the original input palette and a simulation of the  selected color vision deficiency - deuteranopia, protanopia, and tritanopia
#' @export
#'
#' @examples
#' rainbow_pal = rainbow(n = 7)
#' rainbow_pal
#' palette_dist(rainbow_pal)
#' palette_dist(rainbow_pal, cvd = "deu")
#' 
#' x = rcartocolor::carto_pal(11, "Vivid")
#' palette_dist(x)
#' palette_dist(x, cvd = "pro", severity = 1)
#' palette_dist(x, cvd = "pro", severity = 0.2)
#' 
palette_dist = function(x, cvd = NULL, severity = 1, metric = 2000){
  
  if (!is.null(cvd)){
    x = switch(
      cvd,
      deu = colorspace::deutan(x, severity = severity),
      pro = colorspace::protan(x, severity = severity),
      tri = colorspace::tritan(x, severity = severity)
    )
  }

  a = methods::as(colorspace::hex2RGB(x), "LAB")@coords
  a_list = lapply((1:dim(a)[1]), function(x) a[x[1], ])
  
  a_output = lapply(a_list, spacesXYZ::DeltaE, a, metric = metric)
  a_output = do.call(rbind, a_output)
  
  a_output[lower.tri(a_output, diag = TRUE)] = NA
  a_output
}
