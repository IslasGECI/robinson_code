# ---------------------------------------------------------------
#
# Script for processing and analysing the camera detection data
# from isla Robinson Crusoe
#
#----------------------------------------------------------------
library(tidyverse)
library(sf)
library(terra)
library(ggspatial)
library(eradicate)
library(robinson)


crusoe <- read_sf("data/spatial/Robinson_Coati_Workzones_Simple.shp")
square_grid <- read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp")
camera_sightings_path <- "data/Camera-Traps.csv"
camera_sightings <- read_csv(camera_sightings_path, show_col_types = FALSE)
buffer_radius <- 500 # m  This should depend on grid size, which should depend on HR size
grid_cell <- sf::read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp")
habitats <- terra::rast("data/spatial/VegetationCONAF2014_50mHabitat.tif")
grid_clip <- make_grid_square(crusoe, square_grid)

options <- geci.optparse::get_options()

initial_date <- options[["initial_date"]]
final_date <- options[["final_date"]]

months <- get_months_between(initial_date, final_date)
for (session in months) {
  Filter_Data_Structure <- Filter_Data_Structure$new(camera_sightings)
  camera_sightings_filtered <- Filter_Data_Structure$get_data_by_month(month = session)
  camera_observations <- get_camera_observations(camera_sightings = camera_sightings_filtered)
  pred_grid <- get_population_estimate(camera_observations, grid_cell, grid_clip, crusoe_shp = crusoe, buffer_radius = buffer_radius, square_grid = square_grid, habitats)
  plot_output_path <- glue::glue("data/plot_pred_grid_{session}.png")
  plot_population_prediction_per_grid(propulation_prediction_per_grid = pred_grid, plot_output_path = plot_output_path)
}
