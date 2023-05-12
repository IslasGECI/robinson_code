testthat::describe("How many sessions per grid?", {
  tidy_path_camera_traps <- "../data/tidy_for_questions.csv"
  tidy_camera_traps <- read_csv(tidy_path_camera_traps, show_col_types = FALSE)
  it("How many cameras?", {
    obtained <- count_session_per_grid(tidy_camera_traps)
    obtained_rows <- nrow(obtained)
    expected_rows <- 5
    expect_equal(obtained_rows, expected_rows)
    obtained_colums <- colnames(obtained)
    expected_columns <- c("Grid", "number_session")
    expect_equal(obtained_colums, expected_columns)
    obtained_count <- filter(obtained, Grid == 31)$number_session
    expected_count <- 2
    expect_equal(obtained_count, expected_count)
  })

  it("Fill missing grid with 0", {
    input_path <- "../data/count_of_sessions_per_grid_incomplete.csv"
    df_with_missing_grids <- read_csv(input_path)
    obtained <- fill_missing_grids(df_with_missing_grids)
    obtained_nrows <- nrow(obtained)
    expected_nrows <- 50
    expect_equal(obtained_nrows, expected_nrows)
    obtained_count <- filter(obtained, Grid == 6)$number_session
    expected_count <- 0
    expect_equal(obtained_count, expected_count)
    expected_grid <- 49
    obtained_grid <- obtained$Grid[expected_grid]
    expect_equal(obtained_grid, expected_grid)
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
    expected_rows <- 50
    expect_equal(obtained_rows, expected_rows)
    grid <- 38
    obtained_count <- obtained_csv$number_session[[grid]]
    expected_count <- 1
    expect_equal(obtained_count, expected_count)
    testtools::delete_output_file(output_path)
  })
})
