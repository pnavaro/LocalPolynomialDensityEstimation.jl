# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.2
#   kernelspec:
#     display_name: Julia 1.10.4
#     language: julia
#     name: julia-1.10
# ---

using Plots
using RCall
R"library(spatstat.random)"

# 100 uniform random points in the unit square

# # Sampling from a probability distribution
#
# Construct the CDF numerically and find the closest value 

# +
function rpoint( n, f )
    xmin, xmax = 0.0, 1.0
    dx = (xmax - xmin) / (n-1)
    x = LinRange(xmin, xmax, n)
    d = cumsum(f.(x)) * dx 
    xp = Float64[]
    for k=1:n
       r = xmin + rand() * (xmax - xmin)
       j = findmin(abs.(d .- r) )[2]
       push!(xp,  x[j])
    end
    xp
end

g(x) = x
xp = rpoint(10000, g )
histogram(xp, bins=64, normalize=true)
# -

R"X <- rpoint(100)"
X = @rget X

using LocalPolynomialDensityEstimation

ppp = PlanarPointPattern(100)

# +
using Plots

plot(ppp)
# -

# 100 random points with probability density proportional to $x^2 + y^2$ with max(f)=1

# +
R"""
X <- rpoint(10000, function(x,y) { x})
"""

X = @rget X

histogram(X[:x], bins=64, normalize=true)
# -




# +
R"""
 # `fmax' may be omitted
 X <- rpoint(10000, function(x,y) { x^2 + y^2})
"""
X = @rget X

histogram2d(X[:x], X[:y], bins=64)
# -

R"""
 # irregular window
 X <- rpoint(1000, function(x,y) { x^2 + y^2}, win=letterR)
"""
X = @rget X

histogram2d(X[:x], X[:y], bins=64)

R"""
 # make a pixel image 
 Z <- setcov(letterR)
 # 100 points with density proportional to pixel values
 X <- rpoint(10000, Z)
"""
X = @rget X
histogram2d(X[:x], X[:y], bins=64)

@rget Z


