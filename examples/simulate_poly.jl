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
#     display_name: Julia 1.11.0
#     language: julia
#     name: julia-1.11
# ---

# +
using LocalPolynomialDensityEstimation
using Plots
using RCall
using Test
using TypedPolynomials

@polyvar x y
# -

# Integral on square

R"""
f <- function(x,y){3*x^2 + 2*y}
Z <- spatstat.geom::as.im(f, spatstat.geom::square(1))
"""
f = 3*x^2 + 2*y
z = PixelImage(f, ObservationWindow((0,1), (0,1)))
@test rcopy(R"spatstat.geom::integral.im(Z)") ≈ integral(z)

# Integral on left triangle

R"""
w <- spatstat.geom::owin(poly=list(x=c(0.0,1.0,0.0),y=c(0.0,0.0,1.0)))
z <- spatstat.geom::as.im(f, w)
"""
w = ObservationWindow((0,1,0), (0,0,1))
z = PixelImage(f, w)
@test rcopy(R"spatstat.geom::integral.im(z)") ≈ integral(z)

# Integral on right triangle

R"""
w <- spatstat.geom::owin(poly=list(x=c(0.0,1.0,1.0),y=c(0.0,0.0,1.0)))
z <- spatstat.geom::as.im(f, w)
"""
w = ObservationWindow((0,1,1), (0,0,1))
z = PixelImage(f, w)
@test rcopy(R"spatstat.geom::integral.im(z)") ≈ integral(z)



k = 2
@rput k
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
w <- polynomial_sector(k)
spatstat.geom::integral.im(spatstat.geom::as.im(f, w), domain = w)
"""

w = polynomial_sector(k)
z = PixelImage(f, w)
integral(z)

@test integral(z) ≈ rcopy(R"spatstat.geom::integral.im(spatstat.geom::as.im(f, w), domain = w)")

R"""
f_poly <-  function(x, y, k) {
  domain <- polynomial_sector(k)
  a <- 0.6
  b <- 0.2
  g <- function(u, v) {
    abs(u - a) ** 2 + abs(v - b) ** 2
  }
  A <- spatstat.geom::integral.im(spatstat.geom::as.im(g, domain), domain = domain)
  g(x, y) / A
}
k <- 1
f <- function(x, y) {f_poly(x, y, k)}
"""

f_jl(x, y) = f_poly(x, y, k) 

f_jl(0, 0)

                  
        # Strangely (0,0) does not belong to domain for spatstat ! Bug?

        eps <- 0.001
        zero <- spatstat.geom::ppp(eps, eps ^ k / 2, domain)
        data <- spatstat.random::rpoint(n, f, win = domain)

        for (h in HH) {

            ## Risk of sparr method
            f_sparr <- sparr::bivariate.density(data, h)$z
            f_sparr <- as.vector(f_sparr[idx[1], idx[2]])
            value = (f_sparr - f00) ** 2
            cat(value)
            
            for (m in MM) {

                mylp <- density_estimation(
                              data,
                              domain,
                              at_points = zero,
                              bandwidth = h,
                              degree = m
                            )
            }
        }
    }
}
"""
