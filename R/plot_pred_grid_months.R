get_months_between <- function(initial_date_character, final_date_character) {
  initial_date <- lubridate::ym(initial_date_character)
  final_date <- lubridate::ym(final_date_character)
  number_of_sessions <- lubridate::interval(initial_date, final_date) %/% months(1) + 1
  month_range <- get_month_range(number_of_sessions, initial_date_character)
  years <- lubridate::year(month_range)
  months <- lubridate::month(month_range)
  paste(years, months, sep = "-")
}

plot_pred_grid_months <- function(initial_date, final_date, camera_sightings,
                                  grid_cell, grid_clip, crusoe_shp, buffer_radius, square_grid,
                                  habitats, directory_path) {
  months <- get_months_between(initial_date, final_date)
  for (session in months) {
    Filter_Data_Structure <- Filter_Data_Structure$new(camera_sightings)
    camera_sightings_filtered <- Filter_Data_Structure$get_data_by_month(session)
    print(session)

    coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
    camera_observations <- get_camera_observations(camera_sightings = camera_sightings_filtered, coordinates_path)
    print(session)

    pred_grid <- get_population_estimate(camera_observations, grid_cell, grid_clip, crusoe_shp = crusoe, buffer_radius = buffer_radius, square_grid = square_grid, habitats)
    plot_output_path <- glue::glue("data/plot_pred_grid_{session}.png")
    plot_population_prediction_per_grid(propulation_prediction_per_grid = pred_grid, plot_output_path = plot_output_path)
  }
}

plot_population_prediction_per_grid_from_a_session <- function(propulation_prediction_per_grid, session, crusoe_shp_path = "data/spatial/Robinson_Coati_Workzones_Simple.shp") {
  plot_output_path <- glue::glue("/workdir/data/plot_pred_grid_{session}.png")
  plot_population_prediction_per_grid(propulation_prediction_per_grid, plot_output_path, crusoe_shp_path)
}
