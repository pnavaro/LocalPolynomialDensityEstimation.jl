using LocalPolynomialDensityEstimation
using Test
using Aqua
using MultivariatePolynomials

@testset "LocalPolynomialDensityEstimation.jl" begin

    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(
            LocalPolynomialDensityEstimation;
            ambiguities = false,
            piracies = false
        )
    end

#    @testset "Bezier curve" begin
#
#        radius = 0.2
#        edgy = 0.05
#        n = 7
#        scale = 1
#
#        a = LocalPolynomialDensityEstimation.get_random_points(n, scale)
#        c = LocalPolynomialDensityEstimation.get_bezier_curve(a, radius, edgy)
#
#        @test true
#
#    end

end
