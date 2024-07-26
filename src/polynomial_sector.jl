export polynomial_sector

function polynomial_sector(k; npoly = 128)

    x1 = (1, 1)
    y1 = (0, 1)
    x2 = LinRange(1, 0, npoly)
    y2 = x2 .^ k
    x3 = (0, 1)
    y3 = (0, 0)

    x = vcat(x1..., x2..., x3...)
    y = vcat(y1..., y2..., y3...)

    ObservationWindow(x, y)

end

export f_norm

function f_norm(x, y, k)

    w = polynomial_sector(k)

    xrange = extrema(p.x for p in w.boundary)
    yrange = extrema(p.y for p in w.boundary)

    dx = (xrange[2] - xrange[1]) / IMG_SIZE
    dy = (yrange[2] - yrange[1]) / IMG_SIZE

    vx = LinRange(xrange[1], xrange[2], IMG_SIZE + 1)[1:end-1] .+ 0.5dx
    vy = LinRange(yrange[1], yrange[2], IMG_SIZE + 1)[1:end-1] .+ 0.5dy

    a1 = 1 / 10
    b1 = (1 / 10)^k / 2
    a2 = 3 / 4
    b2 = (3 / 4)^k / 2

    A = 0.0

    for px in vx, py in vy

        if inside(PlanarPoint(px, py), w)

            A += (
                exp(-((px - a1)^2 + (py - b1)^2) / (2 * 0.4^2)) +
                exp(-((px - a2)^2 + (py - b2)^2) / (2 * 0.15^2))
            )

        end

    end

    g = (
        exp(-((x - a1)^2 + (y - b1)^2) / (2 * 0.4^2)) +
        exp(-((x - a2)^2 + (y - b2)^2) / (2 * 0.15^2))
    )

    return g / (A * dx * dy)

end

export f_poly

function f_poly(x, y, k)

    w = polynomial_sector(k)

    a = 0.6
    b = 0.2

    xrange = extrema(p.x for p in w.boundary)
    yrange = extrema(p.y for p in w.boundary)

    dx = (xrange[2] - xrange[1]) / IMG_SIZE
    dy = (yrange[2] - yrange[1]) / IMG_SIZE

    vx = LinRange(xrange[1], xrange[2], IMG_SIZE + 1)[1:end-1] .+ 0.5dx
    vy = LinRange(yrange[1], yrange[2], IMG_SIZE + 1)[1:end-1] .+ 0.5dy

    A = 0.0

    for px in vx, py in vy

        if inside(PlanarPoint(px, py), w)

            A += abs(px - a)^2 + abs(py - b)^2

        end

    end

    g = abs(x - a)^2 + abs(y - b)^2

    return g / (A * dx * dy)

end
