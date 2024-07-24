using TypedPolynomials

export ObservationWindow


"""
$(TYPEDEF)

$(FIELDS)
"""
struct ObservationWindow

    "Polygonal boundary of window"
    boundary::Vector{Point}

    function ObservationWindow(x, y)

        if length(x) == length(y) == 2

            boundary = [
                Point(x[1], y[1]),
                Point(x[2], y[1]),
                Point(x[2], y[2]),
                Point(x[1], y[2]),
                Point(x[1], y[1]),
            ]

            new(boundary)

        else

            boundary = Point.(x, y)

            if first(boundary) == last(boundary)
                new(boundary)
            else
                new(vcat(boundary, first(boundary)))
            end

        end

    end

    function ObservationWindow(boundary)

        if first(boundary) == last(boundary)
            new(boundary)
        else
            new(vcat(boundary, first(boundary)))
        end

    end

end

function integral(f::AbstractPolynomialLike, w::ObservationWindow)

    @polyvar x y

    s = sum(f(x => px, y => py) for px in z.x, py in z.y if inside(Point(px, py), w))

    return s * z.dx * z.dy

end

@recipe function f(w::ObservationWindow)

    x := [p.x for p in w.boundary]
    y := [p.y for p in w.boundary]
    legend := false
    ()

end
