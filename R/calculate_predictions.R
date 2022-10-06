
#' @export
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

#' @export
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
  return(m)
}


#' @export
plot_population_prediction_in_square_grid <- function(propulation_prediction_per_grid, plot_output_path, crusoe_shp_path = "data/spatial/Robinson_Coati_Workzones_Simple.shp") {
  crusoe_shp <- sf::read_sf(crusoe_shp_path)

  propulation_prediction_per_grid %>% ggplot() +
    geom_sf(aes(fill = N)) +
    scale_fill_distiller(palette = "OrRd", direction = 1, limits = c(0, 13)) +
    geom_sf(fill = NA, data = crusoe_shp)
  ggsave(plot_output_path)
}

#' @export
get_population_estimate <- function(camera_sightings, vegetation_tiff_path = "data/spatial/VegetationCONAF2014_50mHabitat.tif", grid_cell_path, crusoe_shp, buffer_radius, square_grid_path = "data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp") {
  hab1 <- terra::rast(vegetation_tiff_path)
  square_grid <- sf::read_sf(square_grid_path)
  cobs_l_buff <- sf::st_buffer(camera_sightings[["locations"]], dist = buffer_radius)
  habvals <- terra::extract(hab1, terra::vect(cobs_l_buff), fun = calc_mode)
  habvals <- habvals %>%
    select(-ID, habitat = starts_with("Veg")) %>%
    mutate(habitat = factor(habitat))

  y <- camera_sightings[["detections"]] %>% select(starts_with("r"))
  e <- camera_sightings[["effort"]] %>% select(starts_with("e"))

  y[e == 0] <- NA # e==0 implies no camera data available so set to NA

  # Fit model
  emf <- eradicate::eFrame(y = y, siteCovs = habvals, obsCovs = list(effort = e))
  # Fit the Nmixture model
  m <- eradicate::nmix(~habitat, ~effort, data = emf, K = 100) # set K large enough so estimates do not depend on it

  summary(m)

  # To extrapolate across the island need to extract habitat values for each 1km grid cell
  # However, we need to account for partial grid cells

  gridc <- sf::read_sf(grid_cell_path)
  gridc_buff <- sf::st_buffer(gridc, dist = buffer_radius)
  all_habitats <- terra::extract(hab1, terra::vect(gridc_buff), fun = calc_mode)
  all_habitats <- all_habitats %>% select(-ID, habitat = starts_with("Veg"))


  cell_size <- as.numeric(sf::st_area(square_grid)) / 1e6 # km2
  rcell_size <- cell_size / max(cell_size)
  all_habitats <- all_habitats %>%
    mutate(ID = square_grid$Id, rcell = round(rcell_size, 3)) %>%
    relocate(ID, .before = habitat)

  # Need to drop level '10' as this was not included in the model so
  # we can not get predictions for it.
  # This means we only get predictions for 49 of the 50 grid cells

  all_habitats <- all_habitats %>%
    filter(habitat != 10) %>%
    mutate(habitat = factor(habitat))

  preds <- eradicate::calcN(m, newdata = all_habitats, off.set = all_habitats$rcell)

  all_habitats <- all_habitats %>% mutate(N = preds$cellpreds$N)


  grid_clip <- sf::st_intersection(square_grid, crusoe_shp)
  propulation_prediction_per_grid <- inner_join(grid_clip, all_habitats, by = c("Id" = "ID"))
  return(propulation_prediction_per_grid)
}
