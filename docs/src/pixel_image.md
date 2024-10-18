```@meta
CurrentModule = LocalPolynomialDensityEstimation
```

# Pixel Image

The type `PixelImage` contains a rectangular grid that occupies a
rectangular window in the spatial coordinate system. The pixel
values are real numbers.

The matrix `mat` contains the evaluation of the polynomial `f` on the
grid of pixels. Note carefully that the entry mat[i,j] gives the
pixel value at the location (xcol[j],yrow[i]). 

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
mat = rand(30, 40)
img = PixelImage(mat, (0,1), (0,1))

contourf(img)
```

```@example image
rng = Xoshiro(43)
s = RandomShape(rng; rad = 0.2, edgy = 0.1)
plot(s)
```

```@example image
mat = zeros(40, 60)
z = PixelImage(mat, (0,1), (0,1))

plot(PlanarPointPattern(z, s))
```

