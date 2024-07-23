# ---
# jupyter:
#   jupytext:
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

R"library(spatstat.geom)"
R"library(spatstat.random)"
# +
R"X <- rpoint(100, function(x,y) { x^2 + y^2}, 1)"

X = @rget X
# -

R" f <- function(x,y) { x^2 + y^2}"

X[:window]

R"w <- owin(c(0,1), c(0,1))"
@rget w



# +
npix = 100
dx  = 0.1
dy  = 0.1
halfdx = 0.5dx
halfdy = 0.5dy

xpix = LinRange(0, 1, npix)
ypix = LinRange(0, 1, npix)
# -

if(is.im(f)) {
    ## ------------ PIXEL IMAGE ---------------------
    if(forcewin) {
      ## force simulation points to lie inside 'win'
      f <- f[win, drop=FALSE]
      win.out <- win
    } else {
      ## default - ignore 'win'
      win.out <- as.owin(f)
    }
    ## need to check simulated point coordinates?
    checkinside <- forcewin
    if(checkinside && is.rectangle(win) && is.subset.owin(Frame(f), win))
      checkinside <- FALSE
    ## prepare
    w <- as.mask(if(forcewin) f else win.out)
    M <- w$m
    dx <- w$xstep
    dy <- w$ystep
    halfdx <- dx/2.0
    halfdy <- dy/2.0
    ## extract pixel coordinates and probabilities
    rxy <- rasterxy.mask(w, drop=TRUE)
    xpix <- rxy$x
    ypix <- rxy$y
    npix <- length(xpix)
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
    return(result)
  }

 if(is.null(fmax)) {
    ## compute approx maximum value of f
    imag <- as.im(f, win, ...)
    summ <- summary(imag)
    fmax <- summ$max + 0.05 * diff(summ$range)
  }
  irregular <- (win$type != "rectangle")
  box <- boundingbox(win)

  result <- vector(mode="list", length=nsim)
  for(isim in seq_len(nsim)) {

    ## initialise empty pattern
    X <- ppp(numeric(0), numeric(0), window=win)
  
    pbar <- 1
    nremaining <- n
    totngen <- 0
    
    ## generate uniform random points in batches
    ## and apply the rejection method.
    ## Collect any points that are retained in X

    ntries <- 0
    repeat{
      ntries <- ntries + 1
      ## proposal points
      ngen <- nremaining/pbar + 10
      totngen <- totngen + ngen
      prop <- runifrect(ngen, box)
      if(irregular)
        prop <- prop[win]
      if(prop$n > 0) {
        fvalues <- f(prop$x, prop$y, ...)
        paccept <- fvalues/fmax
        u <- runif(prop$n)
        ## accepted points
        Y <- prop[u < paccept]
        if(Y$n > 0) {
          ## add to X
          X <- superimpose(X, Y, W=win, check=FALSE)
          nX <- X$n
          pbar <- nX/totngen
          nremaining <- n - nX
          if(nremaining <= 0) {
            ## we have enough!
            if(verbose)
              splat("acceptance rate = ", round(100 * pbar, 2), "%")
            result[[isim]] <- if(nX == n) X else X[1:n]
            break
          }
        }
      }
      if(ntries > giveup)
        stop(paste("Gave up after",giveup * n,"trials with",
                   X$n, "points accepted"))
    }
  }
  result <- simulationresult(result, nsim, drop)
  return(result)
}
