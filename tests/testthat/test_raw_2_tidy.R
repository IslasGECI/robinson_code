library(tidyverse)

testthat::describe("Add empty photos", {
  it("Define function", {
    path <- "../data/raw_cameras_to_fill_dates.csv"
    raw_data <- read_csv(path, show_col_types = FALSE)
    original_number_rows <- nrow(raw_data)
    obtained_number_rows <- nrow(fill_dates(raw_data))
    expect_true(original_number_rows < obtained_number_rows)
  })
  it("Get interval days by camera_id", {
    path <- "../data/raw_cameras_to_fill_dates.csv"
    raw_data <- read_csv(path, show_col_types = FALSE)
    expected_max_day_camera <- c(3, 8, 0)
    obtained_max_day_camera <- get_initial_and_delta_day_by_camera(raw_data)$delta_day
    expect_equal(expected_max_day_camera, obtained_max_day_camera)
    expected_min_day_camera <- lubridate::ymd(c("2022-04-02", "2022-04-04", "2022-04-04"))
    obtained_min_day_camera <- get_initial_and_delta_day_by_camera(raw_data)$initial_day
    expect_equal(expected_min_day_camera, obtained_min_day_camera)
  })
})
testthat::describe("Get dataframe", {
  it("dates: coati example", {
    first_date_interval <- lubridate::ymd("2022-04-02") + lubridate::days(0:3)
    second_date_interval <- lubridate::ymd("2022-04-04") + lubridate::days(0:8)
    third_date_interval <- lubridate::ymd("2022-04-04") + lubridate::days(0:0)
    first_tibble <- tibble(RelativePath = "N Cámara 1", DateTime = first_date_interval, CoatiCount = 0)
    second_tibble <- tibble(RelativePath = "N Cámara 10", DateTime = second_date_interval, CoatiCount = 0)
    third_tibble <- tibble(RelativePath = "N Cámara 2", DateTime = third_date_interval, CoatiCount = 0)
    expected <- rbind(first_tibble, second_tibble, third_tibble)
    path <- "../data/raw_cameras_to_fill_dates.csv"
    raw_data <- read_csv(path, show_col_types = FALSE)
    max_day_camera <- get_initial_and_delta_day_by_camera(raw_data)
    obtained <- get_missing_rows_with_date_by_camera(max_day_camera)
    expect_equal(obtained, expected)
  })
  it("dates: cat example", {
    expected_cat_column <- c(FALSE, FALSE, FALSE, TRUE, FALSE, TRUE, NA, NA, NA)
    path <- "../data/raw_cameras.csv"
    raw_data <- read_csv(path, show_col_types = FALSE)
    obtained_cat_column <- fill_dates(raw_data)$Cat
    expect_equal(obtained_cat_column, expected_cat_column)
  })
})
testthat::describe("Define filtered data structure", {
  it("Expected filtered data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path, show_col_types = FALSE)
    expected_dates <- as.POSIXct(c(
      "2022-04-02 07:25:23",
      "2022-04-02 07:25:26",
      "2022-04-02 07:25:29",
      "2022-04-02 07:25:32",
      "2022-04-04 02:02:42",
      "2022-04-04 02:02:45"
    ), tz = "UTC")
    expected_ocassion <- c(rep(14, 4), 15, 15)
    expected_id <- c(1, 1, 1, 1, 22, 10)
    expected_coati_count <- c(0, 0, 0, 1, 0, 1)
    expected_structure <- tibble(
      date = c(expected_dates),
      Ocassion = c(expected_ocassion),
      camera_id = expected_id,
      coati_count = expected_coati_count
    )
    obtained_structure <- select_date_ocassion_camera_and_detection_columns(data)
    expect_equal(expected_structure, obtained_structure)
  })
})

