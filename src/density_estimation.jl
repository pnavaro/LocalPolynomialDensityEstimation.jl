function density_estimation(data, domain, at_points, resolution, bandwidth; degree = 3)

    x = at_points.x
    y = at_points.y

    H = owin((x - bandwidth, x + bandwidth), (y - bandwidth, y + bandwidth))

    neighborhood = intersect(H, domain)

    ortho_poly = orthonormal_polynomials(degree, W = neighborhood)

    datum = subset_ppp(data, subset = neighborhood)

    a = Float64[]

    for k in eachindex(ortho_poly)
        eta_k = ortho_poly[k]
        push!(a, sum(eta_k(datum)) / data.n)
    end

    loc_poly = reduce(+, map(a, ortho_poly))
    xy = nn_im_grid(x, y, ortho_poly[1], neighborhood)
    loc_poly(xy[1], xy[2])


end
