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

x=(0.5,1,0.5,0) 
y=(0,1,2,1) 
w = Window( x, y)


# +
function polynomial_sector(k; npoly = 128)

    x1 = (1, 1)
    y1 = (0, 1)
    x2 = LinRange(1, 0, npoly)
    y2 = x2.^k
    x3 = (0, 1)
    y3 = (0, 0)

    x = vcat(x1..., x2..., x3...)
    y = vcat(y1..., y2..., y3...)
    
    Window(x, y)
        
end

function f_poly(x, y, k)
    domain = polynomial_sector(k)
    a = 0.6
    b = 0.2
    g = (u, v) -> abs(u - a)^2 + abs(v - b)^2
    A = integral(Image(g, domain), domain)
    g(x, y) / A
end
# -

NN = (200, 500, 1000, 2000)
HH = range(start = 0.01, stop=0.6, step = 0.001)
KK = (1, 2.1)
MM = 0:5

# +
@poyvar x y

for n in NN, k in KK 
    # closest points that are not NA
    if k == 1 
        idx = (1, 1)
    else 
        idx = (1, 10)
    end
    domain = polynomial_sector(k)
    
    f = (x, y) -> f_poly(x, y, k)
    
    f00 = f(0, 0)
    
    eps = 0.001
    
    zero = ppp(eps, eps ^ k / 2, domain)
    data = rpoint(n, f, domain)

    for h in HH 

            f_sparr = bivariate.density(data, h)$z
            f_sparr = as.vector(f_sparr[idx[1], idx[2]])
           
            value = (f_sparr - f00) ** 2
          
            for m in MM
              mylp = density_estimation(data,domain,at_points = zero,bandwidth = h,degree = m)
            end
    end

end
# -


