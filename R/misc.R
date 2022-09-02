library(tidyverse)


#' @export
path_for_cameras <- function(month_number) {
  month_name <- tolower(month.name[month_number])
  base <- glue::glue("data/{month_name}_camera_traps.csv")
  return(base)
}
