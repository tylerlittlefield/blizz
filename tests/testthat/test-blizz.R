context("test-blizz")

# Pull some data
df <- blizz("/d3/data/act", quiet = TRUE)
df_json <- blizz("/d3/data/act", quiet = TRUE, json = TRUE)

test_that("blizz works", {
  expect_equal(typeof(df), "list")
  expect_equal(attributes(df_json)[["class"]], "json")
})
