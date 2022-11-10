testthat::describe("Get camera traps observations", {
  camera_sightings_path <- "../data/data_for_multisession.csv"
  coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
  camera_sightings <- read_csv(camera_sightings_path) %>% mutate(session = Session)
  obtained_camera_observations <- get_camera_observations_multisession(camera_sightings = camera_sightings, coordinates_path = coordinates_path)
  obtained_detections <- obtained_camera_observations[["detections"]]
  it("Test cameras coordinates and grids match", {
    coordinates_path <- "../data/camera_traps_coordinates_april_2022_without_24_and_50.csv"
    camera_sightings <- read_csv(camera_sightings_path) %>% mutate(session = Session)
    obtained_camera_observations <- get_camera_observations_multisession(camera_sightings = camera_sightings, coordinates_path = coordinates_path)
    obtained_detections <- obtained_camera_observations[["detections"]]
    number_of_rows <- 24
    obtained_rows <- nrow(obtained_detections)
    expect_equal(obtained_rows, number_of_rows)
  })
  it("At least one element has wrong dimension number", {
    number_of_session <- 6
    number_of_sites <- 6
    obtained_rows <- nrow(obtained_detections)
    expected_rows <- number_of_session * number_of_sites
    expect_equal(obtained_rows, expected_rows)
  })
  it("Detections have NA's", {
    obtained_NAs <- sum(is.na(obtained_detections))
    expected_NAs <- 209
    expect_equal(obtained_NAs, expected_NAs)
  })
  it("Camera effort is a list of sessions", {
    obtained_effort <- obtained_camera_observations[["effort"]]
    expect_true(inherits(obtained_effort, "list"))
    number_of_session <- 6
    obtained_elements_of_list <- length(obtained_effort)
    expect_equal(obtained_elements_of_list, number_of_session)
    lapply(obtained_effort, function(x) {
      expect_true(inherits(x, "matrix"))
    })
    expected_weeks_by_session <- 6
    lapply(obtained_effort, function(x) {
      obtained_weeks_by_session <- ncol(x)
      expect_equal(obtained_weeks_by_session, expected_weeks_by_session)
    })
  })
  it("Test camera locations", {
    obtained_locations <- nrow(obtained_camera_observations[["locations"]])
    expected_locations <- 6
    expect_equal(obtained_locations, expected_locations)
  })
  it("Remove grid 38", {
    camera_sightings_path <- "../data/data_for_multisession_with_grid_38.csv"
    camera_sightings <- read_csv(camera_sightings_path) %>% mutate(session = Session)
    obtained_camera_observations <- get_camera_observations_multisession(camera_sightings = camera_sightings, coordinates_path = coordinates_path)
    expect_false(38 %in% unique(obtained_camera_observations[["locations"]]$ID))
  })
})
