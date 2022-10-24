describe("Get camera traps observations", {
  camera_sightings_path <- "../data/data_for_multisession.csv"
  coordinates_path <- "../data/camera_traps_coordinates_april_2022.csv"
  camera_sightings <- read_csv(camera_sightings_path) %>% mutate(session = Session)
  obtained_camera_observations <- get_camera_observations_multisession(camera_sightings = camera_sightings, coordinates_path = coordinates_path)
  it("Test cameras coordinates and grids match", {
    coordinates_path <- "../data/camera_traps_coordinates_april_2022_without_24_and_50.csv"
    camera_sightings <- read_csv(camera_sightings_path) %>% mutate(session = Session)
    expect_error(get_camera_observations_multisession(camera_sightings = camera_sightings, coordinates_path = coordinates_path))
  })
  it("At least one element has wrong dimension number", {
    obtained_detections <- obtained_camera_observations[["detections"]]
    number_of_session <- 6
    number_of_sites <- 6
    obtained_rows <- nrow(obtained_detections)
    expected_rows <- number_of_session * number_of_sites
    expect_equal(obtained_rows, expected_rows)
  })
})
