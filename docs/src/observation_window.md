# Observation window

```@docs
ObservationWindow
```

Create an observation window using `xrange`and `yrange` the coordinate limits of enclosing box.

```@example owin
using LocalPolynomialDensityEstimation
using Plots

w = ObservationWindow((0.2,0.8), (0.4,0.7))
plot(w; xlims=(0,1), ylims=(0,1))
```

Create an observation window using a polygonal boundary defined by the coordinates of its points.
Vectors `x`and `y`  must have same size and greater than 2.

```@example owin
w = ObservationWindow((0.5,1,0.5,0) , (0,1,2,1))

plot(w)
```

You can define a polygonal boundary with a vector of `Point`

```@example owin
polygon = [
	PlanarPoint(186, 14),
	PlanarPoint(186, 44),
	PlanarPoint(175, 115),
	PlanarPoint(175, 85)
]

plot(polygon)
```

or using coordinates `x` and `y`

```@example owin
x=(0.5,1,0.5,0)
y=(0,1,2,1)

poly = [PlanarPoint(i,j) for (i,j) in zip(x,y)]

plot(poly)
```

```@example owin
w = ObservationWindow( poly )

plot(w)
```

```@docs
inside
```
