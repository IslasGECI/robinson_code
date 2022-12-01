library(robinson)
library(tidyverse)

path_predictions <- "/workdir/data/preds_1km_grid-cats.csv"
multisession_data_path <- "/workdir/data/multisession-Camera-Traps-Cats.csv"
write_prediction_and_cells_with_camera_data(path_predictions, multisession_data_path)
