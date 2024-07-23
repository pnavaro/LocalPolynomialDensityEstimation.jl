# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.3
#   kernelspec:
#     display_name: Julia 1.10.4
#     language: julia
#     name: julia-1.10
# ---

using LocalPolynomialDensityEstimation
using Plots

s = random_shape(; rad = 0.2, edgy = 0.1)


plot(s)

points = rand(2,100)
random_points = [Point(p...) for p in eachcol(points)]

scatter(random_points, group=[inshape(p, s) for p in random_points])
plot!(s)




