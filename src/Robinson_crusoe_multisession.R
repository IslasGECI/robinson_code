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

multisession <- Multisession$new(camera_sightings)
multisession_camera_sightings <- multisession$data_for_multisession %>% rename(session = Session)

camera_observations <- get_camera_observations_multisession(camera_sightings = multisession_camera_sightings)


# Quick plot of grid cells and camera locations
plot_output_path <- "data/plot_crusoe_multisession.png"
plot_camera_positions_in_square_grid(crusoe, square_grid, camera_observations, plot_output_path)
# Extract habitat information from raster using a buffer around the camera
# locations (size set below).  In this case habitat appears to be categorical
# so we extract the most common habitat type from the buffer area using the mode

# Plot cell predictions
buffer_radius <- 500 # m  This should depend on grid size, which should depend on HR size
grid_cell <- sf::read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp")
habitats <- terra::rast("data/spatial/VegetationCONAF2014_50mHabitat.tif")
grid_clip <- make_grid_square(crusoe, square_grid)

m <- get_m_multisession_from_hab1_and_camera_sightings(camera_observations, habitats, buffer_radius)
summary(m)

# To extrapolate across the island need to extract habitat values for each 1km grid cell
# However, we need to account for partial grid cells

vegetation_from_model <- get_habitat_id_from_model(m)

all_habitats <- calculate_all_habitats(grid_cell, buffer_radius, habitats, square_grid, vegetation_from_model)

all_habitats_filtered_by_id <- all_habitats %>% filter(ID %in% unique(camera_observations[["locations"]]$ID))

# all_habitats_rep <- rep(all_habitats_filtered_by_id, 5)

preds <- eradicate::calcN(m)
print(preds$Nhat)
all_habitats_with_N <- all_habitats_filtered_by_id %>% mutate(N = preds$cellpreds$N)

# N_coati_by_habitat <- add_prediction_to_all_habitats(m, all_habitats)

propulation_prediction_per_grid <- inner_join(grid_clip, all_habitats_with_N, by = c("Id" = "ID"))

# pred_grid <- get_population_estimate_multisession(camera_observations, grid_cell, grid_clip, crusoe_shp = crusoe, buffer_radius = buffer_radius, square_grid = square_grid, habitats)

plot_output_path <- "data/plot_pred_grid_multisession.png"
plot_population_prediction_per_grid(propulation_prediction_per_grid = pred_grid, plot_output_path = plot_output_path)
