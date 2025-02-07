# -*- coding: utf-8 -*-
# ---
# jupyter:
#   jupytext:
#     cell_metadata_filter: -all
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.4
#   kernelspec:
#     display_name: Julia 1.11.1
#     language: julia
#     name: julia-1.11
# ---

using LocalPolynomialDensityEstimation
using Plots
using RCall
using Test

R"""
polynomial_sector <- function(k, npoly = 128) {
  x1 <- c(1, 1)
  y1 <- c(0, 1)
  x2 <- seq(1, 0, length.out = npoly)
  y2 <- x2 ** k
  x3 <- c(0, 1)
  y3 <- c(0, 0)

  x <- c(x1, x2, x3)
  y <- c(y1, y2, y3)
  spatstat.geom::owin(poly =  list(x = x, y = y))
}
f_poly <-  function(x, y, k) {
  domain <- polynomial_sector(k)
  a <- 0.6
  b <- 0.2
  g <- function(u, v) {abs(u - a) ** 2 + abs(v - b) ** 2}
  A <- spatstat.geom::integral.im(spatstat.geom::as.im(g, domain), domain = domain)
  g(x, y) / A
}
k <- 2
domain <- polynomial_sector(k)
f <- function(x, y) {f_poly(x, y, k)}
c(f(0, 0), f(1,0), f(1,1), f(1,0))
"""

# +
@time begin
R"""
n <- 1000
data <- spatstat.random::rpoint(n, f, win = domain)
"""
end

@rget data
scatter(data[:x], data[:y], aspect_ratio=1)

# +
k = 2
domain = polynomial_sector(k)
function f(x, y, k) 
    w = polynomial_sector(k)
    g(u, v) = begin
        a, b = 0.6, 0.2
        (u - a)^2 + (v - b)^2
    end
    z = PixelImage(g, w)
    g( x, y) / integral(z)
end

f(0, 0), f(1,0), f(1,1), f(1,0)

# +
n = 100

function rpoint(n::Int,f::Function, w::ObservationWindow )
        pbar = 1
        nremaining = n
        totngen = 0
        ntries = 0
        isim = 1
        X = PlanarPoint[]
        while true
            ntries += 1
            @show ngen :: Int = nremaining ÷ pbar + 10
            totngen += ngen
            if ngen > 0
                for i in 1:ngen
                    prop_x, prop_y = rand(2)
                    if rand() < f(prop_x, prop_y)
                        p = PlanarPoint(prop_x, prop_y)
                        inside(p, w) && push!(X, p)
                    end
                    nX = length(X)
                    pbar = nX / totngen
                    @show nremaining = n - nX
                    if nremaining <= 0
                        return PlanarPointPattern(X[1:n])
                    end
                end
            end
        end
    end
@time ppp = rpoint(n, (x,y) -> f(x, y, k), w)
# -

plot(ppp, aspect_ratio = 1)

R"""
h <- 0.1
f_sparr <- sparr::bivariate.density(data, h)$z
"""
@rget f_sparr
contourf(f_sparr[:xcol], f_sparr[:yrow], f_sparr[:v], aspect_ratio=1)

# f_sparr[:v]
# 
# df = bivariate_density(ppp, 0.1)
# 
# nx = length(df.x)
# 
# df2 = Matrix{Union{Missing, Float64}}(similar(df.density))
# df2[df.density .≈ 0] .= missing
# 
# contourf(df.x, df.y, df2')
# 
# m = 
# 
#                 mylp <- density_estimation(
#                               data,
#                               domain,
#                               at_points = zero,
#                               bandwidth = h,
#                               degree = m
#                             )
#             }
#         }
#     }
# }
# """
