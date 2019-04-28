#' Plot Palette And Its Color Vision Deficiencies
#' 
#' Plot of the original input palette and simulations of color vision deficiencies - deuteranopia, protanopia, and tritanopia.
#'
#' @param x A vector of hexadecimal color descriptions
#' @param severity Severity of the color vision defect, a number between 0 and 1
#' 
#' @importFrom graphics par plot rect text
#'
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
