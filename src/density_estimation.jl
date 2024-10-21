export density_estimation

function grid_from_pixelimage( p :: PixelImage, w :: ObservationWindow) 
# 
#     points = PlanarPoinPattern(
#       x = rep(im$xcol, times = length(im$yrow)),
#       y = rep(im$yrow, each = length(im$xcol)),
#       window = spatstat.geom::as.owin(im),
#       check = FALSE
#     )
#     points_inside_owin(points, W)
# 
end
 
function nn_im_grid(x, y, p :: PixelImage, w :: ObservationWindow)
# 
#     v = PlanarPointPattern(x, y, w)
#     grid = grid_from_im(p, w)
#     n = nncross(v, grid).which
#     grid.x[n], grid.y[n]
# 
end


"""
$(SIGNATURES)

LocPoly Density estimation on complicated domains

- `data` : The data as a `PlanarPointPattern` object
- `domain` :  A window of class `ObservationWindow`
- `at_points` : The points
- `bandwidth` : The multivariate bandwidth as a named vector `(x=hx, y=hy)`
- `degree` : The degree of the local polynomial approximation

estimation of the density of the `data` (on `domain`) computed at `at_points`
"""
function density_estimation(
    data::PlanarPointPattern,
    domain::ObservationWindow,
    at_points,
    bandwidth;
    degree = 3,
)

    x = [p.x for p in at_points]
    y = [p.y for p in at_points]

    H = ObservationWindow((x - bandwidth, x + bandwidth), (y - bandwidth, y + bandwidth))

    neighborhood = intersect(H, domain)

    ortho_poly = orthonormal_polynomials(degree, W = neighborhood)

    datum = inside(data, neighborhood)

    a = Float64[]

    for k in eachindex(ortho_poly)
        eta_k = ortho_poly[k]
        push!(a, sum(eta_k(datum)) / data.n)
    end

    loc_poly = reduce(+, map(a, ortho_poly))
    xy = nn_im_grid(x, y, ortho_poly[1], neighborhood)
    loc_poly(xy[1], xy[2])


end
