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
image(z)
```
