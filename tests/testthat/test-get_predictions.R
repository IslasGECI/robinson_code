testthat::describe("Get camera traps positions", {
  camera_detections <- read_csv("../data/input_plot_camera_positions_square_detections.csv", show_col_types = FALSE)
  camera_effort <- read_csv("../data/input_plot_camera_positions_square_effort.csv", show_col_types = FALSE)
  camera_locations <- read_csv("../data/input_plot_camera_positions_square_locations.csv", show_col_types = FALSE)
  camera_sightings <- list("detections" = camera_detections, "effort" = camera_effort, "locations" = sf::st_as_sf(camera_locations, wkt = "geometry"))
  grid_cell_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp"
  grid_cell <- sf::read_sf(grid_cell_path)
  square_grid_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp"
  square_grid <- sf::read_sf(square_grid_path)
  vegetation_tiff_path <- "../data/VegetationCONAF2014_50mHabitat.tif"
  habitats <- terra::rast(vegetation_tiff_path)
  crusoe_shp_path <- "../data/Robinson_Coati_Workzones_Simple.shp"
  crusoe_shp <- sf::read_sf(crusoe_shp_path)
  buffer_radius <- 500
  grid_clip <- make_grid_square(crusoe_shp, square_grid)
  obtained_pred_grid <- get_population_estimate(camera_sightings = camera_sightings, gridc = grid_cell, grid_clip, crusoe_shp = crusoe_shp, buffer_radius = buffer_radius, square_grid = square_grid, habitats)
  it("Test get_population_estimates", {
    expected_pred_grid <- read_csv("../data/output_get_population_estimate_pred_grid.csv", show_col_types = FALSE)
    expect_equal(obtained_pred_grid$N, expected_pred_grid$N)
  })
  it("Hash test for plot_crusoe", {
    plot_output_path <- "../data/plot_pred_grid.png"
    plot_population_prediction_per_grid(obtained_pred_grid, crusoe_shp_path = crusoe_shp_path, plot_output_path = plot_output_path)
    obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
    expected_hash <- c("01e789a0345bf323c338e020bb9a6665")
    expect_equal(obtanied_hash, expected_hash)
  })
  it("Hash test for plot_crusoe", {
    plot_output_path <- "data/plot_pred_grid_2022-4.png"
    session <- "2022-4"
    plot_population_prediction_per_grid_from_a_session(obtained_pred_grid, crusoe_shp_path = crusoe_shp_path, session = session)
    obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
    expected_hash <- c("01e789a0345bf323c338e020bb9a6665")
    expect_equal(obtanied_hash, expected_hash)
    testtools::delete_output_file(plot_output_path)
  })
})
