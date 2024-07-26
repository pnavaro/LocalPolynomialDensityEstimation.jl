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
using RCall

R"""
library(spatstat)
"""

# +
R"""
x <- runif(20)
y <- runif(20)

X <- ppp(x, y)
bd <- sparr::bivariate.density(X,h0=1.5)
plot(bd)
"""
bd = @rget bd

bd[:z]
