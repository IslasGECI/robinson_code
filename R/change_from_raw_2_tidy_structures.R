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
    camera_id = camera_IDs,
    coati_count = coati_count
  )
  return(result)
}

#' @export
ocassion_2_tidy <- function(ocassion_structure) {
  filtered_structure <- ocassion_structure %>% group_by(camera_id, ocassion, lubridate::day(date)) %>% summarize(r = sum(coati_count))
  n_rows = nrow(filtered_structure)
  tidy_structure <- tibble(
      camera_id = filtered_structure$camera_id,
      ocassion = filtered_structure$ocassion,
      r = filtered_structure$r,
      e = rep(1, n_rows),
      method = rep("Camera-Traps",n_rows)
    )
  return(tidy_structure)
}
