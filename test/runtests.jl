using LocalPolynomialDensityEstimation
using Test
using Aqua
using TypedPolynomials
import LocalPolynomialDensityEstimation: orientation
using RCall

@testset "integrals" begin

    R"""
    f <- function(x,y){3*x^2 + 2*y}
    z <- spatstat.geom::as.im(f, spatstat.geom::square(1))
    """

    @polyvar x y
    f = 3 * x^2 + 2 * y
    z = PixelImage(f, ObservationWindow((0, 1), (0, 1)))

    @test rcopy(R"spatstat.geom::integral.im(z)") ≈ integral(z)

    R"""
    w <- spatstat.geom::owin(poly=list(x=c(0.0,1.0,1.0),y=c(0.0,0.0,1.0)))
    z <- spatstat.geom::as.im(f, w)
    """

    w = ObservationWindow((0, 1, 1), (0, 0, 1))
    z = PixelImage(f, w)

    @test integral(z) ≈ rcopy(R"spatstat.geom::integral.im(z)")

    for k = 1:2

        @rput k

        R"""
        polynomial_sector <- function(k, npoly = 128) {
          x1 <- c(1, 1)
          y1 <- c(0, 1)
          x2 <- seq(1, 0, length.out = npoly)
          y2 <- x2 ** k
          x3 <- c(0, 1)
          y3 <- c(0, 0)

          x <- c(x1, x2, x3)
          y <- c(y1, y2, y3)

          spatstat.geom::owin(poly =  list(x = x, y = y))
        }
        w <- polynomial_sector(k)
        """

        w = polynomial_sector(k)
        z = PixelImage(f, w)

        @test integral(z) ≈
              rcopy(R"spatstat.geom::integral.im(spatstat.geom::as.im(f, w), domain = w)")

    end

end



@testset "LocalPolynomialDensityEstimation.jl" begin

    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(
            LocalPolynomialDensityEstimation;
            ambiguities = false,
            piracies = false,
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

    poly1 = [PlanarPoint(100, 150), PlanarPoint(200, 250), PlanarPoint(300, 200)]
    poly2 = [
        PlanarPoint(150, 150),
        PlanarPoint(150, 200),
        PlanarPoint(200, 200),
        PlanarPoint(200, 150),
    ]
    poly3 = [PlanarPoint(100, 300), PlanarPoint(300, 300), PlanarPoint(200, 100)]

    @test orientation(poly1) ≈ -7500.0
    @test orientation(poly2) ≈ -2500.0
    @test orientation(poly3) ≈ -20000.0

end
