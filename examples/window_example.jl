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

x=(0.5,1,0.5,0) 
y=(0,1,2,1) 
# -

w = Window(x, y)

plot(w.boundary)

f(x,y) = 3x^2 + 2y

z = Image(f, (0,1), (0,1))

integral(z)

w = Window((0.1,0.9), (0.2,0.8))

integral(z, w )


