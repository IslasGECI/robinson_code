testthat::describe("get_months_between", {
  initial_date <- "2022-1"
  final_date <- "2022-4"
  obtained_months <- get_months_between(initial_date, final_date)
  expected_months <- c("2022-1", "2022-2", "2022-3", "2022-4")
  expect_equal(obtained_months, expected_months)
})
testthat::describe("Plot predictions for all months", {
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
  coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"

  all_camera_sightings_path <- "../data/all_camera_traps_2022.csv"
  all_camera_sightings <- read_csv(all_camera_sightings_path, show_col_types = FALSE)
  session <- "2022-4"
  plot_pred_grid_session(session, all_camera_sightings, grid_cell, grid_clip, crusoe_shp_path, buffer_radius, square_grid, habitats, coordinates_path)

  plot_output_path <- "data/plot_pred_grid_2022-4.png"
  obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
  expected_hash <- c("01e789a0345bf323c338e020bb9a6665")
  expect_equal(obtanied_hash, expected_hash)
  testtools::delete_output_file(plot_output_path)

  session <- "2022-5"
  plot_pred_grid_session(session, all_camera_sightings, grid_cell, grid_clip, crusoe_shp_path, buffer_radius, square_grid, habitats, coordinates_path)
  plot_output_path <- "data/plot_pred_grid_2022-5.png"
  obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
  expected_hash <- c("26324d09f7c8672fadc5320a2f426617")
  expect_equal(obtanied_hash, expected_hash)
  testtools::delete_output_file(plot_output_path)
})

testthat::describe("Plot predictions for input_plot months", {
  camera_sightings <- read_csv("../data/all_camera_traps_2022.csv", show_col_types = FALSE)
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
  coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
  plot_pred_grid_months(initial_date, final_date, camera_sightings, grid_cell, grid_clip, crusoe_shp_path, buffer_radius, square_grid, habitats, coordinates_path)
  testtools::exist_output_file(paste0(directory_path, "/plot_pred_grid_2022-4.png"))
  testtools::exist_output_file(paste0(directory_path, "/plot_pred_grid_2022-5.png"))
})
