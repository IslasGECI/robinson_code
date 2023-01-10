
Writer_Prediction_And_Cells_With_Camera_Data <- R6::R6Class("Writer",
  public = list(
    path_predictions = NULL,
    initialize = function(){
      self$path_predictions <- "path predictions"
    }
  )
)
