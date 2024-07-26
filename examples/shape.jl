# -*- coding: utf-8 -*-
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

using LocalPolynomialDensityEstimation
using Meshes
using Plots

s = RandomShape(; rad = 0.2, edgy = 0.1)


plot(s)

points = rand(2,100)
random_points = [Point(p...) for p in eachcol(points)]

scatter(random_points, group=[inshape(p, s) for p in random_points])
plot!(s)

import Pkg; Pkg.add("AbstractTrees")

using AbstractTrees
AbstractTrees.children(d::DataType) = subtypes(d)
print_tree(Polygon)

# +
x1, x2 = 0.0, 1.0
y1, y2 = 0.0, 1.0
α = 0.5
square1 = Ngon((x1,y1), (x2,y1), (x2,y2), (x1,y2))
square2 = Ngon((x1+α,y1+α), (x2+α,y1+α), (x2+α,y2+α), (x1+α,y2+α))


# -

coords(square1)


intersect(square1, square2) |> viz


