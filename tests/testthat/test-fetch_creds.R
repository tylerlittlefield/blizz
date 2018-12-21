context("test-fetch_creds")

test_that("fetch_creds works", {
  expect_type(fetch_creds(), "list")
  expect_equal(names(fetch_creds()[1]), "id")
  expect_equal(names(fetch_creds()[2]), "secret")
  expect_equal(names(fetch_creds()[3]), "token")
  expect_error(fetch_creds("no args allowed"))
})
