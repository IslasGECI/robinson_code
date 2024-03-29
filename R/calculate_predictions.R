#' @export
get_camera_observations <- function(camera_sightings, coordinates_path = "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv") {
  # remove camera coords with ID == NA
  camera_coordinates <- read_csv(coordinates_path, show_col_types = FALSE)
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

#' @export
get_camera_observations_multisession <- function(camera_sightings, coordinates_path = "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv") {
  # remove camera coords with ID == NA
  camera_coordinates <- get_camera_coordinates_from_path(coordinates_path)
  # check_grid_registered_camera_coordinate(camera_sightings, camera_coordinates)
  # process camera obs
  camera_sightings <- camera_sightings %>%
    filter(Grid %in% camera_coordinates$ID) %>%
    filter(Grid != 38)
  camera_detections <- camera_sightings %>% select(ID = Grid, session, starts_with("r"))
  camera_locations <- get_camera_locations_as_sf(camera_detections, camera_coordinates)
  camera_detections <- camera_detections %>% select(-ID)
  camera_effort <- camera_sightings %>% select(session, starts_with("e"))

  camera_detections[camera_effort == 0] <- NA
  camera_effort <- get_matrix_list_from_camera_effort(camera_effort)
  camera_observations <- list("detections" = camera_detections, "effort" = camera_effort, "locations" = camera_locations)
  return(camera_observations)
}

get_camera_coordinates_from_path <- function(coordinates_path) {
  camera_coordinates <- read_csv(coordinates_path, show_col_types = FALSE)
  camera_coordinates <- camera_coordinates %>%
    mutate(ID = `N Cuadricula`) %>%
    filter(!is.na(ID))
  return(camera_coordinates)
}
get_camera_locations_as_sf <- function(camera_detections, camera_coordinates) {
  camera_locations <- camera_coordinates %>%
    filter(ID %in% camera_detections$ID) %>%
    select(ID, X = Easting, Y = Norting)
  camera_locations <- sf::st_as_sf(camera_locations, coords = c("X", "Y"), crs = 32717)
  return(camera_locations)
}

get_matrix_list_from_camera_effort <- function(camera_effort) {
  camera_effort <- split(camera_effort, ~ factor(session))
  camera_effort <- lapply((camera_effort), function(x) {
    x %>%
      select(-session) %>%
      as.matrix()
  })
  return(camera_effort)
}
check_grid_registered_camera_coordinate <- function(camera_sightings, camera_coordinates) {
  if (!all(camera_sightings$Grid %in% camera_coordinates$ID)) {
    stop("Missing grid in camera coordinate")
  }
}

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
plot_population_prediction_per_grid <- function(propulation_prediction_per_grid, plot_output_path, crusoe_shp_path = "data/spatial/Robinson_Coati_Workzones_Simple.shp") {
  crusoe_shp <- sf::read_sf(crusoe_shp_path)
  max_N <- max(propulation_prediction_per_grid$N)
  propulation_prediction_per_grid %>% ggplot() +
    geom_sf(aes(fill = N)) +
    scale_fill_distiller(palette = "OrRd", direction = 1, limits = c(0, max_N)) +
    geom_sf(fill = NA, data = crusoe_shp)
  ggsave(plot_output_path)
}

#' @export
get_m <- function(habvals, camera_sightings) {
  y <- camera_sightings[["detections"]] %>% select(starts_with("r"))
  e <- camera_sightings[["effort"]] %>% select(starts_with("e"))

  y[e == 0] <- NA # e==0 implies no camera data available so set to NA

  # Fit model
  emf <- eradicate::eFrame(y = y, siteCovs = habvals, obsCovs = list(effort = e))
  # Fit the Nmixture model
  m <- eradicate::nmix(~habitat, ~effort, data = emf, K = 100) # set K large enough so estimates do not depend on it
  return(m)
}

#' @export
get_m_multisession <- function(habvals, camera_sightings) {
  # Fit model
  emf <- eradicate::eFrameS(y = camera_sightings[["detections"]], siteCovs = habvals, obsCovs = camera_sightings[["effort"]])
  # Fit the Nmixture model
  m <- eradicate::nmixS(~ habitat + .season, ~1, data = emf, K = 100) # set K large enough so estimates do not depend on it
  return(m)
}

#' @export
add_prediction_to_all_habitats <- function(m, all_habitats) {
  preds <- eradicate::calcN(m, newdata = all_habitats, off.set = all_habitats$rcell)
  print(preds$Nhat)
  all_habitats_with_N <- all_habitats %>% mutate(N = preds$cellpreds$N)
  return(all_habitats_with_N)
}

#' @export
get_habitat_values <- function(hab1, cobs_l_buff) {
  habvals <- terra::extract(hab1, terra::vect(cobs_l_buff), fun = calc_mode)
  habvals <- habvals %>%
    select(-ID, habitat = starts_with("Veg")) %>%
    mutate(habitat = factor(habitat))
  return(habvals)
}

#' @export
get_m_multisession_from_hab1_and_camera_sightings <- function(camera_sightings, hab1, buffer_radius) {
  cobs_l_buff <- sf::st_buffer(camera_sightings[["locations"]], dist = buffer_radius)
  habvals <- get_habitat_values(hab1, cobs_l_buff)
  m <- get_m_multisession(habvals, camera_sightings)
  return(m)
}
#' @export
get_m_from_hab1_and_camera_sightings <- function(camera_sightings, hab1, buffer_radius) {
  cobs_l_buff <- sf::st_buffer(camera_sightings[["locations"]], dist = buffer_radius)
  habvals <- get_habitat_values(hab1, cobs_l_buff)
  m <- get_m(habvals, camera_sightings)
  return(m)
}

#' @export
get_population_estimate_multisession <- function(camera_sightings, gridc, grid_clip, crusoe_shp, buffer_radius, square_grid, habitats) {
  m <- get_m_multisession_from_hab1_and_camera_sightings(camera_sightings, habitats, buffer_radius)
  summary(m)

  # To extrapolate across the island need to extract habitat values for each 1km grid cell
  # However, we need to account for partial grid cells

  vegetation_from_model <- get_habitat_id_from_model(m)

  all_habitats <- calculate_all_habitats(gridc, buffer_radius, habitats, square_grid, vegetation_from_model)
  N_coati_by_habitat <- add_prediction_to_all_habitats(m, all_habitats)

  propulation_prediction_per_grid <- inner_join(grid_clip, N_coati_by_habitat, by = c("Id" = "ID"))
  return(propulation_prediction_per_grid)
}

#' @export
get_habitat_id_from_model <- function(m) {
  return(as.numeric(as.vector(unique(m$data$siteCovs)[["habitat"]])))
}

#' @export
get_population_estimate <- function(camera_sightings, gridc, grid_clip, crusoe_shp, buffer_radius, square_grid, habitats) {
  m <- get_m_from_hab1_and_camera_sightings(camera_sightings, habitats, buffer_radius)
  summary(m)

  # To extrapolate across the island need to extract habitat values for each 1km grid cell
  # However, we need to account for partial grid cells

  vegetation_from_model <- get_habitat_id_from_model(m)

  all_habitats <- calculate_all_habitats(gridc, buffer_radius, habitats, square_grid, vegetation_from_model)
  N_coati_by_habitat <- add_prediction_to_all_habitats(m, all_habitats)

  propulation_prediction_per_grid <- inner_join(grid_clip, N_coati_by_habitat, by = c("Id" = "ID"))
  return(propulation_prediction_per_grid)
}

get_habitat_id_from_model <- function(m) {
  return(as.numeric(as.vector(unique(m$data$siteCovs)[["habitat"]])))
}

#' @export
calculate_all_habitats <- function(gridc, buffer_radius, hab1, square_grid, vegetation_from_model) {
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

  filtered_habitats <- all_habitats %>%
    filter(habitat %in% vegetation_from_model) %>%
    mutate(habitat = factor(habitat))
  return(filtered_habitats)
}

#' @export
make_grid_square <- function(crusoe_shp, square_grid) {
  g <- sf::st_intersection(square_grid, crusoe_shp)
  return(g)
}


#' @export
make_grid_polygons <- function(crusoe_shp, cell_diameter, what = c("centers", "polygons"), square = FALSE, clip = FALSE) {
  # generate array of polygon centers
  what <- match.arg(what, c("centers", "polygons"))
  g <- sf::st_make_grid(crusoe_shp, cellsize = cell_diameter, what = what, square = square)
  # clip to boundary of study area
  if (clip) {
    g <- sf::st_intersection(g, crusoe_shp)
  }
  g <- sf::st_sf(Id = 1:length(g), geometry = g)
  return(g)
}


Grid_Square <- R6::R6Class("Grid_Square",
  public = list(
    grid_cell = NULL,
    grid_clip = NULL,
    square_grid = NULL,
    initialize = function(grid_cell, grid_clip, square_grid) {
      self$grid_cell <- grid_cell
      self$grid_clip <- grid_clip
      self$square_grid <- square_grid
    }
  )
)
