# ---
# jupyter:
#   jupytext:
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

R"library(spatstat.geom)"
R"library(spatstat.random)"
# -



# +
R"X <- rpoint(100, function(x,y) { x^2 + y^2}, 1)"

X = @rget X
# -

R" f <- function(x,y) { x^2 + y^2}"

R" f$v "

X[:window]

# +
npix = 100
dx  = 0.1
dy  = 0.1
halfdx <- dx/2.0
halfdy <- dy/2.0

xpix <- LinRange(0, 1, npix)
ypix <- LinRange(0, 1, npix)
   
ppix <- as.vector(f$v[M]) ## not normalised - OK
    ## generate
    result <- vector(mode="list", length=nsim)
    for(isim in seq_len(nsim)) {
      ## select pixels
      id <- sample(npix, n, replace=TRUE, prob=ppix)
      ## extract pixel centres and randomise location within pixels
      x <- xpix[id] + runif(n, min= -halfdx, max=halfdx)
      y <- ypix[id] + runif(n, min= -halfdy, max=halfdy)
      if(checkinside) {
        edgy <- which(!inside.owin(x,y,win.out))
        ## reject points just outside boundary
        ntries <- 0
        while((nedgy <- length(edgy)) > 0) {
          ntries <- ntries + 1
          ide <- sample(npix, nedgy, replace=TRUE, prob=ppix)
          x[edgy] <- xe <- xpix[ide] + runif(nedgy, min= -halfdx, max=halfdx)
          y[edgy] <- ye <- ypix[ide] + runif(nedgy, min= -halfdy, max=halfdy)
          edgy <- edgy[!inside.owin(xe, ye, win.out)]
          if(ntries > giveup) break;
        }
      }
      result[[isim]] <- ppp(x, y, window=win.out, check=FALSE)
    }
    result <- simulationresult(result, nsim, drop)
