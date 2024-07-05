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

using RCall
R"library(spatstat.random)"

# 100 uniform random points in the unit square

R"X <- rpoint(100)"
X = @rget X

using LocalPolynomialDensityEstimation

ppp = PlanarPointPattern(100)

# +
using Plots

plot(ppp)
# -

 # 100 random points with probability density proportional to x^2 + y^2
 X <- rpoint(100, function(x,y) { x^2 + y^2}, 1)

 # `fmax' may be omitted
 X <- rpoint(100, function(x,y) { x^2 + y^2})

 # irregular window
 X <- rpoint(100, function(x,y) { x^2 + y^2}, win=letterR)

 # make a pixel image 
 Z <- setcov(letterR)
 # 100 points with density proportional to pixel values
 X <- rpoint(100, Z)