testthat::describe("Group data by window", {
  it("Test count_detection_by_window_for_coatis", {
    filtered_structure <- read_csv("../data/output_filtered_structure.csv", show_col_types = FALSE)
    obtained_grouped_by_window <- count_detection_by_window_for_coatis(filtered_structure)
    expected_grouped <- read_csv("../data/output_data_grouped_by_window.csv", show_col_types = FALSE, col_types = "ciiii")
    expect_equal(obtained_grouped_by_window, expected_grouped)
  })
  it("Test count_detection_by_day", {
    path <- "../data/output_data_grouped_by_window.csv"
    data_grouped_by_window <- read_csv(path, show_col_types = FALSE)
    obtained_grouped <- count_detection_by_day(data_grouped_by_window)
    expected_grouped <- read_csv("../data/max_captures_grouped_by_day.csv", show_col_types = FALSE)
    expect_equal(obtained_grouped, expected_grouped)
  })
  it("Test count_detection_by_day", {
    path <- "../data/output_data_grouped_by_window.csv"
    data_grouped_by_window <- read_csv(path, show_col_types = FALSE)
    obtained_grouped <- count_detection_by_day_for_coatis(data_grouped_by_window)
    expected_grouped <- read_csv("../data/max_captures_grouped_by_day.csv", show_col_types = FALSE)
    expect_equal(obtained_grouped, expected_grouped)
  })
})

testthat::describe("Add column for the 10-minute window ID", {
  it("Select coati", {
    path <- "../data/output_select_date_ocassion_camera_and_detection_columns.csv"
    selected_columns <- read_csv(path, show_col_types = FALSE)
    obtained <- assign_window_number_to_detections_for_coatis(selected_columns)
    expect_join <- read_csv("../data/output_join_original_with_new_window.csv", show_col_types = FALSE)
    expect_equal(obtained, expect_join)
  })
  it("Returns seconds as double double-precision numbers", {
    path <- "../data/raw_cameras_effort.csv"
    data <- read_csv(path, show_col_types = FALSE)
    selected_columns <- select_date_ocassion_camera_and_detection_columns(data)
    obtained_seconds <- get_seconds(selected_columns)
    obtained_type <- typeof(obtained_seconds)
    expected_type <- "double"
    expect_equal(obtained_type, expected_type)
  })
})

testthat::describe("Group data by day", {
  it("Get id camera from relative path", {
    path <- "../data/raw_cameras_effort_dirty_relative_path.csv"
    data <- read_csv(path, show_col_types = FALSE)
    obtained_id <- get_id_camera_from_relative_path(data$RelativePath)
    expected_id <- c(1, 1, 1, 1, 2, 10, 10, 57, 32, 22, 59, 32, 64, 32)
    expect_equal(obtained_id, expected_id)
  })
})

testthat::describe("Calculate effort", {
  it("Compute effort from grouped data with different ocassion", {
    path <- "../data/capture_by_window_camera_1.csv"
    data <- read_csv(path, show_col_types = FALSE)
    obtained_tidy_camera_traps <- add_effort_and_detection_columns_by_ocassion(data)
    obtained_effort <- obtained_tidy_camera_traps$e
    expected_effort <- c(1, 6, 7, 6, 6)
    expect_equal(obtained_effort, expected_effort)
    obtained_captures <- add_effort_and_detection_columns_by_ocassion(data)$r
    expected_captures <- c(0, 0, 5, 0, 0)
    expect_equal(obtained_captures, expected_captures)
  })
})

testthat::describe("Get camera traps tidy table", {
  it("Get tidy from path", {
    tidy_path_camera_traps <- "../data/tidy_camera_traps.csv"
    expected_tidy_camera_traps <- read_csv(tidy_path_camera_traps, show_col_types = FALSE)
    path_cameras <- "../data/raw_cameras_with_detection.csv"
    sigthing_path <- "../data/observations_database_for_tests.csv"
    hunting_path <- "../data/hunting_database_for_tests.csv"
    trapping_path <- "../data/trapping_database_for_tests.csv"
    path_coordinates <- "../data/camera_traps_coordinates.csv"
    path_list <- list("hunting" = hunting_path, "trapping" = trapping_path, "sighting" = sigthing_path)
    path_config <- list("cameras" = path_cameras, "field" = path_list, "coordinates" = path_coordinates)
    obtained_tidy_camera_traps <- tidy_from_path_camera(path_config)
    expect_equal(obtained_tidy_camera_traps, expected_tidy_camera_traps)
  })
})
