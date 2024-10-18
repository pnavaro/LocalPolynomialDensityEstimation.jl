"""
$(SIGNATURES)

Bivariate kernel density/intensity estimation

Provides an isotropic adaptive or fixed bandwidth kernel density
estimate of a PlanarPpointPattern.

 
Given a data set ``x_1,\\dots,x_n`` in 2D, the isotropic kernel estimate of
its probability density function, 

```math
\\hat{f}(y)=n^{-1}\\sum_{i=1}^{n}h(x_i)^{-2}K((y-x_i)/h(x_i))
```

where ``h(x)`` is the bandwidth function, and ``K(.)`` is the
bivariate standard normal smoothing kernel. 

- `ppp` : `PlanarPointPattern` giving the observed 2D data set to be smoothed.
- `h0` : Global bandwidth for adaptive smoothing or fixed bandwidth for constant smoothing. A numeric value > 0.

returns a BivariateKDE object `B` contains gridded coordinates (`B.x` and `B.y`) and the bivariate density estimate (`B.density`).

"""
function bivariate_density(ppp :: PlanarPointPattern, h0 :: Real)
 
    w = ObservationWindow(ppp)

    xdata = [p.x for p in ppp.points]
    ydata = [p.y for p in ppp.points]

    KernelDensity.kde((xdata, ydata); bandwidth = (h0, h0))


end
