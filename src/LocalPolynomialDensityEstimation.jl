module LocalPolynomialDensityEstimation

using DocStringExtensions
using RecipesBase
import Statistics: mean

include("point.jl")
include("window.jl")
include("inside.jl")
include("image.jl")
include("orthonormal_polynomials.jl")
include("density_estimation.jl")
include("shape.jl")

end
