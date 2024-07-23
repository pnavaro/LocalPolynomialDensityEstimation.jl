module LocalPolynomialDensityEstimation

using DocStringExtensions
using RecipesBase
import Statistics: mean
using TypedPolynomials

include("point.jl")
include("observation_window.jl")
include("pixel_image.jl")
include("planar_point_pattern.jl")
include("inside.jl")
include("orthonormal_polynomials.jl")
include("density_estimation.jl")
include("shape.jl")
include("polynomial_sector.jl")

end
