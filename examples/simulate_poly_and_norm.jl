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

using RCall

R"""

points_inside_owin <- function(points, W) {
  spatstat.geom::verifyclass(points, "ppp")
  spatstat.geom::verifyclass(W, "owin")

  ok <- spatstat.geom::inside.owin(points$x, points$y, W)
  spatstat.geom::ppp(x = points$x[ok], y = points$y[ok], window = W)
}

grid_from_im <- function(im, W) {
  spatstat.geom::verifyclass(im, "im")
  spatstat.geom::verifyclass(W, "owin")
  points <- spatstat.geom::ppp(
    x = rep(im$xcol, times = length(im$yrow)),
    y = rep(im$yrow, each = length(im$xcol)),
    window = spatstat.geom::as.owin(im),
    check = FALSE
  )
  points_inside_owin(points, W)
}

nn_im_grid <- function(x, y, im, W){

  spatstat.geom::verifyclass(x, "numeric")
  spatstat.geom::verifyclass(x, "numeric")
  spatstat.geom::verifyclass(im, "im")
  spatstat.geom::verifyclass(W, "owin")

  v <- spatstat.geom::ppp(x, y, W)
  grid <- grid_from_im(im, W)
  n <- spatstat.geom::nncross(v, grid)$which
  c(grid$x[n], grid$y[n])
}

usual_polynomials <- function(deg, W){
  out <- list()
  l <- 1
  for(d in 0:deg){
    for(i in 0:d){
      j <- d-i
      out[[l]] <- spatstat.geom::as.im(function(x,y){x^i * y^j}, W = W)
      l <- l+1
    }
  }
  out
}

orthonormal_polynomials <- function(deg, W){
  out <- list()
  plist <- usual_polynomials(deg, W)
  for(i in seq_along(plist)){
    u <- plist[[i]]
    for(j in seq_along(out)){
      v <- out[[j]]
      u <- u - projection(u, v, W)
    }
    out[[i]] <- u
  }
  out <- lapply(out, function(u){u/sqrt(spatstat.geom::integral.im(u*u, W = W))})
  out
}

density_estimation <- function(data,
                               domain,
                               at_points = NULL,
                               resolution = NULL,
                               bandwidth = NULL,
                               degree = 3) {

  x <- at_points$x
  y <- at_points$y

  H <- spatstat.geom::owin(c(x - bandwidth, x + bandwidth), c(y - bandwidth, y + bandwidth))
  neighborhood <- spatstat.geom::intersect.owin(H, domain)

  ortho.poly <- orthonormal_polynomials(degree, W = neighborhood)

  datum <- spatstat.geom::subset.ppp(data, subset = neighborhood)

  a <- list()
  for (k in seq_along(ortho.poly)) {
    eta_k <- as.function(ortho.poly[[k]])
    a[[k]] <- sum(eta_k(datum)) / data$n
  }
  loc_poly <- Reduce("+", mapply(a, ortho.poly, FUN = "*", SIMPLIFY = FALSE))
  xy <- nn_im_grid(x, y, ortho.poly[[1]], neighborhood)
  as.function(loc_poly)(xy[1], xy[2])
}

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


f_norm <-  function(x, y, k) {
  domain <- polynomial_sector(k)
  a1 <- 1 / 10
  b1 <- (1 / 10) ** k / 2
  a2 <- 3 / 4
  b2 <- (3 / 4) ** k / 2
  g <- function(u, v) {
    exp(-((u - a1) ** 2 + (v - b1) ** 2) / (2 * 0.4 ** 2)) +
      exp(-((u - a2) ** 2 + (v - b2) ** 2) / (2 * 0.15 ** 2))
  }
  A <-
    spatstat.geom::integral.im(spatstat.geom::as.im(g, domain), domain = domain)
  g(x, y) / A
}


f_poly <-  function(x, y, k) {
  domain <- polynomial_sector(k)
  a <- 0.6
  b <- 0.2
  g <- function(u, v) {
    abs(u - a) ** 2 + abs(v - b) ** 2
  }
  A <-
    spatstat.geom::integral.im(spatstat.geom::as.im(g, domain), domain = domain)
  g(x, y) / A
}
"""

# PARAMETERS

R"""
NN <- c(200) #c(200, 500, 1000, 2000)
HH <- c(0.01) # seq(0.01, 0.6, by = 0.001)
KK <- c(1) # c(1, 2.1)
MM <- 0:0 # 0:5
"""

# LOOPS

R"""
for (n in NN) {
    for (k in KK) {

        # closest points that are not NA

        if (k == 1) {idx <- c(1, 1)} else {idx <- c(1, 10)}

        domain <- polynomial_sector(k)
        f <- function(x, y) {f_poly(x, y, k)}
        f00 <- f(0, 0)
                  
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

res = @rget mylp

res

R"""

NN <- c(200) # c(200, 500, 1000, 2000)
HH <- c(0.01) # seq(0.01, 0.6, by = 0.001)
KK <- c(1) # c(1, 2.1)
MM <- 0:0 # 0:5


for (n in NN) {
    for (k in KK) {
        # closest points that are not NA
        if (k == 1) {idx <- c(1, 1)} else {idx <- c(1, 10)}
        domain <- polynomial_sector(k)
        f <- function(x, y) { f_norm(x, y, k)}
        f00 <- f(0, 0)
    
        # Strangely (0,0) does not belong to domain for spatstat ! Bug?
        eps <- 0.001
        zero <- spatstat.geom::ppp(eps, eps ^ k / 2, domain)
        data <- spatstat.random::rpoint(n, f, win = domain)
    
        for (h in HH) {
            ## Risk of sparr method
            f_sparr <- sparr::bivariate.density(data, h)$z
    
            value = (f_sparr - f00) ** 2
            for (m in MM) {
                 mylp <- density_estimation(data, domain, at_points = zero, bandwidth = h, degree = m)
            }
        }
    }
}
mylp
"""
