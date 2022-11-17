testthat::describe("Filter cameras by month", {
  coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
  it("Test number of camera observations with the new object", {
    all_camera_sightings_path <- "../data/all_camera_traps_2022.csv"
    all_camera_sightings <- read_csv(all_camera_sightings_path)
    Filter_Data_Structure <- Filter_Data_Structure$new(all_camera_sightings)
    camera_sightings <- Filter_Data_Structure$get_data_by_month(month = "2022-4")
    obtained_camera_observations <- get_camera_observations(camera_sightings = camera_sightings, coordinates_path = coordinates_path)
    obtained_camera_observations <- obtained_camera_observations[["detections"]]
    obtained_camera_observations_columns <- names(obtained_camera_observations)
    expected_camera_observations_columns <- c("ID", "Session", "r_1", "r_2", "r_3", "r_4", "r_5", "r_6")
    expect_equal(obtained_camera_observations_columns, expected_camera_observations_columns)
    obtained_detection <- obtained_camera_observations$r_2[[12]]
    expected_detection <- 13
    expect_equal(obtained_detection, expected_detection)
    camera_sightings <- Filter_Data_Structure$get_data_by_month(month = "2022-5")
    obtained_camera_observations <- get_camera_observations(camera_sightings = camera_sightings, coordinates_path = coordinates_path)
    obtained_camera_observations <- obtained_camera_observations[["detections"]]
    obtained_detection <- obtained_camera_observations$r_2[[12]]
    expected_detection <- 0
    expect_equal(obtained_detection, expected_detection)
  })
  it("Define filter_data_for_multisession method 💫", {
    all_camera_sightings_path <- "../data/input_ramsey_format.csv"
    all_camera_sightings <- read_csv(all_camera_sightings_path)
    Filter_Data_Structure <- Filter_Data_Structure$new(all_camera_sightings)

    obtained <- Filter_Data_Structure$filter_data_for_multisession()
    obtained_number_of_sessions <- nrow(obtained)
    expected_number_of_sessions <- 107
    expect_equal(obtained_number_of_sessions, expected_number_of_sessions)
  })
})
