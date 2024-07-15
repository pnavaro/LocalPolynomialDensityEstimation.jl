using TypedPolynomials

projection(u, v, w) = integral(u * v, w) / integral(v * v, w) * v

function usual_polynomials(deg, w)
    out = Image[]
    for d in 0:deg, i in 0:d
        j = d-i
        push!(out, Image((x,y) -> x^i * y^j, w))
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

  [Image( u -> u/sqrt(integral(u*u, w))) for u in out]

end


function usual_polynomials(deg :: Int)
    @polyvar x y
    out = Monomial[]
    for d in 0:deg, i in 0:d
        j = d-i
        push!(out, x^i * y^j)
    end
    out
end

function integral( m :: Monomial, w :: ObservationWindow )

    s = sum(m(x=>px, y=>py) for px in w.x, py in w.y if inshape(Point(px,py), w.boundary))

    return s * z.dx * z.dy

end
