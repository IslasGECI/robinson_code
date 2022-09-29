get_camera_observations <- function(camera_sightings_path = "data/Camera-Traps.csv", coordinates_path = "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv") {
  camera_sightings <- read_csv(camera_sightings_path, show_col_types = FALSE)
  # remove camera coords with ID == NA
  camera_coordinates <- read_csv(coordinates_path)
  camera_coordinates <- camera_coordinates %>%
    mutate(ID = `N Cuadricula`) %>%
    filter(!is.na(ID))

  # process camera obs
  camera_sightings <- camera_sightings %>% filter(Grid %in% camera_coordinates$ID)
  camera_detections <- camera_sightings %>% select(ID = Grid, Session, starts_with("r"))
  camera_effort <- camera_sightings %>% select(ID = Grid, Session, starts_with("e"))

  camera_locations <- camera_coordinates %>%
    filter(ID %in% camera_detections$ID) %>%
    select(ID, X = Easting, Y = Norting)
  camera_locations <- sf::st_as_sf(camera_locations, coords = c("X", "Y"), crs = 32717)
  camera_observations <- list("detections" = camera_detections, "effort" = camera_effort, "locations" = camera_locations)
  return(camera_observations)
}

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


get_predictions <- function(buffer_radius, camera_locations) {
  hab1 <- rast("data/spatial/VegetationCONAF2014_50mHabitat.tif")
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
  # Fit the Nmixture model
  m <- nmix(~habitat, ~effort, data = emf, K = 100) # set K large enough so estimates do not depend on it

  summary(m)

  # To extrapolate across the island need to extract habitat values for each 1km grid cell
  # However, we need to account for partial grid cells
  gridc_buff <- st_buffer(gridc, dist = buffer_radius)
  allhab <- terra::extract(hab1, vect(gridc_buff), fun = calc_mode)
  allhab <- allhab %>% select(-ID, habitat = starts_with("Veg"))

  # need to account for grid cells with fractional coverage of the island
  # first clip the grid to the island boundary
  grid_clip <- st_intersection(grid, crusoe)

  cell_size <- as.numeric(st_area(grid)) / 1e6 # km2
  rcell_size <- cell_size / max(cell_size)
  print("Estamos en la línea 87")
  allhab <- allhab %>%
    mutate(ID = grid$Id, rcell = round(rcell_size, 3)) %>%
    relocate(ID, .before = habitat)

  # Need to drop level '10' as this was not included in the model so
  # we can not get predictions for it.
  # This means we only get predictions for 49 of the 50 grid cells

  allhab <- allhab %>%
    filter(habitat != 10) %>%
    mutate(habitat = factor(habitat))

  preds <- calcN(m, newdata = allhab, off.set = allhab$rcell)

  # Total population size
  print(preds$Nhat)
  predictions <- array(list(), 2)

  predictions[[1]] <- list("buffer_radius" = buffer_radius, "prediction" = preds)

  # Plot cell predictions
  allhab <- allhab %>% mutate(N = preds$cellpreds$N)
  pred_grid <- inner_join(grid_clip, allhab, by = c("Id" = "ID"))

  pred_grid %>% ggplot() +
    geom_sf(aes(fill = N)) +
    scale_fill_distiller(palette = "OrRd", direction = 1, limits = c(0, 13)) +
    geom_sf(fill = NA, data = crusoe)
  ggsave("data/plot_pred_grid.png")
}