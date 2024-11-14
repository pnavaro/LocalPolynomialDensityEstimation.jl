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
using KernelDensity
using Plots

x = (0.5, 1, 0.5, 0)
y = (0, 1, 2, 1)
w = ObservationWindow(x, y)


polynomial_sector(1)

f_norm(0.5, 0.5, 1)

# +
@polyvar x y

n = 200
k = 1
idx = (1, 1)

domain = polynomial_sector(k)

f = (x, y) -> f_poly(x, y, k)

f00 = f(0, 0)

eps = 0.001

zero = PlanarPointPattern(eps, eps^k / 2, domain)
data = PlanarPointPattern(n, f, domain)

h = 0.1
x = [p.x for p in data.points]
y = [p.y for p in data.points]

f_sparr = kde((x, y), boundary = boundary(data.window), bandwidth = (h, h)).density

contourf(f_sparr)
# -
m = 0
density_estimation(data, domain, at_points = zero, bandwidth = h, degree = m)

#        f_sparr = as.vector(f_sparr[idx[1], idx[2]])
#       
#        value = (f_sparr - f00) ** 2
#      
#        for m in MM
#          mylp = density_estimation(data,domain,at_points = zero,bandwidth = h,degree = m)
#        end
