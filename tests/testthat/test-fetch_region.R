context("test-fetch_region")

test_that("fetch_region works", {

  # Test that fetch_region is returning expected results
  expect_equal(fetch_region("us")[["region"]], "us")
  expect_equal(fetch_region("us")[["host"]], "https://us.api.blizzard.com/")
  expect_error(fetch_region("not a region :/"))

})
