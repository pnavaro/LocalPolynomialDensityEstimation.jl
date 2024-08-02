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

using LocalPolynomialDensityEstimation
using Plots

# # Driver code
#
# - Defining polygon vertices in clockwise order
# - Defining clipper polygon vertices in clockwise order
# - 1st Example with square clipper
#

poly_points = [PlanarPoint(100,150), PlanarPoint(200,250), PlanarPoint(300,200)]
w1 = ObservationWindow(poly_points)
clipper_points = [PlanarPoint(150,150), PlanarPoint(150,200), PlanarPoint(200,200), PlanarPoint(200,150)]
w2 = ObservationWindow(clipper_points)
plot(w1)
plot!(w2)
plot!(intersect(w1, w2))

orientation(poly_points)

orientation(clipper_points)

plot!(clipper_points)
plot!(sutherland_hodgman(poly_points, poly_size, clipper_points, clipper_size), lw=2, m=:o)

# # 2nd Example with triangle clipper

poly_size = 3
poly_points = [PlanarPoint(100,150), PlanarPoint(200,250), PlanarPoint(300,200)]
clipper_size = 3
clipper_points = [PlanarPoint(100,300), PlanarPoint(300,300), PlanarPoint(200,100)]
plot(poly_points)
plot!(clipper_points)
plot!(sutherland_hodgman(poly_points, poly_size, clipper_points, clipper_size), lw=2, m=:o)

# +

orientation(clipper_points)
# -

orientation(poly_points)


