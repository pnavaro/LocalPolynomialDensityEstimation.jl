module LocalPolynomialDensityEstimation

using DocStringExtensions
import Statistics: mean

bernstein(n, k, t) = binomial(n, k) .* t .^ k .* (1 .- t) .^ (n - k)

function bezier(points, num)
    n = size(points,2)
    t = LinRange(0, 1, num)
    curve = zeros((2, num))
    for i = 1:n
        curve .+= bernstein(n - 1, i - 1, t)' .* points[:, i]
    end
    return curve
end



function segment(p1, p2, angle1, angle2, r; numpoints = 100)

    d = sqrt(sum((p2 .- p1) .^ 2))
    r = r * d
    p = zeros((2, 4))
    p[:, 1] .= p1
    p[:, 2] .= p1 .+ [r * cos(angle1), r * sin(angle1)]
    p[:, 3] .= p2 .+ [r * cos(angle2 + pi), r * sin(angle2 + pi)]
    p[:, 4] .= p2
    bezier(p, numpoints)

end

function get_curve(points, r)
    curve = Matrix{Float64}[]
    npoints = size(points, 2)
    for i = 1:(npoints-1)
        p1 = points[1:2,i]
        p2 = points[1:2, i+1]
        a1 = points[3, i]
        a2 = points[3, i+1]
        seg = segment(p1, p2, a1, a2, r)
        push!(curve, seg)
    end
    return hcat(curve...)
end


""" 
$(SIGNATURES)

given an array of points *a*, create a curve through those points. 

- `rad` is a number between 0 and 1 to steer the distance of control points.
- `edgy` is a parameter which controls how "edgy" the curve is,
           edgy=0 is smoothest.
"""
function get_bezier_curve(a, r, edgy)
    p = atan(edgy) / pi + 0.5
    a = ccw_sort(a)
    a = hcat(a, a[:, 1])
    d = diff(a, dims = 2)
    ang = atan.(d[2, :], d[1,:])
    f(ang) = (ang >= 0) * ang + (ang < 0) * (ang + 2pi)
    ang = f.(ang)
    ang1 = ang
    ang2 = circshift(ang, 1)
    ang = p .* ang1 .+ (1 - p) .* ang2 .+ (abs.(ang2 .- ang1) .> pi) .* pi
    push!(ang, ang[1])
    a = vcat(a, ang')
    c = get_curve(a, r)
    return c[1,:], c[2,:]
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
