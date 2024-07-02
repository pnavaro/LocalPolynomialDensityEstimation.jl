# LocalPolynomialDensityEstimation.jl

Estimate bivariate densities using nonparametric local polynomial procedures

## Development notes

- `random_shape` : shape using Bezier curve from random points
- `inside` to determine if a point is inside the window boundary or not
- `Window` type with a polygon as boundary
- `Image` type that contains a polynomial and a window
