describe("Get camera traps positions", {
  camera_locations <- read_csv("../data/input_plot_camera_positions_square_locations.csv", show_col_types = FALSE)
  camera_sightings <- list("locations" = sf::st_as_sf(camera_locations, wkt = "geometry"))
  crusoe_shp_path <- "../data/Robinson_Coati_Workzones_Simple.shp"
  crusoe_shp <- sf::read_sf(crusoe_shp_path)
  square_grid_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp"
  square_grid <- sf::read_sf(square_grid_path)
  it("Hash test for plot_crusoe", {
    camera_sightings_path <- "../data/april_camera_traps_2022.csv"
    coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
    plot_output_path <- "../data/plot_crusoe.png"
    plot_camera_positions_in_square_grid(crusoe_shp, square_grid, camera_sightings, plot_output_path)
    obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
    expected_hash <- c("042316766181beb35f055208ce4b5f1f")
    expect_equal(obtanied_hash, expected_hash)
  })
  it("Hash test for plot_crusoe_2", {
    buffer_radius <- 250
    grid <- make_grid_polygons(crusoe_shp, cell_diameter = 2 * buffer_radius, what = "polygons", clip = TRUE, square = FALSE)
    plot_output_path <- "../data/plot_crusoe_poligon.png"
    plot_camera_positions_in_polygons_grid(crusoe_shp, grid, camera_sightings, plot_output_path)
    obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
    expected_hash <- c("b0b2eb6e44642cc16f67939831913efa")
    expect_equal(obtanied_hash, expected_hash)
  })
})
