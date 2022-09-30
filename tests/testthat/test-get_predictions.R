describe("Get camera traps positions", {
  camera_detections <- read_csv("../data/input_plot_camera_positions_square_detections.csv", show_col_types = FALSE)
  camera_effort <- read_csv("../data/input_plot_camera_positions_square_effort.csv", show_col_types = FALSE)
  camera_locations <- read_csv("../data/input_plot_camera_positions_square_locations.csv", show_col_types = FALSE)
  camera_sightings <- list("detections" = camera_detections, "effort" = camera_effort, "locations" = sf::st_as_sf(camera_locations, wkt = "geometry"))
  grid_cell_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp"
  square_grid_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp"
  vegetation_tiff_path <- "../data/VegetationCONAF2014_50mHabitat.tif"
  crusoe_shp_path <- "../data/Robinson_Coati_Workzones_Simple.shp"
  crusoe_shp <- sf::read_sf(crusoe_shp_path)
  buffer_radius <- 500
  it("Test get_population_estimates", {
    obtained_pred_grid <- get_population_estimate(camera_sightings = camera_sightings, vegetation_tiff_path = vegetation_tiff_path, grid_cell_path = grid_cell_path, crusoe_shp = crusoe_shp, buffer_radius = buffer_radius, square_grid_path = square_grid_path)
    expected_pred_grid <- read_csv("../data/output_get_population_estimate_pred_grid.csv", show_col_types = FALSE)
    expect_equal(obtained_pred_grid$N, expected_pred_grid$N)
  })
  it("Hash test for plot_crusoe", {
    plot_output_path <- "../data/plot_pred_grid.png"
    propulation_prediction_per_grid <- get_population_estimate(camera_sightings = camera_sightings, vegetation_tiff_path = vegetation_tiff_path, grid_cell_path = grid_cell_path, crusoe_shp = crusoe_shp, buffer_radius = buffer_radius, square_grid_path = square_grid_path)
    plot_population_prediction_in_square_grid(propulation_prediction_per_grid, crusoe_shp_path = crusoe_shp_path, plot_output_path = plot_output_path)
    obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
    expected_hash <- c("7c09f97b3cfb23a32345965f2e7a62e0")
    expect_equal(obtanied_hash, expected_hash)
  })
})
