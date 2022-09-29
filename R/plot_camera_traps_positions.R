library(tidyverse)
library(terra)
library(ggspatial)
library(eradicate)

#' @export
plot_camera_positions_in_square_grid <- function(camera_sightings, crusoe_shp_path = "data/spatial/Robinson_Coati_Workzones_Simple.shp", square_grid_path = "data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp", plot_output_path) {
  crusoe_shp <- sf::read_sf(crusoe_shp_path)
  square_grid <- sf::read_sf(square_grid_path)
  camera_locations <- camera_sightings[["locations"]]
  # Quick plot of grid cells and camera locations
  png(file = plot_output_path, width = 600, height = 350)
  plot(sf::st_geometry(crusoe_shp))
  plot(sf::st_geometry(square_grid), add = TRUE)
  plot(sf::st_geometry(camera_locations), add = TRUE, pch = 16, col = "red")
  dev.off()
}
