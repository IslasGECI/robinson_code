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
})
