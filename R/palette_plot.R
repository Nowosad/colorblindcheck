#' Plot Palette And Its Color Vision Deficiencies
#' 
#' Plot of the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia.
#'
#' @param x A vector of hexadecimal color descriptions
#' @param severity Severity of the color vision defect, a number between 0 and 1
#' 
#' @importFrom graphics par plot rect text
#' 
#' @seealso palette_bivariate_plot
#'
#' @return A plot with the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia
#' @export
#'
#' @examples
#' rainbow_pal = rainbow(n = 7)
#' rainbow_pal
#' palette_plot(rainbow_pal)
#' 
#' palette_plot(x = rcartocolor::carto_pal(7, "Sunset"))
#' palette_plot(x = rcartocolor::carto_pal(11, "Safe"))
#' palette_plot(x = rcartocolor::carto_pal(7, "Earth"))
#' palette_plot(x = rcartocolor::carto_pal(11, "Vivid"))

palette_plot = function(x, severity = 1){
  deu = colorspace::deutan(x, severity = severity)
  pro = colorspace::protan(x, severity = severity)
  tri = colorspace::tritan(x, severity = severity)
  
  y = list(tri, pro, deu, x)
  
  my_n = length(x)
  n_colors = 4
  ylim = c(0, n_colors)
  
  oldpar = par(mgp = c(2, 0.25, 0))
  on.exit(par(oldpar))
  plot(
    1,
    1,
    xlim = c(0, max(my_n)),
    ylim = ylim,
    type = "n",
    axes = FALSE,
    bty = "n",
    xlab = "",
    ylab = ""
  )
  
  for (i in seq_len(n_colors)) {
    rect(
      xleft = 0:(my_n - 1),
      ybottom = i - 1,
      xright = 1:my_n,
      ytop = i - 0.2,
      col = y[[i]],
      border = "light grey"
    )
  }
  text(
    rep(0, n_colors),
    (1:n_colors) - 0.6,
    labels = c("Tritanopia", "Protanopia", "Deuteranopia", "Normal"),
    xpd = TRUE,
    adj = 1
  )
}

#' Plot Bivariate Palette And Its Color Vision Deficiencies
#' 
#' Plot of the original input bivariate palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia.
#'
#' @param x A vector of hexadecimal color descriptions
#' @param severity Severity of the color vision defect, a number between 0 and 1
#' 
#' @seealso palette_plot
#'
#' @return A plot with the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia
#' 
#' @export
#'
#' @examples
#' palette_bivariate_plot(x = rcartocolor::carto_pal(4, "Sunset"))
palette_bivariate_plot = function(x, severity = 1){
  deu = colorspace::deutan(x, severity = severity)
  pro = colorspace::protan(x, severity = severity)
  tri = colorspace::tritan(x, severity = severity)
  
  y = rev(list(tri, pro, deu, x))
  labels = rev(c("Tritanopia", "Protanopia", "Deuteranopia", "Normal"))
  
  my_n = length(x)
  n_colors = 4
  ylim = c(0, n_colors)
  
  ncol = length(x)
  # if(missing(nx)) {
    nx = sqrt(ncol)
  # }
  # if(missing(ny)) {
    ny = nx
  # }
  
  oldpar = par(mfrow = c(2, 2), mar = rep(1, 4))
  on.exit(par(oldpar))
  
  for (i in seq_len(n_colors)) {
    graphics::image(
      matrix(1:ncol, nrow = ny),
      axes = FALSE,
      col = y[[i]],
      main = labels[[i]],
      asp = 1
    )
  }

}

