export PixelImage

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
