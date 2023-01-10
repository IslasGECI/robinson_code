#' @export
Writer_Prediction_And_Cells_With_Camera_Data <- R6::R6Class("Writer",
  public = list(
    predictions_path = NULL,
    multisession_data_path = NULL,
    output_path = NULL,
    initialize = function(species) {
      private$check_species(species)
      self$predictions_path <- private$input_prediction[[species]]
      self$multisession_data_path <- private$input_multisession[[species]]
      self$output_path <- private$csv_path[[species]]
    },
    write = function() {
      write_prediction_and_cells_with_camera_data(self$predictions_path, self$multisession_data_path, self$output_path)
    }
  ),
  private = list(
    input_multisession = list(Coatis = "data/multisession-Camera-Traps.csv", Cats = "data/multisession-Camera-Traps-Cats.csv"),
    input_prediction = list(Coatis = "data/preds_1km_grid.csv", Cats = "data/preds_1km_grid-cats.csv"),
    csv_path = list(Coatis = "/workdir/prediction_with_count_cells_coatis.csv", Cats = "/workdir/prediction_with_count_cells.csv"),
    check_species = function(species) {
      robinson_species <- names(private$csv_path)
      rlang::arg_match0(species, robinson_species)
    }
  )
)
