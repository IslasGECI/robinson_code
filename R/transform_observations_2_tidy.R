library(tidyverse)

concatenate_observations_from_trapping_and_hunting <- function(path_config) {
  hunting_raw <- read_csv(path_config[["hunting"]], show_col_types = FALSE)
  trapping_raw <- read_csv(path_config[["trapping"]], show_col_types = FALSE)
  observations_raw <- read_csv(path_config[["sighting"]], show_col_types = FALSE)
  hunting <- subset(hunting_raw, select = -c(Hunted_Coati))
  trapping <- subset(trapping_raw, select = -c(`Night-traps`, Captured_Coati))
  observations <- rbind(hunting, trapping, observations_raw)
  return(observations)
}
