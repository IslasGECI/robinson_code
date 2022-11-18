library(tidyverse)
library(robinson)

camera_sightings <- read_csv("data/Camera-Traps.csv")
ramsey_format <- camera_traps_2_ramsey_format(camera_sightings)
output_path <- "data/multisession-Camera-Traps.csv"
write_csv(ramsey_format, output_path)
