# ---
# jupyter:
#   jupytext:
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

using Plots

s = random_shape(; rad = 0.2, edgy = 0.1)


plot(s[1,:], s[2,:])

# +
using LinearAlgebra

function inshape(points, p)
    
    n = size(points,2)
    crosstimes=zeros(n)
    for i=1:n
        a=rand(2)
        b=points[:,i]
        for j=1:size(p,2)-1
            c = p[:,j+1] - p[:,j]
            d = p[:,j]
            ts = pinv(hcat(a, -c)) * (d - b)
            if ts[1]>0 && ts[2]>=0 && ts[2] < 1
                crosstimes[i] += 1
            end
        end
    end
    mod.(crosstimes,2) .== 1
end

points=rand(2, 100)
scatter(points[1,:], points[2, :], group=inshape(points, p) )
plot!(s[1, :], s[2, :])
# -


