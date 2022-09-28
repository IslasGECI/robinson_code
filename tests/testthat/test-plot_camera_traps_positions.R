describe("Get camera traps positions", {
  it("Hash test for plot_crusoe", {
    crusoe_shp_path <- "../data/Robinson_Coati_Workzones_Simple.shp" 
    square_grid_path <- "../data/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp"
    camera_sightings_path <- "../data/april_camera_traps_2022.csv"
    coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
    plot_output_path <- "../data/plot_crusoe.png"
    plot_camera_positons_in_square_grid(coordinates_path = coordinates_path, camera_sightings_path = camera_sightings_path, crusoe_shp_path = crusoe_shp_path, square_grid_path = square_grid_path, plot_output_path = plot_output_path)
    obtanied_hash <- as.vector(tools::md5sum(plot_output_path))
    expected_hash <- c("042316766181beb35f055208ce4b5f1f")
    expect_equal(obtanied_hash, expected_hash)
  })
})
