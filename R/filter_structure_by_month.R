#' @export
Filter_Camera_by_Month <- R6::R6Class("Filter_Camera_by_Month",
  public = list(
    all_months = NULL,
    initialize = function(all_months) {
      self$all_months <- all_months
    },
    get_data_by_month = function(month) {
      return(self$all_months %>% filter(Session == month))
    },
    filter_data_for_multisession = function() {
      sessions_with_more_than_5_grids <- private$get_sessions_with_more_than_5_grids_()
      filtered_sessions <- self$all_months %>% filter(Session %in% sessions_with_more_than_5_grids)
      return(filtered_sessions)
    }
  ),
  private = list(
    get_sessions_with_more_than_5_grids_ = function() {
      sessions_with_more_than_5_grids <- self$all_months %>%
        group_by(Session) %>%
        summarize(n_grids = n()) %>%
        filter(n_grids >= 5) %>%
        ungroup()
      return(sessions_with_more_than_5_grids$Session)
    }
  )
)
