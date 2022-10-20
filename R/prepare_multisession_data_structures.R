Multisession <- R6::R6Class("Multisession",
  public = list(
    all_data = NULL,
    initialize = function(all_data) {
      self$all_data <- all_data
    },
    present_grids = function() {
      return(unique(self$all_data$Grid))
    },
    present_sessions = function() {
      return(unique(self$all_data$Session))
    },
    expanded_grid_session = function() {
      present_grids <- self$present_grids()
      present_sessions <- self$present_sessions()
      return(expand.grid(present_grids, present_sessions))
    },
    get_complete_multisession = function() {
      expanded_grid_session <- self$expanded_grid_session()
      expanded_data <- right_join(self$all_data, expanded_grid_session, by = c("Grid" = "Var1", "Session" = "Var2"))
      return(expanded_data %>% replace(is.na(.), 0))
    },
    sort_by_session_and_grid = function() {
      expanded_data <- self$get_complete_multisession()
      return(expanded_data %>% arrange(lubridate::ym(expanded_data$Session), Grid))
    },
    rename_session = function() {
      number_of_grids <- length(self$present_grids())
      number_of_sessions <- length(self$present_sessions())
      sessions <- 1:number_of_sessions
      sorted_data <- self$sort_by_session_and_grid()
      renamed_sessions <- sorted_data %>% mutate(Session = rep(sessions, each = number_of_grids))
      return(renamed_sessions)
    },
    setup_data_for_multisession = function(){
      number_of_grids <- length(self$present_grids())
      number_of_sessions <- length(self$present_sessions())
      sessions <- 1:number_of_sessions
      sorted_data <- self$sort_by_session_and_grid()
      renamed_sessions <- sorted_data %>% mutate(Session = rep(sessions, each=number_of_grids))
      return(renamed_sessions)
    }
  )
)
