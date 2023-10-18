get_prediction <- function(predictions_df, month) {
  selected_data <- predictions_df |> filter(months == month)
  return(selected_data$ucl)
}
get_prediction_date <- function(predictions_df, ignore_month = NULL) {
  last_month <- predictions_df %>%
    ignoring_months(ignore_month) %>%
    .$months %>%
    last()
  return(last_month)
}
get_max <- function(predictions_df, ignore_month = NULL) {
  get_statistic(predictions_df, ignore_month, `ucl`, max)
}

get_min <- function(predictions_df, ignore_month = NULL) {
  get_statistic(predictions_df, ignore_month, `lcl`, min)
}

get_median <- function(predictions_df, ignore_month = NULL) {
  ceiling(get_statistic(predictions_df, ignore_month, `N`, median))
}

ignoring_months <- function(predictions_df, ignore_month) {
  predictions_df |> filter(!(months %in% ignore_month))
}

get_statistic <- function(data, ignore_month, column, statistic) {
  selected_data <- ignoring_months(data, ignore_month) |>
    dplyr::summarize(computed_statistics = statistic({{ column }}))
  return(selected_data$computed_statistics)
}
get_start_date <- function(predictions_df) {
  return(dplyr::first(predictions_df$months))
}
get_end_date <- function(predictions_df) {
  return(dplyr::last(predictions_df$months))
}

get_start_date_es <- function(predictions_df) {
  get_date_limits(predictions_df, get_start_date)
}
get_end_date_es <- function(predictions_df) {
  get_date_limits(predictions_df, get_end_date)
}
get_prediction_date_es <- function(predictions_df) {
  get_date_limits(predictions_df, get_prediction_date)
}
get_date_limits <- function(predictions_df, limit) {
  date <- limit(predictions_df)
  translate_date(date)
}

translate_date <- function(date) {
  date <- lubridate::my(date)
  month_number <- lubridate::month(date)
  month_in_spanish <- replace_number_with_spanish_name(month_number)
  year <- lubridate::year(date)
  add_month_in_spanish_and_year(month_in_spanish, year)
}

concatenate_summary_for_report <- function(predictions_df, ignore_month = NULL) {
  prediction_date <- get_prediction_date(predictions_df, ignore_month)
  list(
    "prediction" = get_prediction(predictions_df, prediction_date),
    "max" = get_max(predictions_df, ignore_month),
    "min" = get_min(predictions_df, ignore_month),
    "median" = get_median(predictions_df, ignore_month),
    "start_date" = get_start_date(predictions_df),
    "end_date" = get_end_date(predictions_df),
    "fecha_inicio" = get_start_date_es(predictions_df),
    "fecha_fin" = get_end_date_es(predictions_df),
    "prediction_date" = prediction_date,
    "fecha_prediccion" = translate_date(prediction_date),
    "fecha_recepcion_datos" = NA,
    "data_reception_date" = NA
  )
}

#' @export
write_summary_for_coati_report <- function(predictions_df, ignore_month = NULL) {
  write_summary_for_report(predictions_df, "/workdir/data/coati_results.json", ignore_month)
}

#' @export
write_summary_for_cat_report <- function(predictions_df, ignore_month = NULL) {
  write_summary_for_report(predictions_df, "/workdir/data/cat_results.json", ignore_month)
}

write_summary_for_report <- function(predictions_df, output_path, ignore_month = NULL) {
  summary_for_report <- concatenate_summary_for_report(predictions_df, ignore_month)
  myfile <- rjson::toJSON(summary_for_report)
  write(myfile, output_path)
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
    xxconcatenate_summary_for_report = function(ignore_month = NULL) {
      predictions_df <- self$predictions_df
      prediction_date <- private$xxget_prediction_date(ignore_month)
      list(
        "prediction" = self$xxget_prediction(prediction_date),
        "max" = private$xxget_max(ignore_month),
        "min" = get_min(predictions_df, ignore_month),
        "median" = get_median(predictions_df, ignore_month),
        "start_date" = get_start_date(predictions_df),
        "end_date" = get_end_date(predictions_df),
        "fecha_inicio" = get_start_date_es(predictions_df),
        "fecha_fin" = get_end_date_es(predictions_df),
        "prediction_date" = prediction_date,
        "fecha_prediccion" = translate_date(prediction_date),
        "fecha_recepcion_datos" = self$data_reception_date_es,
        "data_reception_date" = self$data_reception_date
      )
    },
    xxget_prediction = function(month) {
      selected_data <- self$predictions_df |> filter(months == month)
      return(selected_data$ucl)
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
    xxget_prediction_date = function(ignore_month = NULL) {
      last_month <- self$predictions_df %>%
        ignoring_months(ignore_month) %>%
        .$months %>%
        last()
      return(last_month)
    },
    xxget_max = function(ignore_month = NULL) {
      private$xxget_statistic(self$predictions_df, ignore_month, `ucl`, max)
    },
    xxget_statistic = function(data, ignore_month, column, statistic) {
      selected_data <- ignoring_months(data, ignore_month) |>
        dplyr::summarize(computed_statistics = statistic({{ column }}))
      return(selected_data$computed_statistics)
    }
  )
)
