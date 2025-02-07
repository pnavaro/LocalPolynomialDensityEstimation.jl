export PlanarPointPattern


struct PlanarPointPattern

    points::Vector{PlanarPoint}
    window::ObservationWindow

    function PlanarPointPattern(npoints)

        new(
            [PlanarPoint(rand(), rand()) for i = 1:npoints],
            ObservationWindow((0, 1), (0, 1)),
        )

    end

    function PlanarPointPattern(rng::AbstractRNG, npoints)

        new(
            [PlanarPoint(rand(rng, 2)...) for i = 1:npoints],
            ObservationWindow((0, 1), (0, 1)),
        )

    end

    function PlanarPointPattern(points, w)

        new(points, w)

    end

    function PlanarPointPattern(x::Real, y::Real, w::ObservationWindow)

        new([PlanarPoint(x, y)], w)

    end

    function PlanarPointPattern(x::AbstractVector, y::AbstractVector, w::ObservationWindow)

        new(PlanarPoint.(x, y), w)

    end

    function PlanarPointPattern(
        n::Int,
        f::Function,
        w::ObservationWindow;
        fmax = 1.0,
        verbose = false,
    )
        pbar = 1
        nremaining = n
        totngen = 0
        ntries = 0
        isim = 1
        X = Vector{PlanarPoint}[]
        while true
            ntries += 1
            ngen = nremaining ÷ pbar + 10
            totngen += ngen
            prop = [PlanarPoint(rand(2)...) for i = 1:ngen]
            if length(n) > 0
                fvalues = [f(p.x, p.y) for p in prop]
                paccept = fvalues / fmax
                u = rand(length(prop))
                Y = prop[u.<paccept]
                if length(Y) > 0
                    push!(X, [p for p in Y if inside(p, w)])
                    nX = length(X)
                    pbar = nX / totngen
                    nremaining = n - nX
                    if nremaining <= 0
                        verbose &&
                            println("acceptance rate = $(round(100 * pbar, digits=2)) %")
                        return new(X[1:n], w)
                    end
                end
            end
        end
    end

    function PlanarPointPattern(image::PixelImage, window::ObservationWindow)

        xp = repeat(image.xcol, outer = length(image.yrow))
        yp = repeat(image.yrow, inner = length(image.xcol))
        points = [
            PlanarPoint(x, y) for (x, y) in zip(xp, yp) if inside(PlanarPoint(x, y), window)
        ]

        new(points, window)

    end

end


@recipe function f(ppp::PlanarPointPattern)

    @series begin

        x := [p.x for p in ppp.points]
        y := [p.y for p in ppp.points]
        seriestype := :scatter
        legend := false
        ()
    end

    @series ppp.window

end

npoints(ppp::PlanarPointPattern) = length(ppp.points)

export nncross

function nncross(pattern1, pattern2)

    data1 = stack((p.x, p.y) for p in ppp1.points)
    data2 = stack((p.x, p.y) for p in ppp2.points)
    tree = KDTree(data1)
    idxs, dists = nn(tree, data2)
    data1[:, idxs]

end

export subset

function subset(ppp::PlanarPointPattern, window::ObservationWindow)

    PlanarPointPattern([p for p in ppp1.points if inside(p, w)], w)

end
