using TypedPolynomials

export Window

const IMG_SIZE = 128

struct Window

    boundary :: Vector{Point}

    function Window( x,  y)

        if length(x) == length(y) == 2

            boundary = [Point(x[1], y[1]), 
                        Point(x[2], y[1]),
                        Point(x[2], y[2]),
                        Point(x[1], y[2]),
                        Point(x[1], y[1])]

            new( boundary )

        else

            boundary = [Point(i,j) for (i,j) in zip(x,y)]

            if first(boundary) == last(boundary)
                new( boundary )
            else
                new( vcat(boundary,first(boundary)))
            end

        end

    end

    function Window( boundary )

       if first(boundary) == last(boundary)
           new( boundary )
       else
           new( vcat(boundary,first(boundary)))
       end
    end

end

function integral( poly :: AbstractPolynomialLike, w :: Window )

    @polyvar x y

    s = sum(poly(x => px, y => py) for px in z.x, py in z.y if inside(Point(px,py), w))

    return s * z.dx * z.dy

end

function integral( z :: Image, w :: Window )

    @polyvar x y

    s = sum(z.f(x => px, y => py) for px in z.x, py in z.y if inside(Point(px,py), w))

    return s * z.dx * z.dy

end

function Image( f :: AbstractPolynomial, w :: Window )

    xrange = extrema( p.x for p in w.bounday )
    yrange = extrema( p.y for p in w.bounday )

    Image( f, xrange, yrange )

end

@recipe function f(w::Window)

    x := [p.x for p in w.boundary]
    y := [p.y for p in w.boundary]
    legend := false
    ()
 
end
