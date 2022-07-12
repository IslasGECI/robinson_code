library(tidyverse)

describe("Define ocassion data structure", {
  it("Expected ocassion data structure", {
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
      camera_ID = expected_id,
      coati_count = expected_coati_count
    )
    obtained_structure <- raw_2_ocassion(data)
    expect_equal(expected_structure, obtained_structure)
  })
})
describe("Define ocassion data structure", {
  it("Expected tidy data structure", {
    path <- "../data/raw_cameras.csv"
    data <- read_csv(path)
    ocassion_structure <- raw_2_ocassion(data)
    ocassion_2_tidy(ocassion_structure)
     
  })
})
