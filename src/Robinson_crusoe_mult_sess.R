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
library(robinson)
# install the latest version of the 'eradicate' package (only need to do this once)
if (isFALSE(require(eradicate))) remotes::install_github("eradicate-dev/eradicate", build_vignettes = FALSE)
library(eradicate)
library(optparse)


opciones <- cli_get_multisession_predictions()
species <- opciones[["species"]]

crusoe <- read_sf("data/spatial/Robinson_Coati.shp")
grid <- read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp")
gridc <- read_sf("data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp")
hab1 <- rast("data/spatial/VegetationCONAF2014_50mHabitat.tif")

cam_obs <- read_csv(input_multisession[[species]], show_col_types = FALSE)

cam_coords <- read_csv("data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv", show_col_types = FALSE)

# remove camera coords with ID == NA
cam_coords <- cam_coords %>%
  mutate(ID = `N Cuadricula`) %>%
  filter(!is.na(ID))

# process camera obs
cam_obs <- cam_obs %>% filter(Grid %in% cam_coords$ID)

cobs_n <- cam_obs %>% select(ID = Grid, session, starts_with("r"))
cobs_e <- cam_obs %>% select(ID = Grid, session, starts_with("e"))
cobs_l <- cam_coords %>%
  filter(ID %in% cobs_n$ID) %>%
  select(ID, X = Easting, Y = Norting)
cobs_l <- st_as_sf(cobs_l, coords = c("X", "Y"), crs = 32717)


# Extract habitat information from raster using a buffer around the camera
# locations (size set below).  In this case habitat appears to be categorical
# so we extract the most common habitat type from the buffer area using the mode

buffer_radius <- 500 # m  This should depend on grid size, which should depend on HR size

calc_mode <- function(v) {
  # find most common element in vector
  # excluding NA
  if (all(is.na(v))) {
    return(NA)
  }
  uniqv <- unique(v)
  uniqv <- na.omit(uniqv)
  tabs <- tabulate(match(v, uniqv))
  m <- uniqv[which.max(tabs)]
  m
}

cobs_l_buff <- st_buffer(cobs_l, dist = buffer_radius)
habvals <- terra::extract(hab1, vect(cobs_l_buff), fun = calc_mode)
habvals <- habvals %>%
  select(-ID, habitat = starts_with("Veg")) %>%
  mutate(habitat = factor(habitat))

y <- cobs_n %>% select(session, starts_with("r"))
e <- cobs_e %>% select(session, starts_with("e"))

y[e == 0] <- NA # e==0 implies no camera data available so set to NA

# need to drop 'session' column from e so that it can be used for obsCovs
e <- select(e, -session)
# prepare data
emf <- eFrameS(y = y, siteCovs = habvals, obsCovs = list(effort = e))
# Fit the Nmixture model
m <- nmixS(~ habitat + .season, ~effort, data = emf, K = 100) # set K large enough so estimates do not depend on it

summary(m)

# To extrapolate across the island need to extract habitat values for each 1km grid cell
# However, we need to account for partial grid cells
gridc_buff <- st_buffer(gridc, dist = buffer_radius)
allhab <- terra::extract(hab1, vect(gridc_buff), fun = calc_mode)
allhab <- allhab %>% select(-ID, habitat = starts_with("Veg"))

# need to account for grid cells with fractional coverage of the island
# first clip the grid to the island boundary
grid_clip <- st_intersection(grid, crusoe)


cell_size <- as.numeric(st_area(grid_clip)) / 1e6 # km2
rcell_size <- cell_size / max(cell_size) # relative cell size

print("Antes del rcell")
allhab <- allhab %>%
  mutate(ID = grid$Id, rcell = round(rcell_size, 3)) %>%
  relocate(ID, .before = habitat)
print("Despues del rcell")

# Need to drop level '10' as this was not included in the model so
# we can not get predictions for it.
# This means we only get predictions for 49 of the 50 grid cells

allhab <- allhab %>%
  filter(habitat != 10) %>%
  mutate(habitat = factor(habitat))

preds <- calcN(m, newdata = allhab, off.set = allhab$rcell)

# Total population size
preds$Nhat

write_csv(preds$Nhat, output_prediction[[species]][1])
# Plot cell predictions
pred_grid <- inner_join(grid_clip, allhab, by = c("Id" = "ID"))
T <- max(y$session)
M <- nrow(allhab)
pred_grid <- pred_grid[rep(1:M, T), ]

pred_grid <- pred_grid %>% mutate(N = preds$cellpreds$N, session = rep(1:T, each = M))


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



cobs_l_buff <- st_buffer(cobs_l, dist = buffer_radius)
habvals <- terra::extract(hab1, vect(cobs_l_buff), fun = calc_mode)
habvals <- habvals %>%
  select(-ID, habitat = starts_with("Veg")) %>%
  mutate(habitat = factor(habitat))

y <- cobs_n %>% select(session, starts_with("r"))
e <- cobs_e %>% select(session, starts_with("e"))

y[e == 0] <- NA # e==0 implies no camera data available so set to NA

# need to drop 'session' column from e so that it can be used for obsCovs
e <- select(e, -session)
# prepare data
emf <- eFrameS(y = y, siteCovs = habvals, obsCovs = list(effort = e))
# Fit the Nmixture model
m <- nmixS(~ habitat + .season, ~effort, data = emf, K = 100) # set K large enough so estimates do not depend on it

summary(m)

# To extrapolate across the island need to extract habitat values for every grid cell

gridc_buff <- st_buffer(gridc, dist = buffer_radius)
allhab <- terra::extract(hab1, vect(gridc_buff), fun = calc_mode)
allhab <- allhab %>% select(-ID, habitat = starts_with("Veg"))

grid_clip <- st_intersection(grid, crusoe)

# need to account for fractional cells
cell_size <- as.numeric(st_area(grid)) / 1e6 # km2
rcell_size <- cell_size / max(cell_size)

allhab <- allhab %>%
  mutate(ID = grid$ID, rcell = round(rcell_size, 3)) %>%
  relocate(ID, .before = habitat)

# drop levels not in data fitted to model
allhab <- allhab %>%
  filter(!(habitat %in% c(3, 7, 10))) %>%
  mutate(habitat = factor(habitat))

preds <- calcN(m, newdata = allhab, off.set = allhab$rcell)

# Total population size
preds$Nhat
write_csv(preds$Nhat, output_prediction[[species]][2])

# Plot cell predictions
pred_grid <- inner_join(grid_clip, allhab, by = c("ID" = "ID"))
T <- max(y$session)
M <- nrow(allhab)
pred_grid <- pred_grid[rep(1:M, T), ]
pred_grid <- pred_grid %>% mutate(N = preds$cellpreds$N, session = rep(1:T, each = M))
