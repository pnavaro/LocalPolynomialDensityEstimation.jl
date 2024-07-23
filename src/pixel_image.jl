export PixelImage
using Colors, Images

const IMG_SIZE = 128

"""
$(TYPEDEF)
"""
struct PixelImage

    f :: AbstractPolynomialLike
    x :: Vector{Float64}
    y :: Vector{Float64}
    dx :: Float64
    dy :: Float64

    function PixelImage( f :: AbstractPolynomialLike, xrange, yrange )

        dx = (xrange[2] - xrange[1]) / IMG_SIZE
        dy = (yrange[2] - yrange[1]) / IMG_SIZE

        x  = LinRange(xrange[1], xrange[2], IMG_SIZE+1)[1:end-1] .+ 0.5dx
        y  = LinRange(yrange[1], yrange[2], IMG_SIZE+1)[1:end-1] .+ 0.5dy

        new( f, x, y, dx, dy )

    end

end

export integral

function integral( z :: PixelImage) 

    @polyvar x y

    s = sum(z.f(x => px, y => py) for px in z.x, py in z.y)

    return s * z.dx * z.dy

end


Base.:(*)(u::PixelImage, v::PixelImage) = PixelImage( u.f * v.f, u.w )

Base.:(-)(u::PixelImage, v::PixelImage) = PixelImage( u.f - v.f, u.w )

Base.:(*)(u::PixelImage, v::Float64) = PixelImage( u.f * v, u.w )


function integral( z :: PixelImage, w :: ObservationWindow )

    @polyvar x y

    s = sum(z.f(x => px, y => py) for px in z.x, py in z.y if inside(Point(px,py), w))

    return s * z.dx * z.dy

end

function PixelImage( f :: AbstractPolynomial, w :: ObservationWindow )

    xrange = extrema( p.x for p in w.boundary )
    yrange = extrema( p.y for p in w.boundary )

    PixelImage( f, xrange, yrange )

end

export image

function image(z)

    @polyvar x y

    v = zeros(Float64, (IMG_SIZE, IMG_SIZE))
    for i in 1:IMG_SIZE, j in 1:IMG_SIZE
        px = z.x[i]
        py = z.y[j]
        v[j, i] = z.f( x => px, y => py)
    end

    vmin = minimum(v)
    vmax = maximum(v)
    cmap = convert(Vector{RGB{N0f8}}, colormap("RdBu", 100))

    return  cmap[UInt8.(round.((v .- vmin) ./ vmax .* 99) .+ 1)]

end

function image(z, w)

    @polyvar x y

    v = zeros(Float64, (IMG_SIZE, IMG_SIZE))
    for i in 1:IMG_SIZE, j in 1:IMG_SIZE
        px = z.x[i]
        py = z.y[j]
        if inside(Point(px,py), w.boundary)
            v[j, i] = z.f( x => px, y => py)
        end
    end

    vmin = minimum(v)
    vmax = maximum(v)
    cmap = convert(Vector{RGB{N0f8}}, colormap("RdBu", 100))

    return  cmap[UInt8.(round.((v .- vmin) ./ vmax .* 99) .+ 1)]

end
