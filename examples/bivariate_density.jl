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

# +
using RCall

R"""
library(spatstat)
data(chorley)
"""
# -

R"""
chden1 <- sparr::bivariate.density(chorley,h0=1.5) 
chden2 <- sparr::bivariate.density(chorley,h0=1.5,edge="diggle",resolution=64) 
chden3 <- sparr::bivariate.density(chorley,h0=1.5,hp=1,adapt=TRUE)
chden4 <- sparr::bivariate.density(chorley,h0=1.5,hp=1,adapt=TRUE,davies.baddeley=0.025)
 
par(mfrow=c(2,2))
plot(chden1);plot(chden2);plot(chden3);plot(chden4)  
"""

import Pkg; Pkg.add("KernelDensity")

using KernelDensity

R"""
x <- chorley$x
y <- chorley$y
"""
x = @rget x
y = @rget y

b = kde((x, y))

using Plots
contourf(b.x, b.y, b.density')


