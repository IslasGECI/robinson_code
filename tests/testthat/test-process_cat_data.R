library(tidyverse)

testthat::describe("Tidy structure for cats", {
  raw_cameras_path <- "../data/raw_cameras.csv"
  it("first function: select_date_ocassion_camera_and_detection_columns_for_cat()", {
    data <- read_csv(raw_cameras_path, show_col_types = FALSE)
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
    expected_cat_count <- c(0, 0, 0, 1, 0, 1)
    expected_structure <- tibble(
      date = c(expected_dates),
      Ocassion = c(expected_ocassion),
      camera_id = expected_id,
      cat_count = expected_cat_count
    )
    obtained_structure <- select_date_ocassion_camera_and_detection_columns_for_cat(data)
    write_csv(obtained_structure, "../data/output_select_data_ocassion_camera_and_detection_for_cats.csv")
    expect_equal(expected_structure, obtained_structure)
  })
  it("second function: count_detection_by_window_for_cats()", {
    filtered_structure <- read_csv("../data/output_select_data_ocassion_camera_and_detection_for_cats.csv", show_col_types = FALSE)
    obtained_grouped_by_window <- count_detection_by_window_for_cats(filtered_structure)
    expected_grouped <- read_csv("../data/output_cat_data_grouped_by_window.csv", show_col_types = FALSE, col_types = "ciiii")
    expect_equal(obtained_grouped_by_window, expected_grouped)
  })
  it("third function: count_detection_by_day_for_cats()", {
    path <- "../data/output_cat_data_grouped_by_window.csv"
    data_grouped_by_window <- read_csv(path, show_col_types = FALSE)
    obtained_grouped <- count_detection_by_day_for_cats(data_grouped_by_window)
    expected_grouped <- read_csv("../data/max_captures_grouped_by_day_for_cats.csv", show_col_types = FALSE)
    expect_equal(obtained_grouped, expected_grouped)
  })
  it("Get tidy from path", {
    tidy_path_camera_traps <- "../data/tidy_camera_traps.csv"
    expected_tidy_camera_traps <- read_csv(tidy_path_camera_traps, show_col_types = FALSE)
    obtained_tidy_camera_traps <- tidy_from_path_camera_for_cats(raw_cameras_path)
    expect_equal(obtained_tidy_camera_traps, expected_tidy_camera_traps)
  })
})
