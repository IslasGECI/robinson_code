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

session <- "2022-9"
Filter_Data_Structure <- Filter_Data_Structure$new(camera_sightings)
camera_sightings_filtered <- Filter_Data_Structure$get_data_by_month(month = session)

camera_observations <- get_camera_observations(camera_sightings = camera_sightings_filtered)

# Quick plot of grid cells and camera locations
plot_output_path <- glue::glue("data/plot_crusoe_{session}.png")
plot_camera_positions_in_square_grid(crusoe, square_grid, camera_observations, plot_output_path)
# Extract habitat information from raster using a buffer around the camera
# locations (size set below).  In this case habitat appears to be categorical
# so we extract the most common habitat type from the buffer area using the mode

# Plot cell predictions
buffer_radius <- 500 # m  This should depend on grid size, which should depend on HR size
grid_cell <- sf::read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp")
habitats <- terra::rast("data/spatial/VegetationCONAF2014_50mHabitat.tif")
grid_clip <- make_grid_square(crusoe, square_grid)
pred_grid <- get_population_estimate(camera_observations, grid_cell, grid_clip, crusoe_shp = crusoe, buffer_radius = buffer_radius, square_grid = square_grid, habitats)

plot_output_path <- glue::glue("data/plot_pred_grid_{session}.png")
plot_population_prediction_per_grid(propulation_prediction_per_grid = pred_grid, plot_output_path = plot_output_path)

#-------------------------------------------------------
#  example using smaller grid of 500 m
#  Note that predictions are sensitive to grid cell size
#  so it needs to be set with some care
#-------------------------------------------------------

buffer_radius <- 250

polygonal_grid <- make_grid_polygons(crusoe, cell_diameter = 2 * buffer_radius, what = "polygons", clip = TRUE, square = FALSE)
gridc <- st_centroid(polygonal_grid)

polygons_plot_output_path <- glue::glue("data/plot_crusoe_2_{session}.png")
plot_camera_positions_in_polygons_grid(crusoe, polygonal_grid, camera_observations, polygons_plot_output_path)

propulation_prediction_per_grid <- get_population_estimate(camera_observations, gridc, polygonal_grid, crusoe_shp = crusoe, buffer_radius = buffer_radius, square_grid = polygonal_grid, habitats)

plot_output_path <- glue::glue("data/plot_pred_grid_2_{session}.png")
plot_population_prediction_per_grid(propulation_prediction_per_grid = propulation_prediction_per_grid, plot_output_path = plot_output_path)
