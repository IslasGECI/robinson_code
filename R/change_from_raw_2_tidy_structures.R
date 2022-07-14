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
    mutate(e = 1, method = "Camera-Traps") %>%
    ungroup()
  return(filtered_structure)
}

calculate_effort <- function(grouped_data) {
  group_by_id_ocassion <- grouped_data %>%
    group_by(camera_id, ocassion) %>%
    summarize(e = sum(e), r = sum(r)) %>%
    ungroup() %>%
    mutate(method = "Camera-Traps") 
  return(group_by_id_ocassion)
}

#' @export
tidy_from_path <- function(path) {
  data <- readr::read_csv(path)
  filtered_structure <- filter_raw_data(data)
  obtained_grouped <- group_filtered_data(filtered_structure)
  obtained_effort <- calculate_effort(obtained_grouped)
  return(obtained_effort)
}
