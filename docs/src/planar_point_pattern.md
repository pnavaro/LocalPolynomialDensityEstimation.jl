# Planar Point Pattern


```@example ppp
using Plots
using RCall

R"library(spatstat.geom)"
R"library(spatstat.random)"
# +
R"X <- rpoint(100, function(x,y) { x^2 + y^2}, 1)"

X = @rget X
scatter(X[:x], X[:y])
```

```@example ppp
using LocalPolynomialDensityEstimation

f = (x, y) ->  x^2 + y^2
n = 100

w = ObservationWindow((0.1,0.9), (0.2,0.8))
ppp = PlanarPointPattern(n, f, w)

plot(ppp, xlims=(0,1), ylims=(0,1))
```


