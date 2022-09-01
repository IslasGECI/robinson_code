library(tidyverse)


path_for_cameras <- function(month_number){
  month_name <- "april"
  base <- glue::glue("data/{month_name}_camera_traps.csv")
  return(base)
}
