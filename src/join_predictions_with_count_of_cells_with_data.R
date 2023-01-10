library(robinson)
library(tidyverse)
library(optparse)

opciones <- cli_get_multisession_predictions()
species <- opciones[["species"]]
path_predictions <- output_prediction[[species]]
multisession_data_path <- input_multisession[[species]]
write_prediction_and_cells_with_camera_data(path_predictions, multisession_data_path)
