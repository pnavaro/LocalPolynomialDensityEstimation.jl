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

x=(0.5,1,0.5,0) 
y=(0,1,2,1) 
w = ObservationWindow( x, y)


polynomial_sector(1)

# +
f_norm( 0.5, 0.5, 1)


# -

NN = (200, 500, 1000, 2000)
HH = range(start = 0.01, stop=0.6, step = 0.001)
KK = (1, 2.1)
MM = 0:5

# +
@polyvar x y

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
    
    zero = PointPattern(eps, eps ^ k / 2, domain)
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


