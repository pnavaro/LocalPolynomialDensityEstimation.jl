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
using Plots
using TypedPolynomials


w = ObservationWindow((0.5,1,0.5,0) , (0,1,2,1) )

plot(w)

@polyvar x y

f = 3x^2 + 2y

z = PixelImage(f, (0,1), (0,1))

@show integral(z)

w = ObservationWindow((0.1,0.9), (0.2,0.8))

@show integral(z, w )

ObservationWindow(z)


