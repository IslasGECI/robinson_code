
Writer_Prediction_And_Cells_With_Camera_Data <- R6::R6Class("Writer",
  public = list(
    predictions_path= NULL,
    multisession_data_path = NULL,
    initialize = function(species) {
      
      self$predictions_path <- private$input_prediction[[species]]
      self$multisession_data_path <- private$input_multisession[[species]] 
    }
  ),
  private = list(
    input_multisession = list(Coatis = "data/multisession-Camera-Traps.csv", Cats = "data/multisession-Camera-Traps-Cats.csv"),
    input_prediction = list(Coatis = "data/preds_1km_grid.csv", Cats = "data/preds_1km_grid-cats.csv")
  )
)
