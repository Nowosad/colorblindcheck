four_plot = function(x){
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

four_plot(x = rcartocolor::carto_pal(11, "Vivid"))
four_plot(x = rcartocolor::carto_pal(7, "Sunset"))
four_plot(x = rcartocolor::carto_pal(11, "Safe"))
four_plot(x = rcartocolor::carto_pal(7, "Earth"))


x = rcartocolor::carto_pal(11, "Vivid")
deu = colorspace::deutan(x)
pro = colorspace::protan(x)
tri = colorspace::tritan(x)

spacesXYZ::DeltaE(as(hex2RGB(x), "LAB")@coords, as(hex2RGB(deu), "LAB")@coords)

a = as(hex2RGB(x), "LAB")@coords
a_list = lapply(as.list(1:dim(a)[1]), function(x) a[x[1],])

b = as(hex2RGB(deu), "LAB")@coords
b_list = lapply(as.list(1:dim(b)[1]), function(x) b[x[1],])

a_output = lapply(a_list, spacesXYZ::DeltaE, as(hex2RGB(x), "LAB")@coords)
b_output = lapply(b_list, spacesXYZ::DeltaE, as(hex2RGB(deu), "LAB")@coords)


a_output = do.call(rbind, a_output)
b_output = do.call(rbind, b_output)

a_output / b_output
