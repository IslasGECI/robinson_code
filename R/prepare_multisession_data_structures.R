Multisession <- R6::R6Class("Multisession",
  public = list(
    all_data = NULL,
    data_for_multisession = NULL,
    initialize = function(all_data) {
      self$all_data <- all_data
      self$data_for_multisession <- private$setup_data_for_multisession_()
    }
  ),
  private = list(
    setup_data_for_multisession_ = function() {
      sorted_data <- private$sort_by_session_and_grid_()
      new_names_session <- private$get_new_names_session_()
      renamed_sessions <- sorted_data %>% mutate(Session = new_names_session)
      return(renamed_sessions)
    },
    get_new_names_session_ = function() {
      number_of_grids <- length(private$present_grids())
      number_of_sessions <- length(private$present_sessions())
      sessions <- 1:number_of_sessions
      return(rep(sessions, each = number_of_grids))
    },
    present_grids = function() {
      return(unique(self$all_data$Grid))
    },
    present_sessions = function() {
      return(unique(self$all_data$Session))
    },
    expanded_grid_session_ = function() {
      present_grids <- private$present_grids()
      present_sessions <- private$present_sessions()
      return(expand.grid(present_grids, present_sessions))
    },
    get_complete_multisession_ = function() {
      expanded_grid_session <- private$expanded_grid_session_()
      expanded_data <- right_join(self$all_data, expanded_grid_session, by = c("Grid" = "Var1", "Session" = "Var2"))
      return(expanded_data %>% replace(is.na(.), 0))
    },
    sort_by_session_and_grid_ = function() {
      expanded_data <- private$get_complete_multisession_()
      return(expanded_data %>% arrange(lubridate::ym(expanded_data$Session), Grid))
    }
  )
)
