# ---
# jupyter:
#   jupytext:
#     formats: ipynb,jl:light
#     text_representation:
#       extension: .jl
#       format_name: light
#       format_version: '1.5'
#       jupytext_version: 1.16.3
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

@polyvar x y
plist[1](x=>1, y=>2)

u = plist[5]
v = plist[6]

f = u * v

z = Image(f, (0,1), (0,1))

typeof(f) <: AbstractPolynomialLike

w = Window((0.1,0.1), (0.2,0.2))

integral(u * v, w)

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
# -


