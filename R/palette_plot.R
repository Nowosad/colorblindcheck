#' Title
#'
#' @param x 
#' 
#' @importFrom graphics par plot rect text
#'
#' @return
#' @export
#'
#' @examples
#' palette_plot(x = rcartocolor::carto_pal(7, "Sunset"))
#' palette_plot(x = rcartocolor::carto_pal(11, "Safe"))
#' palette_plot(x = rcartocolor::carto_pal(7, "Earth"))
#' palette_plot(x = rcartocolor::carto_pal(11, "Vivid"))

palette_plot = function(x){
  deu = colorspace::deutan(x)
  pro = colorspace::protan(x)
  tri = colorspace::tritan(x)
  
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
    rep(-0.1, n_colors),
    (1:n_colors) - 0.6,
    labels = c("Tritanopia", "Protanopia", "Deuteranopia", "Normal"),
    xpd = TRUE,
    adj = 1
  )
}