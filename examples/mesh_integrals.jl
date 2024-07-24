# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
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

using Meshes
using MeshIntegrals
using BenchmarkTools

x1, x2 = 0.0, 1.0
y1, y2 = 0.0, 1.0
square = Ngon((x1,y1), (x2,y1), (x2,y2), (x1,y2))
typeof(square)

g(x, y) = 3x + y^2
g(p) = g(p.coords...)

@btime integral($g, $square, $GaussKronrod())

# +
import LocalPolynomialDensityEstimation
using TypedPolynomials

@polyvar x y

f = 3x + y^2

z = LocalPolynomialDensityEstimation.PixelImage(f, (x1,x2), (y1,y2))

w = LocalPolynomialDensityEstimation.ObservationWindow((x1,x2), (y1,y2))

@btime LocalPolynomialDensityEstimation.integral($z, $w )
# -






