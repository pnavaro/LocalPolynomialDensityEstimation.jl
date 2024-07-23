export Point

struct Point
    x::Float64
    y::Float64
end

Base.:(==)(a::Point, b::Point) = (a.x ≈ b.x) && (a.y ≈ b.y)
