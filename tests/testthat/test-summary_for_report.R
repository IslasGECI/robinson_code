predictions_df <- read_csv("../data/prediction_with_count_cells_coatis.csv", show_col_types = FALSE)
testthat::describe("Obtain relevant numbers for json", {
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
  it("Get prediction date", {
    obtained_prediction_date <- get_prediction_date(predictions_df)
    expect_true(is.character(obtained_prediction_date))
    ignore_month <- "August 2022"
    obtained_prediction_date <- get_prediction_date(predictions_df, ignore_month)
    expected_prediction_date <- "July 2022"
    expect_equal(obtained_prediction_date, expected_prediction_date)
  })
})
testthat::describe("Write json", {
  assert_value <- function(expected, variable_name) {
    obtained_summary_report <- concatenate_summary_for_report(predictions_df)
    obtained <- obtained_summary_report[[variable_name]]
    expect_equal(obtained, expected)
  }
  it("Get completed list", {
    obtained_summary_report <- concatenate_summary_for_report(predictions_df)
    obtained_names <- names(obtained_summary_report)
    expected_names <- c("prediction", "max", "min", "median", "start_date", "end_date", "fecha_inicio", "fecha_fin", "prediction_date")
    expect_equal(obtained_names, expected_names)

    expected_start_date <- "October 2021"
    assert_value(expected_start_date, "start_date")

    expected_start_date_es <- "octubre de 2021"
    assert_value(expected_start_date_es, "fecha_inicio")

    expected_end_date_es <- "agosto de 2022"
    assert_value(expected_end_date_es, "fecha_fin")
  })
  assert_value_with_ignoring_month <- function(expected, variable_name, ignore_month = "August 2022") {
    
    obtained_summary_report_ignoring_month <- concatenate_summary_for_report(predictions_df, ignore_month)
    obtained <- obtained_summary_report_ignoring_month[[variable_name]]
    expect_equal(obtained, expected)
  }
  it("Ignoring months", {
    expected_prediction <- 336
    assert_value(expected_prediction, "prediction")

    expected_prediction <- 194
    assert_value_with_ignoring_month(expected_prediction, "prediction")

    expected_min <- 19
    assert_value(expected_min, "min")
    expected_min <- 20
    assert_value_with_ignoring_month(expected_min, "min", "January 2022")

    expected_max <- 336
    assert_value(expected_max, "max")
    expected_max <- 231
    assert_value_with_ignoring_month(expected_max, "max")

    expected_median <- 132
    assert_value(expected_median, "median")
    expected_median <- 111
    assert_value_with_ignoring_month(expected_median, "median")

    expected_end_date <- "August 2022"
    assert_value_with_ignoring_month(expected_end_date, "end_date")

    expected_prediction_date <- "July 2022"
    assert_value_with_ignoring_month(expected_prediction_date, "prediction_date")
  })
})
