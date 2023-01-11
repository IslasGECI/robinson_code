testthat::describe("Obtain relevant numbers for json", {
  predictions_df <- read_csv("../data/prediction_with_count_cells_coatis.csv")
  it("Obtain prediction for July 2022", {
    month <- "July 2022"
    obtained_prediction <- get_prediction(predictions_df, month)
    expect_true(is.numeric(obtained_prediction))
    expected_prediction <- 194
    expect_equal(obtained_prediction, expected_prediction)
  })
  it("Obtain prediction for February 2022", {
    month <- "February 2022"
    obtained_prediction <- get_prediction(predictions_df, month)
    expected_prediction <- 73
    expect_equal(obtained_prediction, expected_prediction)
  })
  it("Obtain max", {
    obtained_max <- get_max(predictions_df)
    expect_true(is.numeric(obtained_max))
    expected_max <- 336
    expect_equal(obtained_max, expected_max)
    ignore_month <- "August 2022"
    obtained_max <- get_max(predictions_df, ignore_month)
    expected_max <- 231
    expect_equal(obtained_max, expected_max)
  })
  it("Obtain max ignoring two months", {
    ignore_month <- c("August 2022", "June 2022")
    obtained_max <- get_max(predictions_df, ignore_month)
    expected_max <- 227
    expect_equal(obtained_max, expected_max)
  })
  it("Obtain min", {
    obtained_min <- get_min(predictions_df)
    expect_true(is.numeric(obtained_min))
    expected_min <- 19
    expect_equal(obtained_min, expected_min)
    ignore_month <- "January 2022"
    obtained_min <- get_min(predictions_df, ignore_month)
    expected_min <- 20
    expect_equal(obtained_min, expected_min)
  })
})
