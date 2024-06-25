using LocalPolynomialDensityEstimation
using Test
using Aqua

@testset "LocalPolynomialDensityEstimation.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(LocalPolynomialDensityEstimation)
    end
    # Write your tests here.
end

@testset "Bezier curve" begin

    rad = 0.2
    edgy = 0.05
    n = 7
    scale = 1
    
    @show a = get_random_points(n, scale)
    @show x,y, _ = get_bezier_curve(a, rad, edgy)

    @test true

end
