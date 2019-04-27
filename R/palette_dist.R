#' Title
#'
#' @param x 
#' @param cvd 
#' @param metric a vector of color metric specifiers. Valid values are '1976', '1994', and '2000' (default), which refer to the year the metric  was recommended by the CIE.
#' @param ...
#' 
#'
#' @return
#' @export
#'
#' @examples
#' x = rcartocolor::carto_pal(11, "Vivid")
#' palette_dist(x)
#' palette_dist(x, cvd = "deu")
#' 
palette_dist = function(x, cvd = NULL, metric = 2000, ...){
  
  if (!is.null(cvd)){
    x = switch(
      cvd,
      deu = colorspace::deutan(x, ...),
      pro = colorspace::protan(x, ...),
      tri = colorspace::tritan(x, ...)
    )
  }

  a = methods::as(colorspace::hex2RGB(x), "LAB")@coords
  a_list = lapply((1:dim(a)[1]), function(x) a[x[1], ])
  
  a_output = lapply(a_list, spacesXYZ::DeltaE, a, metric = metric)
  a_output = do.call(rbind, a_output)
  
  a_output[lower.tri(a_output, diag = TRUE)] = NA
  a_output
}
