library(robinson)
library(tidyverse)
library(optparse)

opciones <- cli_get_multisession_predictions()
species <- opciones[["species"]]
Writer <- Writer_Prediction_And_Cells_With_Camera_Data$new(species)
Writer$write()
