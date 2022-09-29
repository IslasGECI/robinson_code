library(tidyverse)
library(terra)
library(ggspatial)
library(eradicate)


plot_camera_positons_in_square_grid <- function(coordinates_path = "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv", camera_sightings_path = "data/Camera-Traps.csv", crusoe_shp_path = "data/spatial/Robinson_Coati_Workzones_Simple.shp", square_grid_path = "data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp", plot_output_path) {
  crusoe_shp <- sf::read_sf(crusoe_shp_path)
  square_grid <- sf::read_sf(square_grid_path)
  camera_observations <- get_camera_observations(camera_sightings_path = camera_sightings_path, coordinates_path = coordinates_path)
  camera_locations <- camera_observations[["locations"]]
  # Quick plot of grid cells and camera locations
  png(file = plot_output_path, width = 600, height = 350)
  plot(sf::st_geometry(crusoe_shp))
  plot(sf::st_geometry(square_grid), add = TRUE)
  plot(sf::st_geometry(camera_locations), add = TRUE, pch = 16, col = "red")
  dev.off()
}
