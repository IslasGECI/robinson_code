library(tidyverse)

#' @export
filter_raw_data <- function(data) {
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
group_filtered_data <- function(filter_table) {
  filtered_structure <- filter_table %>%
    group_by(camera_id, ocassion, day = lubridate::day(date)) %>%
    summarize(r = sum(coati_count)) %>%
    mutate(e = 1, method = "Camera-Traps")
  return(as_tibble(filtered_structure))
}
calculate_effort <- function(grouped_data) {
  group_by_id <- grouped_data %>% group_by(camera_id) %>% summarize(e = sum(e)) 
  effort <- group_by_id$e
  return(effort)
}
