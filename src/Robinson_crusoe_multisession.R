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

cobs_l_buff <- sf::st_buffer(camera_observations[["locations"]], dist = buffer_radius)
habvals <- get_habitat_values(habitats, cobs_l_buff)

y <- camera_observations[["detections"]] %>% select(session, starts_with("r"))
e <- camera_observations[["effort"]] %>% select(session, starts_with("e"))
y[e == 0] <- NA # e==0 implies no camera data available so set to NA

tmplist<- split(e, ~factor(session))
e_sin_sesion <- lapply((tmplist), function(x) x %>% select(-session)%>% as.matrix())

# Fit model
emf <- eradicate::eFrameS(y = y, siteCovs = habvals, obsCovs =  e_sin_sesion)
# Fit the Nmixture model
m <- eradicate::nmixS(~ habitat + .season, ~1, data = emf, K = 100) # set K large enough so estimates do not depend on it

m <- get_m_multisession(habvals, camera_observations)

pred_grid <- get_population_estimate_multisession(camera_observations, grid_cell, grid_clip, crusoe_shp = crusoe, buffer_radius = buffer_radius, square_grid = square_grid, habitats)

plot_output_path <- "data/plot_pred_grid_multisession.png"
plot_population_prediction_per_grid(propulation_prediction_per_grid = pred_grid, plot_output_path = plot_output_path)
