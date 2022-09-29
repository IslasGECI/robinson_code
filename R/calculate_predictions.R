
buffer_radius <- 500 # m  This should depend on grid size, which should depend on HR size

calc_mode <- function(v) {
  # find most common element in vector
  # excluding NA
  if (all(is.na(v))) {
    return(NA)
  }
  uniqv <- unique(v)
  uniqv <- na.omit(uniqv)
  tabs <- tabulate(match(v, uniqv))
  m <- uniqv[which.max(tabs)]
  m
}

get_predictions <- function(buffer_radius,cobs_l){
    hab1 <- rast("data/spatial/VegetationCONAF2014_50mHabitat.tif")
    cobs_l_buff <- st_buffer(cobs_l, dist = buffer_radius)
    habvals <- terra::extract(hab1, vect(cobs_l_buff), fun = calc_mode)
    habvals <- habvals %>%
      select(-ID, habitat = starts_with("Veg")) %>%
      mutate(habitat = factor(habitat))

    y <- cobs_n %>% select(starts_with("r"))
    e <- cobs_e %>% select(starts_with("e"))

    y[e == 0] <- NA # e==0 implies no camera data available so set to NA

    # Fit model
    emf <- eFrame(y = y, siteCovs = habvals, obsCovs = list(effort = e))
    # Fit the Nmixture model
    m <- nmix(~habitat, ~effort, data = emf, K = 100) # set K large enough so estimates do not depend on it

    summary(m)

    # To extrapolate across the island need to extract habitat values for each 1km grid cell
    # However, we need to account for partial grid cells
    gridc_buff <- st_buffer(gridc, dist = buffer_radius)
    allhab <- terra::extract(hab1, vect(gridc_buff), fun = calc_mode)
    allhab <- allhab %>% select(-ID, habitat = starts_with("Veg"))

    # need to account for grid cells with fractional coverage of the island
    # first clip the grid to the island boundary
    grid_clip <- st_intersection(grid, crusoe)

    cell_size <- as.numeric(st_area(grid)) / 1e6 # km2
    rcell_size <- cell_size / max(cell_size)
    print("Estamos en la línea 87")
    allhab <- allhab %>%
      mutate(ID = grid$Id, rcell = round(rcell_size, 3)) %>%
      relocate(ID, .before = habitat)

    # Need to drop level '10' as this was not included in the model so
    # we can not get predictions for it.
    # This means we only get predictions for 49 of the 50 grid cells

    allhab <- allhab %>%
      filter(habitat != 10) %>%
      mutate(habitat = factor(habitat))

    preds <- calcN(m, newdata = allhab, off.set = allhab$rcell)

    # Total population size
    print(preds$Nhat)
    predictions <- array(list(), 2)

    predictions[[1]] <- list("buffer_radius" = buffer_radius, "prediction" = preds)

    # Plot cell predictions
    allhab <- allhab %>% mutate(N = preds$cellpreds$N)
    pred_grid <- inner_join(grid_clip, allhab, by = c("Id" = "ID"))

    pred_grid %>% ggplot() +
      geom_sf(aes(fill = N)) +
      scale_fill_distiller(palette = "OrRd", direction = 1, limits = c(0, 13)) +
      geom_sf(fill = NA, data = crusoe)
    ggsave("data/plot_pred_grid.png")
}
