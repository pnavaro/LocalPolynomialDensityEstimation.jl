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
                new(vcat(boundary,first(boundary)))
            end

        end

    end

    function Window( boundary )

       if first(boundary) == last(boundary)
           new( boundary )
       else
           new(vcat(boundary,first(boundary)))
       end
    end

end

export Image

struct Image

    f :: Function
    x :: Vector{Float64}
    y :: Vector{Float64}
    dx :: Float64
    dy :: Float64

    function Image( f, xrange, yrange )

        dx = (xrange[2] - xrange[1]) / IMG_SIZE
        dy = (yrange[2] - yrange[1]) / IMG_SIZE

        x  = LinRange(xrange[1], xrange[2], IMG_SIZE+1)[1:end-1] .+ 0.5dx
        y  = LinRange(yrange[1], yrange[2], IMG_SIZE+1)[1:end-1] .+ 0.5dy

        new( f, x, y, dx, dy )

    end

end

export integral

function integral( z :: Image) 

    s = sum(z.f(px, py) for px in z.x, py in z.y)

    return s * z.dx * z.dy

end

function integral( z :: Image, w :: Window )

    s = sum(z.f(px, py) for px in z.x, py in z.y if inshape(Point(px,py), w.boundary))

    return s * z.dx * z.dy

end

