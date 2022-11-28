library(tidyverse)
library(robinson)

opciones <- cli_get_ramsey_format()
species <- opciones[["species"]]
camera_sightings <- read_csv(input_files[[species]], show_col_types = FALSE)
ramsey_format <- camera_traps_2_ramsey_format(camera_sightings)
output_path <- output_files[[species]]
write_csv(ramsey_format, output_path)
