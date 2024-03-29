#' @export
write_summary_for_coati_report <- function(ignore_month = NULL, workdir = "/workdir/") {
  configurator <- Configurator_summary_by_species$new("coati", workdir)
  configurator$write_summary_for_report("/workdir/data/coati_results.json", ignore_month)
}

#' @export
write_summary_for_cat_report <- function(ignore_month = NULL) {
  configurator <- Configurator_summary_by_species$new("cats", workdir = "/workdir/tests/data/")
  configurator$write_summary_for_report("/workdir/data/cat_results.json", ignore_month)
}

Configurator_summary_by_species <- R6::R6Class("Configurator summary by species",
  public = list(
    predictions_df = NULL,
    data_reception_date = NULL,
    data_reception_date_es = NULL,
    workdir = NULL,
    initialize = function(specie, workdir = "/workdir/") {
      self$workdir <- workdir
      file_name <- private$predictions_list[[specie]]
      predictions_path <- glue::glue("{self$workdir}{file_name}")
      self$predictions_df <- readr::read_csv(predictions_path, show_col_types = FALSE)
      self$data_reception_date <- private$get_reception_date(specie)
      self$data_reception_date_es <- private$get_reception_date_es(specie)
    },
    write_summary_for_report = function(output_path, ignore_month = NULL) {
      summary_for_report <- self$concatenate_summary_for_report(ignore_month)
      myfile <- rjson::toJSON(summary_for_report)
      write(myfile, output_path)
    },
    concatenate_summary_for_report = function(ignore_month = NULL) {
      prediction_date <- private$get_prediction_date(ignore_month)
      list(
        "prediction" = self$get_prediction(prediction_date),
        "max" = private$get_max(ignore_month),
        "min" = private$get_min(ignore_month),
        "median" = private$get_median(ignore_month),
        "start_date" = self$get_start_date(),
        "end_date" = private$get_end_date(),
        "fecha_inicio" = private$get_start_date_es(),
        "fecha_fin" = private$get_end_date_es(),
        "prediction_date" = prediction_date,
        "fecha_prediccion" = private$translate_date(prediction_date),
        "fecha_recepcion_datos" = self$data_reception_date_es,
        "data_reception_date" = self$data_reception_date
      )
    },
    get_prediction = function(month) {
      selected_data <- self$predictions_df |> filter(months == month)
      return(selected_data$ucl)
    },
    get_start_date = function() {
      return(dplyr::first(self$predictions_df$months))
    }
  ),
  private = list(
    predictions_list = list(
      "coati" = "prediction_with_count_cells_coatis.csv",
      "cats" = "prediction_with_count_cells_cats.csv"
    ),
    metadata_resources = list(
      "coati" = 2,
      "cats" = 1
    ),
    get_reception_date = function(specie) {
      json_content <- private$read_analyses()
      json_content[[private$metadata_resources[[specie]]]]$metadata$data_reception_date
    },
    get_reception_date_es = function(specie) {
      json_content <- private$read_analyses()
      json_content[[private$metadata_resources[[specie]]]]$metadata$fecha_recepcion_datos
    },
    read_analyses = function() {
      json_path <- glue::glue("{self$workdir}analyses.json")
      json_content <- rjson::fromJSON(file = json_path)
    },
    get_prediction_date = function(ignore_month = NULL) {
      last_month <- private$ignoring_months(ignore_month) %>%
        .$months %>%
        last()
      return(last_month)
    },
    get_max = function(ignore_month = NULL) {
      private$get_statistic(self$predictions_df, ignore_month, `ucl`, max)
    },
    get_min = function(ignore_month = NULL) {
      private$get_statistic(self$predictions_df, ignore_month, `lcl`, min)
    },
    get_median = function(ignore_month = NULL) {
      ceiling(private$get_statistic(self$predictions_df, ignore_month, `N`, median))
    },
    get_statistic = function(data, ignore_month, column, statistic) {
      selected_data <- private$ignoring_months(ignore_month) |>
        dplyr::summarize(computed_statistics = statistic({{ column }}))
      return(selected_data$computed_statistics)
    },
    get_end_date = function() {
      return(dplyr::last(self$predictions_df$months))
    },
    get_start_date_es = function() {
      private$get_date_limits(self$get_start_date)
    },
    get_end_date_es = function() {
      private$get_date_limits(private$get_end_date)
    },
    get_date_limits = function(limit) {
      date <- limit()
      private$translate_date(date)
    },
    translate_date = function(date) {
      date <- lubridate::my(date)
      month_number <- lubridate::month(date)
      month_in_spanish <- replace_number_with_spanish_name(month_number)
      year <- lubridate::year(date)
      add_month_in_spanish_and_year(month_in_spanish, year)
    },
    ignoring_months = function(ignore_month) {
      self$predictions_df |> filter(!(months %in% ignore_month))
    }
  )
)
