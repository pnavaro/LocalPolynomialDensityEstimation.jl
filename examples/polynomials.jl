# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.2
#   kernelspec:
#     display_name: Julia 1.10.4
#     language: julia
#     name: julia-1.10
# ---

using LocalPolynomialDensityEstimation
using TypedPolynomials

function usual_polynomials(deg)
    @polyvar x y
    out = Monomial[]
    for d in 0:deg, i in 0:d
        j = d-i
        push!(out, x^i * y^j)
    end
    out
end


plist = usual_polynomials(3)

plist[1](x=>1, y=>2)

u = plist[1]
v = plist[2]

projection(u, v, w) = integral(u * v, w) / integral(v * v, w) * v


# +
function orthonormal_polynomials(deg)

  out = Monomial[]

  plist = usual_polynomials(deg)

  for u in plist

      for v in out
          u = u - projection(u, v)
      end

      push!(out, u)

  end

  [Image( u -> u/sqrt(integral(u*u, w))) for u in out]

end
