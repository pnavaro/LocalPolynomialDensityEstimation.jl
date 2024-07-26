export PlanarPoint

struct PlanarPoint
    x::Float64
    y::Float64
end

Base.:(==)(a::PlanarPoint, b::PlanarPoint) = (a.x ≈ b.x) && (a.y ≈ b.y)


