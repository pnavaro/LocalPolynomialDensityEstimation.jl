export Image

struct Image

    f :: AbstractPolynomialLike
    x :: Vector{Float64}
    y :: Vector{Float64}
    dx :: Float64
    dy :: Float64

    function Image( f :: AbstractPolynomialLike, xrange, yrange )

        dx = (xrange[2] - xrange[1]) / IMG_SIZE
        dy = (yrange[2] - yrange[1]) / IMG_SIZE

        x  = LinRange(xrange[1], xrange[2], IMG_SIZE+1)[1:end-1] .+ 0.5dx
        y  = LinRange(yrange[1], yrange[2], IMG_SIZE+1)[1:end-1] .+ 0.5dy

        new( f, x, y, dx, dy )

    end

end

function Image( f :: AbstractPolynomial, w :: Window )

    xrange = extrema( p.x for p in w.bounday )
    yrange = extrema( p.y for p in w.bounday )

    Image( f, xrange, yrange )

end


export integral

function integral( z :: Image) 

    @polyvar x y

    s = sum(z.f(x => px, y => py) for px in z.x, py in z.y)

    return s * z.dx * z.dy

end


Base.:(*)(u::Image, v::Image) = Image( u.f * v.f, u.w )

Base.:(-)(u::Image, v::Image) = Image( u.f - v.f, u.w )

Base.:(*)(u::Image, v::Float64) = Image( u.f * v, u.w )
