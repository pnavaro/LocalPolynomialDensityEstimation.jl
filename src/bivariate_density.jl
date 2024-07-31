export bivariate_density

"""
$(SIGNATURES)

Bivariate kernel density/intensity estimation

Provides an isotropic adaptive or fixed bandwidth kernel density
estimate of a PlanarPpointPattern.

 
Given a data set ``x_1,\dots,x_n`` in 2D, the isotropic kernel estimate of
its probability density function, 

```math
\hat{f}(y)=n^{-1}\sum_{i=1}^{n}h(x_i)^{-2}K((y-x_i)/h(x_i))
```

where ``h(x)`` is the bandwidth function, and ``K(.)`` is the
bivariate standard normal smoothing kernel. 

- `ppp` : `PlanarPointPattern` giving the observed 2D data set to be smoothed.
- `h0` : Global bandwidth for adaptive smoothing or fixed bandwidth for constant smoothing. A numeric value > 0.

"""
function bivariate_density(pp, h0; verbose=true)
 
hp=NULL
adapt=FALSE
resolution=128
gamma.scale="geometric"
edge=c("uniform","diggle","none")
weights=NULL
intensity=FALSE
trim=5
xy=NULL
pilot.density=NULL
leaveoneout=FALSE
parallelise=NULL
davies.baddeley=NULL

W = ObservationWindow(pp)

dimyx = (resolution,resolution)

n = npoints(pp)
	
h.spec <- rep(h0,n)
h.hypo <- NULL
gs <- gamma <- NA
    
dens <- density.ppp(pp,sigma=h0,dimyx=dimyx,xy=xy,edge=(edge=="diggle"||edge=="uniform"),diggle=(edge=="diggle"),weights=weights,spill=1)
surf <- dens$raw[W,drop=FALSE]
ef <- dens$edg[W,drop=FALSE]
ef[ef>1] <- 1
		
surf <- surf/ef
surf[surf<0] <- 0
	
if(!intensity) surf <- surf/spatstat.univar::integral(surf)

surf


end
