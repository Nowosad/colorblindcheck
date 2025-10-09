context("palette_plot")
test_that("plot works", {
        skip_on_cran()
        rainbow_pal = grDevices::rainbow(n = 7)
        A1 = function() palette_plot(rainbow_pal)
        vdiffr::expect_doppelganger("a1", A1)
        
        sunset_pal = rcartocolor::carto_pal(4, "Sunset")
        A2 = function() palette_bivariate_plot(sunset_pal)
        vdiffr::expect_doppelganger("a2", A2)  
        
        A3 = function() palette_plot(rainbow_pal, show_hex = TRUE)
        vdiffr::expect_doppelganger("a3", A3)
        
})
