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
    }
  )
)
