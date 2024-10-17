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
#     display_name: Julia 1.11.0
#     language: julia
#     name: julia-1.11
# ---

# +
using LocalPolynomialDensityEstimation
using Plots
using RCall

R"""
library(spatstat)
"""
# -

R"""
x <- runif(100)
y <- runif(100)

X <- ppp(x, y)
bd <- density.ppp(X, h0=1.5)
"""
bd = @rget bd

contourf(bd[:v])

data = @rget X

scatter(data[:x], data[:y])

w1 = ObservationWindow((0,1), (0,1))
p1 = PlanarPointPattern( data[:x], data[:y], w1)

density_ppp(p1)



