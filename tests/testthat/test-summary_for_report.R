predictions_df <- read_csv("../data/prediction_with_count_cells_coatis.csv", show_col_types = FALSE)
testthat::describe("Obtain relevant numbers for json", {
  it("obtains data reception date", {
    obtained_date <- get_data_reception_date()
  })
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
})
testthat::describe("Fabric to configure by species", {
  specie <- "coati"
  obtained <- Configurator_summary_by_species$new(specie, workdir = "/workdir/tests/data")
  expect_true(checkmate::checkR6(obtained))
  expect_equal(obtained$predictions_df, predictions_df)
})

testthat::describe("Write json", {
  assert_value <- function(expected, variable_name) {
    obtained_summary_report <- concatenate_summary_for_report(predictions_df)
    obtained <- obtained_summary_report[[variable_name]]
    expect_equal(obtained, expected)
  }
  it("Get completed list", {
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

    expected_prediction_date <- "August 2022"
    assert_value(expected_prediction_date, "prediction_date")
    expected_prediction_date <- "July 2022"
    assert_value_with_ignoring_month(expected_prediction_date, "prediction_date")

    expected_prediction_date_es <- "julio de 2022"
    assert_value_with_ignoring_month(expected_prediction_date_es, "fecha_prediccion")
  })
  exist_output_file <- function(path) {
    file.exists(path)
  }
  delete_output_file <- function(path) {
    if (exist_output_file(path)) {
      file.remove(path)
    }
  }
  create_dir_data <- function() {
    if (!exist_output_file("/workdir/data")) {
      dir.create("/workdir/data", recursive = TRUE)
    }
  }
  it("Write complete Json file", {
    output_path <- "/workdir/tests/testthat/obtained_coati_results.json"
    delete_output_file(output_path)
    write_summary_for_report(predictions_df, output_path, "August 2022")
    expect_true(exist_output_file(output_path))
    obtained_summary <- rjson::fromJSON(file = output_path)
    expected_summary <- rjson::fromJSON(file = "/workdir/tests/data/coati_results.json")
    expect_equal(obtained_summary, expected_summary)
    delete_output_file(output_path)
  })
  it("Write complete Json file for coati report", {
    output_path <- "/workdir/data/coati_results.json"
    delete_output_file(output_path)
    create_dir_data()
    write_summary_for_coati_report(predictions_df, "August 2022")
    expect_true(exist_output_file(output_path))
    obtained_summary <- rjson::fromJSON(file = output_path)
    expected_summary <- rjson::fromJSON(file = "/workdir/tests/data/coati_results.json")
    expect_equal(obtained_summary, expected_summary)
    delete_output_file(output_path)
  })
  it("Write complete Json file for cats report", {
    predictions_cats <- read_csv("../data/prediction_with_count_cells_cats.csv", show_col_types = FALSE)
    output_path <- "/workdir/data/cat_results.json"
    delete_output_file(output_path)
    create_dir_data()
    write_summary_for_cat_report(predictions_cats, "August 2022")
    expect_true(exist_output_file(output_path))
    obtained_summary <- rjson::fromJSON(file = output_path)
    expected_summary <- rjson::fromJSON(file = "/workdir/tests/data/results.json")
    expect_equal(obtained_summary, expected_summary)
    delete_output_file(output_path)
  })
})
