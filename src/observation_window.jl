function orientation(p::Vector{PlanarPoint})
    n = length(p)
    sum(signarea(p[1], p[i], p[i+1]) for i = 2:(n-1))
end

export ObservationWindow

"""
$(TYPEDEF)

$(FIELDS)
"""
struct ObservationWindow

    "Polygonal boundary of window"
    boundary::Vector{PlanarPoint}

    function ObservationWindow(x, y)

        if length(x) == length(y) == 2

            boundary = [
                PlanarPoint(x[1], y[1]),
                PlanarPoint(x[2], y[1]),
                PlanarPoint(x[2], y[2]),
                PlanarPoint(x[1], y[2]),
                PlanarPoint(x[1], y[1]),
            ]

            orientation(boundary) > 0.0 && reverse!(boundary)

            new(boundary)

        else

            boundary = [PlanarPoint(px, py) for (px, py) in zip(x, y)]

            orientation(boundary) > 0.0 && reverse!(boundary)

            if first(boundary) == last(boundary)
                new(boundary)
            else
                new(vcat(boundary, first(boundary)))
            end

        end

    end

    function ObservationWindow(boundary)

        orientation(boundary) > 0.0 && reverse!(boundary)

        if first(boundary) == last(boundary)
            new(boundary)
        else
            new(vcat(boundary, first(boundary)))
        end

    end

end

export boundary

function boundary(w::ObservationWindow)

    xlo = minimum(p.x for p in w.boundary)
    xhi = maximum(p.x for p in w.boundary)
    ylo = minimum(p.y for p in w.boundary)
    yhi = maximum(p.y for p in w.boundary)

    ((xlo, xhi), (ylo, yhi))

end

@recipe function f(w::ObservationWindow)

    x := [p.x for p in w.boundary]
    y := [p.y for p in w.boundary]
    legend := false
    ()

end

function signarea(p1::PlanarPoint, p2::PlanarPoint, p3::PlanarPoint)
    ((p2.x - p1.x) * (p3.y - p1.y) - (p3.x - p1.x) * (p2.y - p1.y)) / 2
end


function x_intersect(p1, p2, p3, p4)
    num =
        (p1.x * p2.y - p1.y * p2.x) * (p3.x - p4.x) -
        (p1.x - p2.x) * (p3.x * p4.y - p3.y * p4.x)
    den = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
    return num / den
end

function y_intersect(p1, p2, p3, p4)
    num =
        (p1.x * p2.y - p1.y * p2.x) * (p3.y - p4.y) -
        (p1.y - p2.y) * (p3.x * p4.y - p3.y * p4.x)
    den = (p1.x - p2.x) * (p3.y - p4.y) - (p1.y - p2.y) * (p3.x - p4.x)
    return num / den
end

function clip(poly_points, p1::PlanarPoint, p2::PlanarPoint)

    new_points = PlanarPoint[]
    poly_size = length(poly_points)

    for i in eachindex(poly_points)

        k = mod1((i + 1), poly_size)
        pj = poly_points[i]
        pk = poly_points[k]

        i_pos = (p2.x - p1.x) * (pj.y - p1.y) - (p2.y - p1.y) * (pj.x - p1.x)

        k_pos = (p2.x - p1.x) * (pk.y - p1.y) - (p2.y - p1.y) * (pk.x - p1.x)

        if i_pos < 0 && k_pos < 0
            push!(new_points, pk)
        elseif i_pos >= 0 && k_pos < 0
            push!(
                new_points,
                PlanarPoint(x_intersect(p1, p2, pj, pk), y_intersect(p1, p2, pj, pk)),
            )
            push!(new_points, pk)
        elseif i_pos < 0 && k_pos >= 0
            push!(
                new_points,
                PlanarPoint(x_intersect(p1, p2, pj, pk), y_intersect(p1, p2, pj, pk)),
            )
        else
            continue
        end

    end

    return new_points
end

function sutherland_hodgman(poly_points, clipper_points)

    poly_size = length(poly_points)
    clipper_size = length(clipper_points)
    # i and k are two consecutive indexes
    for i = 1:clipper_size
        k = mod1((i + 1), clipper_size)
        # We pass the current array of vertices, it's size and the end points of the selected clipper line
        poly_points = clip(poly_points, clipper_points[i], clipper_points[k])
    end

    # Printing vertices of clipped polygon
    return poly_points

end

export intersect

function Base.intersect(w1::ObservationWindow, w2::ObservationWindow)

    # We assume that polygons orientation are clockwise

    poly_points = w1.boundary[1:end-1]
    clipper_points = w2.boundary[1:end-1]

    return ObservationWindow(sutherland_hodgman(poly_points, clipper_points))

end

function inside(x::AbstractVector, y::AbstractVector, owin::ObservationWindow)

    @assert length(x) == length(y)

    [inside(px, py, owin.boundary) for (px, py) in zip(x, y)]

end
