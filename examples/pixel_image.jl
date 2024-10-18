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
using RCall

R"""
library(spatstat.geom)
vec <- rnorm(1200)
mat <- matrix(vec, nrow=30, ncol=40)
whitenoise <- im(mat, xrange=c(0,1), yrange=c(0,1))
"""

z = @rget whitenoise

contourf(reshape(z[:v], 30, 40))

R"""
im <- whitenoise
xcol <- im$xcol
yrow <- im$yrow
x = rep(xcol, times = length(yrow))
y = rep(yrow, each = length(xcol))
"""
xcol = @rget xcol
yrow = @rget yrow

y

xcol = collect(LinRange(0, 1, 30)[1:end-1])

repeat(xcol, length(yrow))

x

R"im$xcol"



LinRange(0, 1, 30)




