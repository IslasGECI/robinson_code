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


crusoe_shp_path <- "data/spatial/Robinson_Coati_Workzones_Simple.shp"
crusoe <- read_sf(crusoe_shp_path)
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

plot_pred_grid_months(initial_date, final_date, camera_sightings, grid_cell, grid_clip, crusoe_shp_path, buffer_radius, square_grid, habitats)
