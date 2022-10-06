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
grid <- read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp")
gridc <- read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp")
hab1 <- rast("data/spatial/VegetationCONAF2014_50mHabitat.tif")

cam_coords <- read_csv("data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv")

camera_sightings_path <- "data/Camera-Traps.csv"

camera_observations <- get_camera_observations(camera_sightings_path = camera_sightings_path)

camera_detections <- camera_observations[["detections"]]
camera_effort <- camera_observations[["effort"]]
camera_locations <- camera_observations[["locations"]]

# Quick plot of grid cells and camera locations
plot_output_path <- "data/plot_crusoe.png"
plot_camera_positions_in_square_grid(camera_sightings = camera_observations, plot_output_path = plot_output_path)
# Extract habitat information from raster using a buffer around the camera
# locations (size set below).  In this case habitat appears to be categorical
# so we extract the most common habitat type from the buffer area using the mode


buffer_radius <- 500 # m  This should depend on grid size, which should depend on HR size


# Plot cell predictions
pred_grid <- get_population_estimate(camera_observations, grid_cell_path = "data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp", crusoe_shp = crusoe, buffer_radius = buffer_radius)

plot_output_path <- "data/plot_pred_grid.png"
plot_population_prediction_in_square_grid(propulation_prediction_per_grid = pred_grid, plot_output_path = plot_output_path)

#-------------------------------------------------------
#  example using smaller grid of 500 m
#  Note that predictions are sensitive to grid cell size
#  so it needs to be set with some care
#-------------------------------------------------------

make_grid <- function(x, cell_diameter, what = c("centers", "polygons"), square = FALSE, clip = FALSE) {
  # generate array of polygon centers
  what <- match.arg(what, c("centers", "polygons"))
  g <- st_make_grid(x, cellsize = cell_diameter, what = what, square = square)
  # clip to boundary of study area
  if (clip) {
    g <- st_intersection(g, x)
  }
  g <- st_sf(ID = 1:length(g), geometry = g)
  return(g)
}


buffer_radius <- 250

grid <- make_grid(crusoe, cell_diameter = 2 * buffer_radius, what = "polygons", clip = TRUE, square = FALSE)
gridc <- st_centroid(grid)

polygons_plot_output_path <- "data/plot_crusoe_2.png"
plot_camera_positions_in_polygons_grid(camera_observations, grid, polygons_plot_output_path,crusoe_shp = crusoe)

cobs_l_buff <- st_buffer(camera_locations, dist = buffer_radius)
habvals <- terra::extract(hab1, vect(cobs_l_buff), fun = calc_mode)
habvals <- habvals %>%
  select(-ID, habitat = starts_with("Veg")) %>%
  mutate(habitat = factor(habitat))

y <- camera_detections %>% select(starts_with("r"))
e <- camera_effort %>% select(starts_with("e"))

y[e == 0] <- NA # e==0 implies no camera data available so set to NA

# Fit model
emf <- eFrame(y = y, siteCovs = habvals, obsCovs = list(effort = e))
m <- nmix(~habitat, ~effort, data = emf, K = 100) # set K large enough so estimates do no depend on it

summary(m)

# To extrapolate across the island need to extract habitat values for every grid cell

gridc_buff <- st_buffer(gridc, dist = buffer_radius)
allhab <- terra::extract(hab1, vect(gridc_buff), fun = calc_mode)
allhab <- allhab %>% select(-ID, habitat = starts_with("Veg"))

# need to account for fractional cells
cell_size <- as.numeric(st_area(grid)) / 1e6 # km2
rcell_size <- cell_size / max(cell_size)
print("Estamos en la línea 166")

allhab <- allhab %>%
  mutate(ID = grid$ID, rcell = round(rcell_size, 3)) %>%
  relocate(ID, .before = habitat)

# drop levels not in data fitted to model
allhab <- allhab %>%
  filter(!(habitat %in% c(3, 7, 10))) %>%
  mutate(habitat = factor(habitat))

preds <- calcN(m, newdata = allhab, off.set = allhab$rcell)

# Total population size
print(preds$Nhat)


# Plot cell predictions
allhab <- allhab %>% mutate(N = preds$cellpreds$N)
pred_grid <- inner_join(grid, allhab, by = c("ID" = "ID"))

plot_output_path <- "data/plot_pred_grid_2.png"
plot_population_prediction_in_square_grid(propulation_prediction_per_grid = pred_grid, plot_output_path = plot_output_path)
