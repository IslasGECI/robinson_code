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
    expected_ocassion <- rep(14,6)
    expected_structure <- tibble(
      date = c(expected_dates),
      ocassion = c(expected_ocassion),
      camera_ID = c(),
      coati_count = c()
    )
    obtained_structure <- raw_2_ocassion(data)
    expect_equal(expected_structure, obtained_structure)
  })
})
