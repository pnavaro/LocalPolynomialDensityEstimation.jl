export PlanarPointPattern


struct PlanarPointPattern

    points::Vector{Point}
    window::ObservationWindow

    function PlanarPointPattern(npoints)

        new([Point(rand(), rand()) for i = 1:npoints], ObservationWindow((0, 1), (0, 1)))

    end

    function PlanarPointPattern(rng::AbstractRNG, npoints)

        new([Point(rand(rng, 2)...) for i = 1:npoints], ObservationWindow((0, 1), (0, 1)))

    end

    function PlanarPointPattern(points, w)

        new(points, w)

    end

    function PlanarPointPattern(n::Int, f::Function, w::ObservationWindow; 
                                fmax = 1.0, verbose = false)
        pbar = 1
        nremaining = n
        totngen = 0
        ntries = 0
        isim = 1
        X = Vector{Point}[]
        while true
            ntries += 1
            ngen = nremaining ÷ pbar + 10
            totngen += ngen
            prop = [Point(rand(2)...) for i = 1:ngen]
            if length(n) > 0
                fvalues = [f(p.x, p.y) for p in prop]
                paccept = fvalues / fmax
                u = rand(length(prop))
                Y = prop[ u .< paccept ]
                if length(Y) > 0
                    X = vcat(X, [p for p in Y if inside(p, w)])
                    nX = length(X)
                    pbar = nX / totngen
                    nremaining = n - nX
                    if nremaining <= 0
                        verbose && println("acceptance rate = $(round(100 * pbar, digits=2)) %")
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
