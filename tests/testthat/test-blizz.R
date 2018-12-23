context("test-blizz")

test_that("blizz works", {

  # Expect JSON output when json=TRUE
  expect_equal(attributes(blizz("data/sc2/league/37/201/0/6?locale=en_US&", json=TRUE))[[1]], "json")

  # Expect list when json=NULL
  expect_type(blizz("data/sc2/league/37/201/0/6?locale=en_US&"), "list")

})
