export PlanarPointPattern


struct PlanarPointPattern

    points::Vector{PlanarPoint}
    window::ObservationWindow

    function PlanarPointPattern(npoints)

        new([PlanarPoint(rand(), rand()) for i = 1:npoints], ObservationWindow((0, 1), (0, 1)))

    end

    function PlanarPointPattern(rng::AbstractRNG, npoints)

        new([PlanarPoint(rand(rng, 2)...) for i = 1:npoints], ObservationWindow((0, 1), (0, 1)))

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
                    X = vcat(X, [p for p in Y if inside(p, w)])
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

end


@recipe function f(ppp::PlanarPointPattern)

    @series begin

        x := [p.x for p in ppp.points]
        y := [p.y for p in ppp.points]
        seriestype := :scatter
        legend := false
        markerstrokewidth := 0
        ()
    end

    @series ppp.window

end

npoints(ppp::PlanarPointPattern) = length(ppp.points)

export density_ppp

function density_cic( ppp )

    IMG_SIZE = 128
    w = ppp.window
    xmin, xmax = extrema(p.x for p in w.boundary)
    ymin, ymax = extrema(p.y for p in w.boundary)

    dx = (xmax - xmin) / (IMG_SIZE-1)
    dy = (ymax - ymin) / (IMG_SIZE-1)

    ρ = zeros(IMG_SIZE, IMG_SIZE)

    for i in eachindex(ppp.points)

        p = ppp.points[i]

        xp = (p.x - xmin) / dx
        yp = (p.y - ymin) / dy

        i = floor(Int, xp) + 1
        j = floor(Int, yp) + 1

        dxp = xp - i + 1
        dyp = yp - j + 1

        a1 = (1 - dxp) * (1 - dyp)
        a2 = dxp * (1 - dyp)
        a3 = dxp * dyp
        a4 = (1 - dxp) * dyp

        ρ[i,   j] += a1 
        ρ[i+1, j] += a2
        ρ[i+1, j+1] += a3
        ρ[i,   j+1] += a4
        
    end

    return ρ

end
