# -*- coding: utf-8 -*-
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

using LocalPolynomialDensityEstimation
using Meshes
using Plots
using Random

rng = Xoshiro(41)
s = RandomShape(rng; rad = 0.2, edgy = 0.1)
plot(s)


points = rand(2, 100)
random_points = [PlanarPoint(p...) for p in eachcol(points)]
scatter(random_points, group = [inside(p, s) for p in random_points])
plot!(s)

# +
x1, x2 = 0.0, 1.0
y1, y2 = 0.0, 1.0
α = 0.5
square1 = Ngon((x1, y1), (x2, y1), (x2, y2), (x1, y2))
square2 = Ngon((x1 + α, y1 + α), (x2 + α, y1 + α), (x2 + α, y2 + α), (x1 + α, y2 + α))


# -

intersect(square1, square2)

ring = intersect(square1, square2)

vertices(ring)

ring
