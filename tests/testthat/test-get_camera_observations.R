describe("Get camera traps observations", {
  camera_sightings_path <- "../data/april_camera_traps_2022.csv"
  coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
  camera_sightings <- read_csv(camera_sightings_path)
  obtained_camera_observations <- get_camera_observations(camera_sightings = camera_sightings, coordinates_path = coordinates_path)
  it("Test number of camera observations", {
    obtained_camera_observations <- obtained_camera_observations[["detections"]]
    obtained_camera_observations_columns <- names(obtained_camera_observations)
    expected_camera_observations_columns <- c("ID", "Session", "r_1", "r_2", "r_3", "r_4", "r_5", "r_6")
    expect_equal(obtained_camera_observations_columns, expected_camera_observations_columns)
    obtained_detection <- obtained_camera_observations$r_2[[12]]
    expected_detection <- 13
    expect_equal(obtained_detection, expected_detection)
  })
  it("Test number of camera effort", {
    obtained_camera_effort <- obtained_camera_observations[["effort"]]
    obtained_camera_effort_columns <- names(obtained_camera_effort)
    expected_camera_effort_columns <- c("ID", "Session", "e_1", "e_2", "e_3", "e_4", "e_5", "e_6")
    expect_equal(obtained_camera_effort_columns, expected_camera_effort_columns)
    obtained_effort <- obtained_camera_effort$e_5[[3]]
    expected_effort <- 5
    expect_equal(obtained_effort, expected_effort)
  })
  it("Test for locations of cameras", {
    obtained_camera_locations <- obtained_camera_observations[["locations"]]
    obtained_camera_locations_columns <- names(obtained_camera_locations)
    expected_camera_locations_columns <- c("ID", "geometry")
    expect_equal(obtained_camera_locations_columns, expected_camera_locations_columns)
    obtained_geometry_X <- obtained_camera_locations$geometry[[5]][1]
    expected_geometry_X <- 695745
    expect_equal(obtained_geometry_X, expected_geometry_X)
    obtained_geometry_Y <- obtained_camera_locations$geometry[[5]][2]
    expected_geometry_Y <- 6274062
    expect_equal(obtained_geometry_Y, expected_geometry_Y)
  })
})
