# ---
# jupyter:
#   jupytext:
#     cell_metadata_filter: -all
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.4
#   kernelspec:
#     display_name: Julia 1.11.0
#     language: julia
#     name: julia-1.11
# ---

using LocalPolynomialDensityEstimation
using Plots


# Define a polygon
polygon = [
	PlanarPoint(186, 14),
	PlanarPoint(186, 44),
	PlanarPoint(175, 115),
	PlanarPoint(175, 85)
]

x=(0.5,1,0.5,0) 
y=(0,1,2,1) 

poly = [PlanarPoint(i,j) for (i,j) in zip(x,y)]

plot(poly)

w = ObservationWindow( x, y)

w.boundary

plot(w)


