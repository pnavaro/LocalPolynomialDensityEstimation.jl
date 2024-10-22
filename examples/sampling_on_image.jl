# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.4
#   kernelspec:
#     display_name: Julia 1.11.0
#     language: julia
#     name: julia-1.11
# ---

# +
using LocalPolynomialDensityEstimation
using Plots
using RCall

R"library(spatstat.geom)"
R"library(spatstat.random)"
# +
R"X <- rpoint(100, function(x,y) { x^2 + y^2}, 1)"

X = @rget X
scatter(X[:x], X[:y])

# +


f = (x, y) -> x^2 + y^2
n = 100
# -

w = ObservationWindow((0.1, 0.9), (0.2, 0.8))
ppp = PlanarPointPattern(n, f, w)

plot(ppp, xlims = (0, 1), ylims = (0, 1))
