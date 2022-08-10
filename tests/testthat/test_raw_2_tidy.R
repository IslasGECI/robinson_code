library(tidyverse)

describe("Add empty photos", {
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
describe("Get dataframe", {
  it("dates", {
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
})
describe("Define filtered data structure", {
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
    ), tz="UTC")
    expected_ocassion <- c(rep(13, 4), 14, 14)
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

describe("Group data by window", {
  it("Expected grouped data structure", {
    path <- "../data/raw_camera_id_35_and_61.csv"
    data <- read_csv(path, show_col_types = FALSE)
    filtered_structure <- select_date_ocassion_camera_and_detection_columns(data)
    data_grouped_by_window <- count_detection_by_window(filtered_structure)
    obtained_grouped <- count_detection_by_day(data_grouped_by_window)
    expected_grouped <- read_csv("../data/max_captures_grouped_by_window.csv", show_col_types = FALSE)
    expect_equal(obtained_grouped, expected_grouped)
  })
})

describe("Add column for the 10-minute window ID", {
  it("Select coati", {
    path <- "../data/output_select_date_ocassion_camera_and_detection_columns.csv"
    selected_columns <- read_csv(path, show_col_types = FALSE)
    obtained <- assign_window_number_to_detections(selected_columns)
    expect_join <- read_csv("../data/output_join_original_with_new_window.csv", show_col_types = FALSE)
    expect_equal(obtained, expect_join)
  })
  it("Returns seconds in POSIXct", {
    path <- "../data/raw_cameras_effort.csv"
    data <- read_csv(path, show_col_types = FALSE)
    selected_columns <- select_date_ocassion_camera_and_detection_columns(data)
    obtained_seconds <- get_seconds(selected_columns)
    obtained_type <- typeof(obtained_seconds)
    expected_type <- "double"
    expect_equal(obtained_type, expected_type)
  })
})

describe("Group data by day", {
  it("Expected grouped data structure", {
    path <- "../data/raw_cameras_effort.csv"
    data <- read_csv(path, show_col_types = FALSE)
    filtered_structure <- select_date_ocassion_camera_and_detection_columns(data)
    obtained_grouped <- count_detection_by_day(filtered_structure)
    expected_id <- c(1, 2, 10, 10)
    expected_ocassion <- c(13, 14, 14, 14)
    expected_captures <- c(1, 0, 1, 0)
    expected_grouped <- tibble(
      camera_id = expected_id,
      Ocassion = expected_ocassion,
      day = c(2, 4, 4, 5),
      Session = rep(4, 4),
      r = expected_captures
    )
    expect_equal(obtained_grouped, expected_grouped)
  })
})

describe("Calculate effort", {
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

describe("Get camera traps tidy table", {
  it("Get tidy from path", {
    tidy_path_camera_traps <- "../data/tidy_camera_traps.csv"
    expected_tidy_camera_traps <- read_csv(tidy_path_camera_traps, show_col_types = FALSE)
    path_cameras <- "../data/raw_cameras_with_detection.csv"
    path_field <- "../data/input_trapping_hunting.csv"
    path_coordinates <- "../data/camera_traps_coordinates.csv"
    paths <- list("cameras" = path_cameras, "field" = path_field, "coordinates" = path_coordinates)
    obtained_tidy_camera_traps <- tidy_from_path_camera(paths)
    expect_equal(obtained_tidy_camera_traps, expected_tidy_camera_traps)
  })
})
