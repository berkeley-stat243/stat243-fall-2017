context("String length")

test_that("str_length is number of characters", {
  expect_equal(nchar("a"), 1)
  expect_equal(nchar("ab"), 2)
  expect_equal(nchar("abc"), 3)
})

test_that("str_length of missing string is missing", {
  expect_equal(nchar(NA), NA_integer_)
  expect_equal(nchar(c(NA, 1)), c(NA, 1))
  expect_equal(nchar("NA"), 2)
})

test_that("str_length of factor is length of level", {
  expect_equal(nchar(factor("a")), 1)
  expect_equal(nchar(factor("ab")), 2)
  expect_equal(nchar(factor("abc")), 3)
})