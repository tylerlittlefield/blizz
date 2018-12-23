context("test-fetch_creds")

test_that("fetch_creds works", {

  # Expect a list
  expect_type(fetch_creds(), "list")

  # Expect that the list elements are named correctly
  expect_equal(names(fetch_creds()[1]), "id")
  expect_equal(names(fetch_creds()[2]), "secret")
  expect_equal(names(fetch_creds()[3]), "token")

  # Expect an error when unneeded argument is given
  expect_error(fetch_creds("no args allowed"))

})
