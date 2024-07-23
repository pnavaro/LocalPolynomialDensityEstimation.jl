```@meta
CurrentModule = LocalPolynomialDensityEstimation
```

# Pixel Image

```@docs
PixelImage
```

```@example image
using LocalPolynomialDensityEstimation
using Plots
using TypedPolynomials

@polyvar x y

f = 3x^2 + 2y

z = PixelImage(f, (0,1), (0,1))

integral(z)
```


```@example image
image(z)
```
