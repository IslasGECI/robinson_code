library(tidyverse)

testthat::describe("Tidy structure for cats", {
  it("first function: select_date_ocassion_camera_and_detection_columns_for_cat()", {
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
    expected_cat_count <- c(0, 0, 1, 0, 1, 1)
    expected_structure <- tibble(
      date = c(expected_dates),
      Ocassion = c(expected_ocassion),
      camera_id = expected_id,
      cat_count = expected_cat_count
    )
    obtained_structure <- select_date_ocassion_camera_and_detection_columns_for_cat(data)
    expect_equal(expected_structure, obtained_structure)
  })
  it("second function: count_detection_by_window()", {
  })
  it("third function: count_detection_by_day()", {
  })
})
