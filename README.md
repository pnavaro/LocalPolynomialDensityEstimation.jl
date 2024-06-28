# LocalPolynomialDensityEstimation.jl

Estimate bivariate densities using nonparametric local polynomial procedures

## Development steps

- `random_shape` : shape using Bezier curve from random points
- `ìnshape` to determine if a point is inside the shape or not
- `Window` type with a polygon as boundary
- `Image` type that contains a polynomial and a window
