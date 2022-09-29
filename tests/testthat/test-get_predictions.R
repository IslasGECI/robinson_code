 describe("Get camera traps positions", {
  it("Hash test for plot_crusoe", {
    square_grid_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp"
    plot_output_path <- "../data/plot_pred_grid.png"
    grid_cell_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGridPointsNames.shp"
    vegetation_tiff_path <- "data/VegetationCONAF2014_50mHabitat.tif"
    camera_detections <- read_csv("../data/input_plot_camera_positions_square_detections.csv", show_col_types = FALSE)
    camera_effort <- read_csv("../data/input_plot_camera_positions_square_effort.csv", show_col_types = FALSE)
    camera_locations <- read_csv("../data/input_plot_camera_positions_square_locations.csv", show_col_types = FALSE)
    camera_sightings <- list("detections"= camera_detections, "effort" = camera_effort, "locations" = sf::st_as_sf(camera_locations, wkt = "geometry"))
    buffer_radius <- 500
    get_predictions(buffer_radius, camera_sightings, grid_cell_path = grid_cell_path, square_grid_path = square_grid_path, vegetation_tiff_path = vegetation_tiff_path, plot_output_path = plot_output_path)
    obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
    expected_hash <- c("21ab32e8a0111ae7e63225bd109880c6")
    expect_equal(obtanied_hash, expected_hash)
  })
 })
