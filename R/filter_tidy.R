#' @export
Filter_tidy <- R6::R6Class("Filter_tidy",
  public = list(
    tidy_table = NULL,
    aux = NULL,
    initialize = function(tidy_table) {
      self$tidy_table <- tidy_table %>% arrange(Ocassion)
      self$aux <- tidy_table %>% arrange(Ocassion)
    },
    select_session = function(month) {
      private$month <- month
      self$aux <- self$aux %>% filter(Session == private$month)
    },
    select_method = function(method) {
      self$aux <- self$aux %>% filter(Method == method)
    },
    spatial = function() {
      private$fix_missing_months()
      final_structure <- tidy_2_final(self$aux)
      final_structure <- final_structure %>%
        arrange(Grid) %>%
        filter(!is.na(Session))
      return(final_structure)
    }
  ),
  private = list(
    month = NULL,
    fix_missing_months = function() {
      self$aux <- self$aux %>%
        fill_missing_weeks_with_empty_rows(private$month) %>%
        arrange(Ocassion)
    }
  )
)
