context("test-blizz")

test_that("blizz works", {
  expect_equal(class(blizz("/data/sc2/league/37/201/0/6")), "list")
})
