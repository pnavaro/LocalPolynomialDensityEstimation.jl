projection(u, v, w) = integral(u * v, w) / integral(v * v, w) * v

function usual_polynomials(deg, w)
    out = PixelImage[]
    for d = 0:deg, i = 0:d
        j = d - i
        push!(out, PixelImage((x, y) -> x^i * y^j, w))
    end
    out
end

function orthonormal_polynomials(deg, w)

    out = Image[]

    plist = usual_polynomials(deg, w)

    for u in plist

        for v in out
            u = u - projection(u, v, w)
        end

        push!(out, u)

    end

    [PixelImage(u -> u / sqrt(integral(u * u, w))) for u in out]

end

function integral(f::Function, w::ObservationWindow)

    s = sum(f(px,py) for px in w.x, py in w.y if inside(PlanarPoint(px, py), w.boundary))

    return s * z.dx * z.dy

end
