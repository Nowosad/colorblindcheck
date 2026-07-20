#' Extract a Representative Color Palette from an Image
#'
#' Extracts a small set of representative colors from an image. The result is
#' a character vector of hexadecimal colors that can be passed to
#' [palette_dist()].
#'
#' @param x A path to an image file or a `magick-image` object.
#' @param n_colors Number of representative colors to extract.
#' @param sample_pixels Number of pixels to sample from the image before quantization.
#' @param resize Maximum image dimension used for sampling. Set to `NULL` to preserve image size.
#'
#' @return A character vector of hexadecimal color codes.
#' @export
#'
#' @examples
#' if (requireNamespace("magick", quietly = TRUE)) {
#'   img <- magick::image_read(system.file("image", "map.png", package = "colorblindcheck"))
#'   image_to_palette(img, n_colors = 10)
#' }
image_to_palette <- function(x, n_colors = 8, sample_pixels = 2000, resize = 200) {
  if (!requireNamespace("magick", quietly = TRUE)) {
    stop("Package 'magick' is required to extract colors from an image.")
  }

  if (!is.numeric(n_colors) || length(n_colors) != 1 || n_colors <= 0) {
    stop("n_colors must be a single positive number.")
  }
  if (!is.numeric(sample_pixels) || length(sample_pixels) != 1 || sample_pixels <= 0) {
    stop("sample_pixels must be a single positive number.")
  }

  if (is.character(x) && length(x) == 1) {
    x <- magick::image_read(x)
  }

  if (!inherits(x, "magick-image")) {
    stop("x must be a path to an image file or a magick image object.")
  }

  if (!is.null(resize)) {
    if (!is.numeric(resize) || length(resize) != 1 || resize <= 0) {
      stop("resize must be NULL or a single positive number.")
    }
    x <- magick::image_scale(x, paste0(as.integer(resize), "x", as.integer(resize)))
  }

  img_data <- magick::image_data(x, "rgb")
  r <- as.integer(img_data[1, , ])
  g <- as.integer(img_data[2, , ])
  b <- as.integer(img_data[3, , ])
  rgb <- cbind(r = as.vector(r), g = as.vector(g), b = as.vector(b))

  if (nrow(rgb) == 0) {
    return(character())
  }

  if (nrow(rgb) > sample_pixels) {
    rgb <- rgb[sample(seq_len(nrow(rgb)), sample_pixels), , drop = FALSE]
  }

  pixel_counts <- as.data.frame(table(r = rgb[, 1], g = rgb[, 2], b = rgb[, 3]), stringsAsFactors = FALSE)
  pixel_counts$r <- as.integer(pixel_counts$r)
  pixel_counts$g <- as.integer(pixel_counts$g)
  pixel_counts$b <- as.integer(pixel_counts$b)
  pixel_counts$Freq <- as.integer(pixel_counts$Freq)
  pixel_counts <- pixel_counts[order(-pixel_counts$Freq), ]
  rgb_unique <- as.matrix(pixel_counts[, c("r", "g", "b")])

  if (nrow(rgb_unique) <= n_colors) {
    return(grDevices::rgb(rgb_unique[, 1], rgb_unique[, 2], rgb_unique[, 3], maxColorValue = 255))
  }

  lab <- methods::as(colorspace::RGB(rgb / 255), "LAB")@coords
  clusters <- stats::kmeans(lab, centers = n_colors, nstart = 5, iter.max = 20)

  order_index <- order(-clusters$size, clusters$withinss)
  centers <- clusters$centers[order_index, , drop = FALSE]

  rgb_centers <- methods::as(colorspace::LAB(centers), "RGB")
  rgb_coords <- colorspace::coords(rgb_centers)
  rgb_coords <- pmax(pmin(rgb_coords, 1), 0)

  unname(colorspace::hex(colorspace::RGB(rgb_coords)))
}
