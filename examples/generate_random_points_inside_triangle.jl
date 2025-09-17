using Distributions
using Plots
using Random

triangle = [ 1 2; 3 8; 7 5 ]

"""
Generate random points inside a triangle using barycentric coordinates.

Parameters:
- triangle: 3×2 matrix where each row represents a vertex [x, y]
- n: number of random points to generate

Returns:
- n×2 matrix of random points inside the triangle
"""
function random_points_in_triangle(triangle, n::Int)
    # Extract triangle vertices
    A, B, C = triangle[1, :], triangle[2, :], triangle[3, :]
    
    # Initialize array to store points
    points = zeros(n, 2)
    
    for i in 1:n
        # Generate two random numbers
        r1, r2 = rand(), rand()
        
        # Transform to ensure uniform distribution inside triangle
        # Using the square root method for uniform distribution
        sqrt_r1 = sqrt(r1)
        
        # Calculate barycentric coordinates
        # These coordinates satisfy: α + β + γ = 1 and α, β, γ ≥ 0
        α = 1 - sqrt_r1                    # weight for vertex A
        β = sqrt_r1 * (1 - r2)            # weight for vertex B  
        γ = sqrt_r1 * r2                   # weight for vertex C
        
        # Convert barycentric coordinates to Cartesian coordinates
        # P = α*A + β*B + γ*C
        point = α * A + β * B + γ * C
        points[i, :] = point
    end
    
    return points
end

"""
Generate random points inside a triangle using barycentric coordinates with exponential distribution.

The key insight: When you generate 3 independent exponential random variables X₁, X₂, X₃ 
and normalize them as α = X₁/(X₁+X₂+X₃), β = X₂/(X₁+X₂+X₃), γ = X₃/(X₁+X₂+X₃),
the resulting (α, β, γ) follows a Dirichlet distribution.

NO square root transformation needed - the exponential variables handle the distribution correctly!

Parameters:
- triangle: 3×2 matrix where each row represents a vertex [x, y]
- n: number of random points to generate
- λ: rate parameter for the exponential distribution (default: 1.0)

Returns:
- n×2 matrix of random points inside the triangle
"""
function random_points_in_triangle_exponential(triangle, n::Int)
    # Extract triangle vertices
    A, B, C = triangle[1, :], triangle[2, :], triangle[3, :]
    
    # Initialize array to store points
    points = zeros(n, 2)
    
    # Create exponential distribution
    exp_dist = Exponential()  # Note: Distributions.jl uses scale parameter (1/rate)
    
    for i in 1:n
        # Generate three independent exponential random variables
        # This is the COMPLETE method - no additional transformations needed!
        X1 = rand(exp_dist)
        X2 = rand(exp_dist)
        X3 = rand(exp_dist)
        
        # Normalize to get barycentric coordinates
        # This normalization automatically gives the correct distribution on the triangle
        total = X1 + X2 + X3
        α = X1 / total  # weight for vertex A
        β = X2 / total  # weight for vertex B
        γ = X3 / total  # weight for vertex C
        
        # Convert barycentric coordinates to Cartesian coordinates
        point = α * A + β * B + γ * C
        points[i, :] = point
    end
    
    return points
end

"""
Generate random points using the triangle point picking method with vectors.

This method works by:
1. Defining two vectors u and v that span the triangle from one vertex
2. Generating random points in the parallelogram defined by u and v
3. For points outside the triangle, reflect about the diagonal

Parameters:
- triangle: 3×2 matrix where each row represents a vertex [x, y]
- n: number of random points to generate

Returns:
- n×2 matrix of random points inside the triangle
"""
function random_points_triangle_vector_method(triangle, n::Int)
    # Extract triangle vertices - use first vertex as origin
    A, B, C = triangle[1, :], triangle[2, :], triangle[3, :]
    
    # Define vectors u and v from vertex A
    u = B - A  # vector from A to B
    v = C - A  # vector from A to C
    
    points = zeros(n, 2)
    
    for i in 1:n
        # Generate random coordinates in [0,1] × [0,1]
        s, t = rand(), rand()
        
        # If point is outside triangle (s + t > 1), reflect it
        if s + t > 1.0
            s = 1.0 - s
            t = 1.0 - t
        end
        
        # Convert to Cartesian coordinates
        # P = A + s*u + t*v
        point = A + s * u + t * v
        points[i, :] = point
    end
    return points
end

"""
Visualize the results
"""
function plot_triangle_with_points(triangle, points; title="Random Points in Triangle")
    # Create the plot
    p = plot(title=title, aspect_ratio=:equal, legend=false)
    
    # Plot triangle outline
    triangle_x = [triangle[1,1], triangle[2,1], triangle[3,1], triangle[1,1]]
    triangle_y = [triangle[1,2], triangle[2,2], triangle[3,2], triangle[1,2]]
    plot!(p, triangle_x, triangle_y, linewidth=2, color=:black, label="Triangle")
    
    # Plot random points
    scatter!(p, points[:, 1], points[:, 2], markersize=2, alpha=0.6, color=:red, 
             markerstrokewidth=0, label="Random Points")
    
    # Mark vertices
    scatter!(p, triangle[:, 1], triangle[:, 2], markersize=6, color=:blue, label="Vertices")
    
    return p
end

# Generate random points
n_points = 2000
println("Generating $n_points random points...")

# Method 1: Barycentric coordinates (efficient)
@time points_barycentric = random_points_in_triangle(triangle, n_points)
@time points_exponential = random_points_in_triangle_exponential(triangle, n_points)
@time points_two_vectors = random_points_triangle_vector_method(triangle, n_points)

# Create visualizations
p1 = plot_triangle_with_points(triangle, points_barycentric,
                              title="Barycentric Coordinate Method")
p2 = plot_triangle_with_points(triangle, points_exponential, 
                              title="Exponential")
p3 = plot_triangle_with_points(triangle, points_two_vectors, 
                              title="Triangle point picking")
plot(p1, p2, p3, layout=(1,3), size=(800, 600))


