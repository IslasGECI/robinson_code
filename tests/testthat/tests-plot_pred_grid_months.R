testthat::describe("get_months_between", {
  initial_date <- "2022-1"
  final_date <- "2022-4"
  obtained_months <- get_months_between(initial_date, final_date)
  expected_months <- c("2022-1", "2022-2", "2022-3", "2022-4")
  expect_equal(obtained_months, expected_months)
})

testthat::describe("Plot predictions for all months", {
  camera_detections <- read_csv("../data/input_plot_camera_positions_square_detections_two_sessions.csv", show_col_types = FALSE)
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
  initial_date <- "2022-4"
  final_date <- "2022-5"
  directory_path <- "/workdir/tests/testthat/data"
  plot_pred_grid_months(initial_date, final_date, camera_detections, grid_cell, grid_clip, crusoe_shp, buffer_radius, square_grid, habitats, directory_path)
  testtools::exist_output_file(paste0(directory_path, "/plot_pred_grid_2022-4.png"))
  testtools::exist_output_file(paste0(directory_path, "/plot_pred_grid_2022-5.png"))
})
