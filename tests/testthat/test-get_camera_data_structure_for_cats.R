library(tidyverse)

testthat::describe("We define the expected data structures for cats 🏅", {
  path_cameras <- "../data/raw_cameras_with_cats.csv"
  path_coordinates <- "../data/camera_traps_coordinates.csv"
  output_path <- "/workdir/tests/testthat/data"
  path_config <- list("cameras" = path_cameras, "coordinates" = path_coordinates, "output_path" = output_path)
  get_camera_traps_multisession_structures_for_cats(path_config = path_config)
  it("Test camera-traps multisession structure", {
    expected_camera_traps_multisession <- read_csv("../data/output_get_multisession_structure_camera_traps_for_cats.csv", show_col_types = FALSE)
    obtained_camera_traps_multisession <- read_csv(paste0(output_path, "/Camera-Traps-Cats.csv"), show_col_types = FALSE)
    expect_equal(obtained_camera_traps_multisession, expected_camera_traps_multisession)
  })
})
