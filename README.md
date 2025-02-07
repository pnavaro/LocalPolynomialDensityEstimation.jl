# LocalPolynomialDensityEstimation.jl

Estimate bivariate densities using nonparametric local polynomial procedures

## Development notes

- `random_shape` : shape using Bezier curve from random points
- `inside` to determine if a point is inside the window boundary or not
- `ObservationWindow` observation window in the two-dimensional plane with a polygon as boundary
- `PixelImage` type that contains a polynomial and a Window
- `PlanarPointPattern` type
- `random_points` : create differents point patterns
