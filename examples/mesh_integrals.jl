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

using Meshes
import MeshIntegrals
using BenchmarkTools
import LocalPolynomialDensityEstimation
using TypedPolynomials

x1, x2 = 0.0, 1.0
y1, y2 = 0.0, 1.0
square = Quadrangle((x1,y1), (x2,y1), (x2,y2), (x1,y2))
typeof(square)

g(x, y) = 3x + y^2
g(p) = g(p.coords...)

MeshIntegrals.surfaceintegral(g, square)

# +

@polyvar x y

f = 3x + y^2

z = LocalPolynomialDensityEstimation.PixelImage(f, (x1,x2), (y1,y2))

w = LocalPolynomialDensityEstimation.ObservationWindow((x1,x2), (y1,y2))

@btime LocalPolynomialDensityEstimation.integral($z, $w )
# +
using Meshes
using MeshIntegrals

# Define a unit circle on the xy-plane
origin = Point(0,0,0)
ẑ = Vec(0,0,1)
xy_plane = Plane(origin,ẑ)
unit_circle_xy = Circle(xy_plane, 1.0)

# Approximate unit_circle_xy with a high-order Bezier curve
unit_circle_bz = BezierCurve(
    [Point(cos(t), sin(t), 0.0) for t in range(0,2pi,length=361)]
)

# A Real-valued function
h(x, y, z) = abs(x + y)
h(p) = f(to(p)...)

integral(h, unit_circle_xy, GaussKronrod())
    # 0.000170 seconds (5.00 k allocations: 213.531 KiB)
    # ans == 5.656854249525293 m^2

integral(h, unit_circle_bz, GaussKronrod())
    # 0.017122 seconds (18.93 k allocations: 78.402 MiB)
    # ans = 5.551055333711397 m^2
# -





