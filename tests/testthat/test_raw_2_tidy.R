library(tidyverse)

describe("Add empty photos", {
  it("Define function", {
    path <- "../data/raw_cameras_to_fill_dates.csv"
    raw_data <- read_csv(path)
    original_number_rows <- nrow(raw_data)
    obtained_number_rows <- nrow(fill_dates(raw_data))
    expect_true(original_number_rows < obtained_number_rows)
  })
  it("Get interval days by camera_id", {
    path <- "../data/raw_cameras_to_fill_dates.csv"
    raw_data <- read_csv(path)
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
    raw_data <- read_csv(path)
    max_day_camera <- get_initial_and_delta_day_by_camera(raw_data)
    obtained <- get_missing_rows_with_date_by_camera(max_day_camera)
    expect_equal(obtained, expected)
  })
})
describe("Define filtered data structure", {
  it("Expected filtered data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
    expected_dates <- c(
      "2022-04-02 07:25:23",
      "2022-04-02 07:25:26",
      "2022-04-02 07:25:29",
      "2022-04-02 07:25:32",
      "2022-04-04 02:02:42",
      "2022-04-04 02:02:45"
    )
    expected_ocassion <- c(rep(13, 4), 14, 14)
    expected_id <- c(1, 1, 1, 1, 2, 10)
    expected_coati_count <- c(0, 0, 0, 1, 0, 1)
    expected_structure <- tibble(
      date = c(expected_dates),
      ocassion = c(expected_ocassion),
      camera_id = expected_id,
      coati_count = expected_coati_count
    )
    obtained_structure <- filter_raw_data(data)
    expect_equal(expected_structure, obtained_structure)
  })
})

describe("Group data by window", {
  it("Expected grouped data structure", {
    path <- "../data/raw_camera_id_35_and_61.csv"
    data <- read_csv(path)
    filtered_structure <- filter_raw_data(data)
    data_grouped_by_window <- group_data_by_window(filtered_structure)
    obtained_grouped <- group_filtered_data(data_grouped_by_window)
    expected_grouped <- read_csv("../data/max_captures_grouped_by_window.csv")
    expect_equal(obtained_grouped, expected_grouped)
  })
})

describe("Group data by day", {
  it("Expected grouped data structure", {
    path <- "../data/raw_cameras_effort.csv"
    data <- read_csv(path)
    filtered_structure <- filter_raw_data(data)
    obtained_grouped <- group_filtered_data(filtered_structure)
    expected_id <- c(1, 2, 10, 10)
    expected_ocassion <- c(13, 14, 14, 14)
    expected_captures <- c(1, 0, 1, 0)
    expected_grouped <- tibble(
      camera_id = expected_id,
      ocassion = expected_ocassion,
      day = c(2, 4, 4, 5),
      session = rep(4, 4),
      r = expected_captures
    )
    expect_equal(obtained_grouped, expected_grouped)
  })
})

describe("Calculate effort", {
  it("Compute effort from grouped data with different ocassion", {
    path <- "../data/capture_by_window_camera_1.csv"
    data <- read_csv(path)
    obtained_tidy_camera_traps <- calculate_effort(data)
    obtained_effort <- obtained_tidy_camera_traps$e
    expected_effort <- c(1, 6, 7, 6, 6)
    expect_equal(obtained_effort, expected_effort)
    obtained_captures <- calculate_effort(data)$r
    expected_captures <- c(0, 0, 5, 0, 0)
    expect_equal(obtained_captures, expected_captures)
  })
})

describe("Get camera traps tidy table", {
  it("Get tidy from path", {
    tidy_path_camera_traps <- "../data/tidy_camera_traps.csv"
    expected_tidy_camera_traps <- read_csv(tidy_path_camera_traps)
    path <- "../data/raw_cameras_with_detection.csv"
    obtained_tidy_camera_traps <- tidy_from_path(path)
    expect_equal(obtained_tidy_camera_traps, expected_tidy_camera_traps)
  })
})
