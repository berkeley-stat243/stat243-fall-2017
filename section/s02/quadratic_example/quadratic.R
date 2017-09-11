find_root <- function(a, b, c) {
  # Finds roots of real polynomials up to degree 2
  # Inputs:
  #   a, b, c - numeric, real coefficients of the polynomial ax^2 + bx + c
  # Output:
  #   root1, root2 (if it exists) - numeric, value of roots
  
  if (all(c(a, b, c) == c(0, 0, 0))) return("All x are roots of this polynomial")
  if (all(c(a, b) == c(0, 0))) return("This polynomial has no roots")
  
  if (a == 0) return(c(root1 = -c/b, root2 = NA))
  
  d2 <- b^2 - 4*a*c
  d <- sqrt(d2)
  
  c(root1 = -b + d/2/a,
    root2 = -b - d/2/a)
  
}