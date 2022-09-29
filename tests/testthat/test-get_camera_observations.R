describe("Get camera traps observations", {
    camera_sightings_path <- "../data/april_camera_traps_2022.csv"
    obtained_camera_observations <- get_camera_observations(camera_sightings_path = camera_sightings_path)
  it("Test number of camera observations", {
    obtanied_cobsn <- obtained_camera_observations["detections"]
    expected_cobsn <- 7
    expect_equal(obtanied_cobsn, expected_cobsn)
  })
  it("Test for locations of cameras", {
    obtanied_cobsl <- obtained_camera_observations["locations"]
    expected_cobsl <- 12
    expect_equal(obtanied_cobsl, expected_cobsl)
  })
})