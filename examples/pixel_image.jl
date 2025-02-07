# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.4
#   kernelspec:
#     display_name: Julia 1.11.1
#     language: julia
#     name: julia-1.11
# ---

using LocalPolynomialDensityEstimation
using Plots
using Random

mat = rand(30, 40)
img = PixelImage(mat, (0, 1), (0, 1))

contourf(img)

rng = Xoshiro(43)
s = RandomShape(rng; rad = 0.2, edgy = 0.1)
plot(s)

mat = zeros(40, 60)
z = PixelImage(mat, (0, 1), (0, 1))

plot(PlanarPointPattern(z, s))


