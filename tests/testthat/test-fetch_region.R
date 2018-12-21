context("test-fetch_region")

test_that("fetch_region works", {
  expect_equal(fetch_region("us")[["region"]], "us")
  expect_equal(fetch_region("us")[["host"]], "https://us.api.blizzard.com/")
  expect_equal(fetch_region("us")[["locale"]], "en_US")
  expect_equal(fetch_region("eu")[["locale"]], "en_GB")
  expect_error(fetch_region("not a region"))
  expect_error(fetch_region("us", "not a locale"))
  expect_equal(fetch_region("eu", "fr_FR")[["locale"]], "fr_FR")
})
