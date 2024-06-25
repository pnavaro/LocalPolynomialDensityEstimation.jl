module LocalPolynomialDensityEstimation

using DocStringExtensions
import Statistics: mean

atleast_2d(a) = fill(a, 1, 1)
atleast_2d(a::AbstractArray) = ndims(a) == 1 ? reshape(a, :, 1) : a

bernstein(n, k, t) = binomial(n, k) .* t .^ k .* (1 .- t) .^ (n - k)

function bezier(points; num = 200)
    N = length(points)
    t = LinRange(0, 1, num)
    curve = zeros((2, num))
    for i = 1:N
        curve += bernstein(N - 1, i - 1, t)' .* points[:, i]
    end
    return curve
end



struct Segment

    function Segment(p1, p2, angle1, angle2; r = 0.3, numpoints = 100)
        d = sqrt(sum((p2 .- p1) .^ 2))
        r = r * d
        p = zeros((2, 4))
        p[:, 1] .= p1
        p[:, 2] .= p1 .+ [r * cos(angle1), r * sin(angle1)]
        p[:, 3] .= p2 .+ [r * cos(angle2 + pi), r * sin(angle2 + pi)]
        p[:, 4] .= p2
        curve = bezier(s.p, s.numpoints)

        new(p, points, curve)

    end

end

function get_curve(points)
    segments = Segment[]
    for i = 1:(length(points)-1)
        seg = Segment(points[i, :2], points[i+1, :2], points[i, 2], points[i+1, 2])
        push!(segments, seg)
    end
    curve = vcat([s.curve for s in segments])
    return segments, curve
end


""" 
$(SIGNATURES)

given an array of points *a*, create a curve through those points. 

- `rad` is a number between 0 and 1 to steer the distance of control points.
- `edgy` is a parameter which controls how "edgy" the curve is,
           edgy=0 is smoothest.
"""
function get_bezier_curve(a, rad = 0.2, edgy = 0)
    p = arctan(edgy) / pi + 0.5
    a = ccw_sort(a)
    push!(a, atleast_2d(a[:, 1]), dims = 2)
    d = diff(a, dims = 2)
    ang = atan(d[:, 2], d[:, 1])
    f(ang) = (ang >= 0) * ang + (ang < 0) * (ang + 2pi)
    ang = f(ang)
    ang1 = ang
    ang2 = circshift(ang, 1)
    @show ang = p * ang1 + (1 - p) * ang2 + (abs(ang2 - ang1) > pi) * pi
    push!(ang, [ang[1]])
    a .= hcat(a, atleast_2d(ang)')
    s, c = get_curve(a, r = rad)
    x, y = c'
    return x, y, a
end

function ccw_sort(p)
    d = p .- mean(p, dims = 2)
    s = atan.(d[1, :], d[2, :])
    return p[:, sortperm(s)]
end

""" 
$(SIGNATURES)

create n random points in the unit square, which are *mindst*
apart, then scale them.
"""
function get_random_points(n, scale; mindst = nothing, rec = 0)
    mindst = isnothing(mindst) ? 0.7 / n : mindst
    a = rand(2, n)
    da = diff(ccw_sort(a), dims = 2)
    d = sqrt.(sum(da, dims = 1) .^ 2)
    if all(d .>= mindst) || rec >= 200
        return a * scale
    else
        return get_random_points(n, scale; mindst = mindst, rec = rec + 1)
    end
end



end
