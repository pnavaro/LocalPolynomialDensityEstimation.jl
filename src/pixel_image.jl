export PixelImage

const IMG_SIZE = 128

"""
$(TYPEDEF)

- `mat` : matrix or vector containing the pixel values of the image.
- `xcol` :	vector of x coordinates for the pixel grid
- `yrow` :	vector of y coordinates for the pixel grid
"""
struct PixelImage

    f::AbstractPolynomialLike
    mat::Matrix{Float64}
    xcol::Vector{Float64}
    yrow::Vector{Float64}
    dx::Float64
    dy::Float64

    function PixelImage(f::AbstractPolynomialLike, xrange, yrange)

        dx = (xrange[2] - xrange[1]) / IMG_SIZE
        dy = (yrange[2] - yrange[1]) / IMG_SIZE

        xcol = [(i - 0.5) * dx for i = 1:IMG_SIZE]
        yrow = [(j - 0.5) * dy for j = 1:IMG_SIZE]

        @polyvar x y
        mat = [f(x => px, y => py) for px in xcol, py in yrow]

        new(f, mat, xcol, yrow, dx, dy)

    end

    function PixelImage(f::AbstractPolynomialLike, w::ObservationWindow)

        xrange = extrema(p.x for p in w.boundary)
        yrange = extrema(p.y for p in w.boundary)

        dx = (xrange[2] - xrange[1]) / IMG_SIZE
        dy = (yrange[2] - yrange[1]) / IMG_SIZE

        xcol = [(i - 0.5) * dx for i = 1:IMG_SIZE]
        yrow = [(j - 0.5) * dy for j = 1:IMG_SIZE]

        @polyvar x y

        mat = zeros(IMG_SIZE, IMG_SIZE)
        for j in eachindex(xcol), i in eachindex(yrow)
            px = xcol[j]
            py = yrow[i]
            if inside(px, py, w.boundary)
                mat[i, j] = f(x => px, y => py)
            end
        end

        new(f, mat, xcol, yrow, dx, dy)

    end

    function PixelImage(mat, xrange, yrange)

        nrow, ncol = size(mat)


        dx = (xrange[2] - xrange[1]) / ncol
        dy = (yrange[2] - yrange[1]) / nrow

        xcol = [(i - 0.5) * dx for i = 1:ncol]
        yrow = [(j - 0.5) * dy for j = 1:nrow]

        @polyvar x y
        f = 0 * x + 0 * y

        new(f, mat, xcol, yrow, dx, dy)

    end

    function PixelImage( w::ObservationWindow )

        nrow, ncol = IMG_SIZE, IMG_SIZE

        xrange = extrema(p.x for p in w.boundary)
        yrange = extrema(p.y for p in w.boundary)

        mat = zeros(nrow,ncol)

        dx = (xrange[2] - xrange[1]) / ncol
        dy = (yrange[2] - yrange[1]) / nrow

        xcol = [(i - 0.5) * dx for i = 1:ncol]
        yrow = [(j - 0.5) * dy for j = 1:nrow]

        @polyvar x y
        f = 0 * x + 0 * y

        new(f, mat, xcol, yrow, dx, dy)

    end


end

export integral

integral(z::PixelImage) = sum(z.mat) * z.dx * z.dy

Base.:(*)(u::PixelImage, v::PixelImage) = PixelImage(u.f * v.f, u.w)

Base.:(-)(u::PixelImage, v::PixelImage) = PixelImage(u.f - v.f, u.w)

Base.:(*)(u::PixelImage, v::Float64) = PixelImage(u.f * v, u.w)


function integral(z::PixelImage, w::ObservationWindow)

    s = sum(
        z.mat[i, j] for
        i = 1:IMG_SIZE, j = 1:IMG_SIZE if inside(PlanarPoint(z.xcol[j], z.yrow[i]), w)
    )

    return s * z.dx * z.dy

end

ObservationWindow(z::PixelImage) = ObservationWindow(z.xcol, z.yrow)

@recipe function f(z::PixelImage)

    @series z.xcol, z.yrow, z.mat

end


#=

export image

function image(z)

    @polyvar x y

    v = zeros(Float64, (IMG_SIZE, IMG_SIZE))
    for i = 1:IMG_SIZE, j = 1:IMG_SIZE
        px = z.x[i]
        py = z.y[j]
        v[j, i] = z.f(x => px, y => py)
    end

    vmin, vmax = extrema(v)
    cmap = convert(Vector{RGB{N0f8}}, colormap("RdBu", 100))

    return cmap[UInt8.(round.((v .- vmin) ./ vmax .* 99) .+ 1)]

end

function image(z, w)

    @polyvar x y

    v = zeros(Float64, (IMG_SIZE, IMG_SIZE))
    for i = 1:IMG_SIZE, j = 1:IMG_SIZE
        px = z.x[i]
        py = z.y[j]
        if inside(Point(px, py), w.boundary)
            v[j, i] = z.f(x => px, y => py)
        end
    end

    vmin, vmax = extrema(v)
    cmap = convert(Vector{RGB{N0f8}}, colormap("RdBu", 100))

    return cmap[UInt8.(round.((v .- vmin) ./ vmax .* 99) .+ 1)]

end

=#
