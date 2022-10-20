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
    }
  )
)
