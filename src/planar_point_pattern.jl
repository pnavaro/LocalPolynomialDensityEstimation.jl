export PlanarPointPattern


struct PlanarPointPattern

    points :: Vector{Point}
    window :: ObservationWindow

    function PlanarPointPattern( npoints )

        new( [Point(rand(),rand()) for i in 1:npoints], ObservationWindow((0,1), (0,1)))    

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
