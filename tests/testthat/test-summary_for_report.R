testthat::describe("Obtain relevant numbers for json", {
  predictions_df <- read_csv("../data/prediction_with_count_cells_coatis.csv", show_col_types = FALSE)
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
  it("Obtain median", {
    obtained_median <- get_median(predictions_df)
    expect_true(is.numeric(obtained_median))
    expected_median <- 132
    expect_equal(obtained_median, expected_median)
    ignore_month <- "August 2022"
    obtained_median <- get_median(predictions_df, ignore_month)
    expected_median <- 111
    expect_equal(obtained_median, expected_median)
  })
  predictions_2022 <- predictions_df[4:(nrow(predictions_df) - 2), ]
  it("Get start date", {
    obtained_start_date <- get_start_date(predictions_df)
    expect_true(is.character(obtained_start_date))
    expected_start_date <- "October 2021"
    expect_equal(obtained_start_date, expected_start_date)
    obtained_start_date <- get_start_date(predictions_2022)
    expected_start_date <- "January 2022"
    expect_equal(obtained_start_date, expected_start_date)
  })
  it("Get end date", {
    obtained_end_date <- get_end_date(predictions_df)
    expect_true(is.character(obtained_end_date))
    expected_end_date <- "June 2022"
    obtained_end_date <- get_end_date(predictions_2022)
    expect_equal(obtained_end_date, expected_end_date)
  })
  it("Get spanish dates", {
    obtained_start_date <- get_start_date_es(predictions_df)
    expect_true(is.character(obtained_start_date))
    expected_start_date <- "octubre de 2021"
    expect_equal(obtained_start_date, expected_start_date)
  })
})
