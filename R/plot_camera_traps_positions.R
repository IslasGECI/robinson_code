library(tidyverse)
library(terra)
library(ggspatial)
library(eradicate)

#' @export
plot_camera_positions_in_square_grid <- function(crusoe_shp, square_grid, camera_sightings, plot_output_path) {
  camera_locations <- camera_sightings[["locations"]]
  # Quick plot of grid cells and camera locations
  png(file = plot_output_path, width = 600, height = 350)
  plot(sf::st_geometry(crusoe_shp))
  plot(sf::st_geometry(square_grid), add = TRUE)
  plot(sf::st_geometry(camera_locations), add = TRUE, pch = 16, col = "red")
  dev.off()
}


#' @export
plot_camera_positions_in_polygons_grid <- function(crusoe_shp, grid, camera_sightings, plot_output_path) {
  gridc <- sf::st_centroid(grid)
  camera_locations <- camera_sightings[["locations"]]
  png(file = plot_output_path, width = 600, height = 350)
  plot(sf::st_geometry(crusoe_shp))
  plot(sf::st_geometry(grid), add = TRUE)
  plot(sf::st_geometry(gridc), add = TRUE)
  plot(sf::st_geometry(camera_locations), add = TRUE, pch = 16, col = "red")
  dev.off()
}
