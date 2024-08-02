using LocalPolynomialDensityEstimation
using Test
using Aqua
using MultivariatePolynomials
import LocalPolynomialDensityEstimation: orientation

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

     poly1 = [PlanarPoint(100,150), PlanarPoint(200,250), PlanarPoint(300,200)]
     poly2 = [PlanarPoint(150,150), PlanarPoint(150,200), PlanarPoint(200,200), PlanarPoint(200,150)]
     poly3 = [PlanarPoint(100,300), PlanarPoint(300,300), PlanarPoint(200,100)]

     @test orientation(poly1) ≈ -7500.0
     @test orientation(poly2) ≈ -2500.0
     @test orientation(poly3) ≈ - 20000.0

end
