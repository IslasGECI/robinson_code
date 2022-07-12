library(tidyverse)

#' @export
raw_2_ocassion <- function(data) {
  dates <- as.character(data$DateTime)
  ocassions <- lubridate::isoweek(dates)
  camera_IDs <- as.numeric(gsub(".*?([0-9]+).*", "\\1", data$RelativePath))
  coati_count <- data$CoatiCount
  result <- tibble(
    date = dates,
    ocassion = ocassions,
    camera_ID = camera_IDs,
    coati_count = coati_count
  )
  return(result)
}

ocassion_2_tidy <- function(ocassion_structure) {
  return(TRUE)
}
