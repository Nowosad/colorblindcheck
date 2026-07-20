# create a divergent green-red map

library(tmap)
library(spData)

tm <- tm_shape(world) +
  tm_polygons(
    fill = "lifeExp",
    fill.scale = tm_scale_continuous(values = c("red", "green")),
    fill.legend = tm_legend(show = FALSE)
  ) +
  tm_crs("auto") +
  tm_layout(frame = FALSE)

tmap_save(tm, "inst/image/map.png", device = ragg::agg_png, width = 1800, height = 900)
tinyimg::tinypng("inst/image/map.png", lossy = 1)
file.rename("inst/image/map_l1.png", "inst/image/map.png")
