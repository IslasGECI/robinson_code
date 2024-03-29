#' @export
plot_pred_grid_months <- function(initial_date, final_date, camera_sightings, grid_cell, grid_clip, crusoe_shp_path, buffer_radius, square_grid, habitats, coordinates_path = "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv") {
  months <- get_months_between(initial_date, final_date)
  for (session in months) {
    plot_pred_grid_session(session, camera_sightings, grid_cell, grid_clip, crusoe_shp_path, buffer_radius, square_grid, habitats, coordinates_path)
  }
}

get_months_between <- function(initial_date_character, final_date_character) {
  initial_date <- lubridate::ym(initial_date_character)
  final_date <- lubridate::ym(final_date_character)
  number_of_sessions <- lubridate::interval(initial_date, final_date) %/% months(1) + 1
  month_range <- get_month_range(number_of_sessions, initial_date_character)
  years <- lubridate::year(month_range)
  months <- lubridate::month(month_range)
  paste(years, months, sep = "-")
}

plot_population_prediction_per_grid_from_a_session <- function(propulation_prediction_per_grid, session, crusoe_shp_path = "data/spatial/Robinson_Coati_Workzones_Simple.shp") {
  plot_output_path <- glue::glue("data/plot_pred_grid_{session}.png")
  plot_population_prediction_per_grid(propulation_prediction_per_grid, plot_output_path, crusoe_shp_path)
}

get_camera_observations_from_a_session <- function(camera_sightings = camera_sightings_filtered, session, coordinates_path) {
  Filter_Data_Structure <- Filter_Data_Structure$new(camera_sightings)
  camera_sightings_filtered <- Filter_Data_Structure$get_data_by_month(session)
  return(get_camera_observations(camera_sightings = camera_sightings_filtered, coordinates_path))
}

plot_pred_grid_session <- function(session, camera_sightings, grid_cell, grid_clip, crusoe_shp_path, buffer_radius, square_grid, habitats, coordinates_path) {
  camera_observations <- get_camera_observations_from_a_session(camera_sightings, session, coordinates_path)
  pred_grid <- get_population_estimate(camera_observations, grid_cell, grid_clip, crusoe_shp = crusoe, buffer_radius = buffer_radius, square_grid = square_grid, habitats)
  plot_population_prediction_per_grid_from_a_session(pred_grid, session, crusoe_shp_path)
}
