Multisession <- R6::R6Class("Multisession", 
  public = list(
    all_months = NULL,
    initialize = function() {
      self$all_months <- NULL
    }
  )
  )
