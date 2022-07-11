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
    expected_ocassion <- tibble(
      date = c(expected_dates),
      ocassion = c(),
      camera_ID = c(),
      coati_count = c()
    )
    obtained_ocassion <- raw_2_ocassion(data)
    expect_equal(expected_ocassion, obtained_ocassion)
  })
})
