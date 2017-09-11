context("Quadratic Formula")

test_that("find_root handles constant polynomials correctly", {
  expect_equal(find_root(0, 0, 1), "This polynomial has no roots")
  expect_equal(find_root(0, 0, 0), "All x are roots of this polynomial")
})

test_that("find_root handles linear polynomials correctly", {
  expect_equal(find_root(0, 1, 0), c(root1 = 0, root2 = NA))
  expect_equal(find_root(0, 2, 1), c(root1 = -1/2, root2 = NA))
})

test_that("find_root handles roots of quadratic polynomials correctly", {
  expect_length(find_root(1, -1, 0), 2)
  expect_true(all(c(0, 1) %in% find_root(1, -1, 0)))
  expect_equal(find_root(1, 2, 1), c(root1 = -1, root2 = -1))
  expect_length(find_root(1, 0, 1), 2)
  expect_true(all(c(0+1i, 0-1i) %in% find_root(1, 0, 1)))
})