library(tidyverse)
library(sf)
library(terra)
library(ggspatial)
library(eradicate)


plot_camera_positons_in_square_grid <- function(coordinates_path = "data/raw/robinson_coati_detection_camera_traps/camera_trap_coordinates.csv", camera_sightings_path = "data/Camera-Traps.csv", crusoe_shp_path = "data/spatial/Robinson_Coati_Workzones_Simple.shp", square_grid_path = "data/spatial/Robinson_Coati_1kmGrid_SubsetCameraGrids.shp", plot_output_path) {
  crusoe_shp <- read_sf(crusoe_shp_path)
  square_grid <- read_sf(square_grid_path)
  camera_coordinates <- read_csv(coordinates_path, show_col_types = FALSE)
  camera_sightings <- read_csv(camera_sightings_path, show_col_types = FALSE)
  # remove camera coords with ID == NA
  camera_coordinates <- camera_coordinates %>%
    mutate(ID = `N Cuadricula`) %>%
    filter(!is.na(ID))

  # process camera obs
  camera_sightings <- camera_sightings %>% filter(Grid %in% camera_coordinates$ID)

  cobs_n <- camera_sightings %>% select(ID = Grid, Session, starts_with("r"))
  cobs_e <- camera_sightings %>% select(ID = Grid, Session, starts_with("e"))
  cobs_l <- camera_coordinates %>%
    filter(ID %in% cobs_n$ID) %>%
    select(ID, X = Easting, Y = Norting)
  cobs_l <- st_as_sf(cobs_l, coords = c("X", "Y"), crs = 32717)

  # Quick plot of grid cells and camera locations
  png(file = plot_output_path, width = 600, height = 350)
  plot(st_geometry(crusoe_shp))
  plot(st_geometry(square_grid), add = TRUE)
  plot(st_geometry(cobs_l), add = TRUE, pch = 16, col = "red")
  dev.off()
}
