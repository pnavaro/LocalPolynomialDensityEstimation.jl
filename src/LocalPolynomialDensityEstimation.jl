module LocalPolynomialDensityEstimation

using DocStringExtensions
using RecipesBase
import Statistics: mean
using TypedPolynomials

include("point.jl")
include("image.jl")
include("window.jl")
include("inside.jl")
include("orthonormal_polynomials.jl")
include("density_estimation.jl")
include("shape.jl")

end
