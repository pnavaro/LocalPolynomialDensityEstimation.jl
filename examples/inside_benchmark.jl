
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

# +
using LocalPolynomialDensityEstimation
using Plots
using RCall

R"library(spatstat.geom)"
R"library(spatstat.random)"
# +
# hexagonal window
#
R"""
k <- 100
theta <- 2 * pi * (0:(k-1))/k
co <- cos(theta)
si <- sin(theta)
mas <- owin(c(-1,1), c(-1,1), poly=list(x=co, y=si))
"""
  
mas = @rget mas

# random points in rectangle


R"""
n <- 1000
x <- runif(n,min=-1, max=1)
y <- runif(n,min=-1, max=1)
"""
 
@time R"ok <- inside.owin(x, y, mas)"

x = @rget x  
y = @rget y  
ok = @rget ok

scatter(x[ok], y[ok], xlims = (-1,1), ylims = (-1, 1), aspect_ratio=1)
scatter!(x[.!ok], y[.!ok], xlims = (-1,1), ylims = (-1, 1), aspect_ratio=1)

co = @rget co
si = @rget si
hex = ObservationWindow( co, si)
@time ok = inside(x, y, hex)

scatter(x[ok], y[ok], xlims = (-1,1), ylims = (-1, 1), aspect_ratio=1)
scatter!(x[.!ok], y[.!ok], xlims = (-1,1), ylims = (-1, 1), aspect_ratio=1)




