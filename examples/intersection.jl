# -*- coding: utf-8 -*-
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

# Defining maximum number of points in polygon
const MAX_POINTS = 20

"""
Function to return x-value of point of intersection of two lines
"""
function x_intersect(p1, p2, p3, p4)
    num = (p1.x*p2.y - p1.y*p2.x) * (p2.x-p4.x) - (p1.x-p2.x) * (p3.x*p4.y - p3.y*p4.x)
    den = (p1.x-p2.x) * (p3.y-p4.y) - (p1.y-p2.y) * (p3.x-p4.x)
    return num/den
end

"""
Function to return y-value of point of intersection of two lines
"""
function y_intersect(p1, p2, p3, p4)
    num = (p1.x*p2.y - p1.y*p2.x) * (p3.y-p4.y) - (p1.y-p2.y) * (p3.x*p4.y - p3.y*p4.x)
    den = (p1.x-p2.x) * (p3.y-p4.y) - (p1.y-p2.y) * (p3.x-p4.x)
    return num/den
end

"""
Function to clip all the edges w.r.t one clip edge of clipping area
"""
function clip(poly_points, poly_size, p1::PlanarPoint, p2::PlanarPoint)
    
    new_points = PlanarPoint[]
    new_poly_size = 0

    # (ix,iy),(kx,ky) are the co-ordinate values of the points
    for i in eachindex(poly_points)
        # i and k form a line in polygon
        k = mod1((i+1),poly_size)
        pj = poly_points[i]
        pk = poly_points[k]

        # Calculating position of first point w.r.t. clipper line
        i_pos = (p2.x-p1.x) * (pj.y-p1.y) - (p2.y-p1.y) * (pj.x-p1.x)

        # Calculating position of second point w.r.t. clipper line
        k_pos = (p2.x-p1.x) * (pk.y-p1.y) - (p2.y-p1.y) * (pk.x-p1.x)

        
        if i_pos < 0 && k_pos < 0 # Case 1 : When both points are inside
            # Only second point is added
            push!(new_points, pk)
            new_poly_size += 1
        elseif i_pos >= 0 && k_pos < 0 # Case 2: When only first point is outside
            # Point of intersection with edge and the second point is added
            push!(new_points, PlanarPoint(x_intersect(p1, p2, pj, pk), y_intersect(p1, p2, pj, pk)))
            new_poly_size += 1
            push!(new_points, pk)
            new_poly_size += 1
        elseif i_pos < 0 && k_pos >= 0 # Case 3: When only second point is outside
            # Only point of intersection with edge is added
            push!(new_points, PlanarPoint(x_intersect(p1, p2, pj, pk),y_intersect(p1, p2, pj, pk)))
            new_poly_size += 1
        else # Case 4: When both points are outside
            continue  # No points are added
        end
        
    end

    return new_points, new_poly_size
end

# +
"""
Function to implement Sutherland–Hodgman algorithm
"""
function sutherland_hodgman(poly_points, poly_size, clipper_points, clipper_size)
    # i and k are two consecutive indexes
    for i in 1:clipper_size
        k = mod1((i+1), clipper_size)

        # We pass the current array of vertices, it's size and the end points of the selected clipper line
        poly_points, poly_size = clip(poly_points, poly_size, clipper_points[i], clipper_points[k])
    end

    # Printing vertices of clipped polygon
    return poly_points
    
end
# -

# # Driver code
#
# Defining polygon vertices in clockwise order

poly_size = 3
poly_points = [PlanarPoint(100,150), PlanarPoint(200,250), PlanarPoint(300,200)]
plot(poly_points)

# Defining clipper polygon vertices in clockwise order
# 1st Example with square clipper

clipper_size = 4
clipper_points = [PlanarPoint(150,150), PlanarPoint(150,200), PlanarPoint(200,200), PlanarPoint(200,150)]
plot!(clipper_points)

# +
# 2nd Example with triangle clipper
# clipper_size = 3
# clipper_points = np.array([[100,300], [300,300], [200,100]])

# Calling the clipping function
plot!(sutherland_hodgman(poly_points, poly_size, clipper_points, clipper_size))
# -


