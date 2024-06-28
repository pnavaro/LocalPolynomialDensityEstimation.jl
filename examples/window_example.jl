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

# +
using LocalPolynomialDensityEstimation
using Plots
using TypedPolynomials

# -

w = Window((0.5,1,0.5,0) , (0,1,2,1) )

plot(w.boundary)

@polyvar x y

f = 3x^2 + 2y

z = Image(f, (0,1), (0,1))

@show integral(z)

w = Window((0.1,0.9), (0.2,0.8))

@show integral(z, w )


