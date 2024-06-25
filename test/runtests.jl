using LocalPolynomialDensityEstimation
using Test
using Aqua

@testset "LocalPolynomialDensityEstimation.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(LocalPolynomialDensityEstimation)
    end
    # Write your tests here.
end
