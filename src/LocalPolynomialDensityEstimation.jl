module LocalPolynomialDensityEstimation

using DocStringExtensions
using NearestNeighbors
using Random
using RecipesBase
import Statistics: mean

import KernelDensity

include("planar_point.jl")
include("observation_window.jl")
include("pixel_image.jl")
include("inside.jl")
include("planar_point_pattern.jl")
include("orthonormal_polynomials.jl")
include("density_estimation.jl")
include("shape.jl")
include("bivariate_density.jl")
include("polynomial_sector.jl")



end
