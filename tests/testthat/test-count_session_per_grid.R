testthat::describe("How many sessions per grid?", {
  tidy_path_camera_traps <- "../data/tidy_for_questions.csv"
  tidy_camera_traps <- read_csv(tidy_path_camera_traps, show_col_types = FALSE)
  it("How many cameras?", {
    obtained <- count_session_per_grid(tidy_camera_traps)
    obtained_rows <- nrow(obtained)
    expected_rows <- 6
    expect_equal(obtained_rows, expected_rows)
    obtained_colums <- colnames(obtained)
    expected_columns <- c("Grid", "number_session")
    expect_equal(obtained_colums, expected_columns)
    obtained_count <- obtained[[4, 2]]
    expected_count <- 2
    expect_equal(obtained_count, expected_count)
  })
  it("Write csv with sessions per grid", {
    path_cameras <- "../data/raw_cameras_with_detection.csv"
    path_coordinates <- "../data/camera_traps_coordinates.csv"
    path_config <- list("cameras" = path_cameras, "coordinates" = path_coordinates)
    output_path <- "count_of_sessions_per_grid.csv"
    write_session_per_grid(path_config, output_path)
    expect_true(testtools::exist_output_file(output_path))

    obtained_csv <- read_csv(output_path, show_col_types = FALSE)
    obtained_rows <- nrow(obtained_csv)
    expected_rows <- 1
    expect_equal(obtained_rows, expected_rows)
    obtained_count <- obtained_csv$number_session
    expected_count <- 1
    expect_equal(obtained_count, expected_count)
    testtools::delete_output_file(output_path)
  })
})