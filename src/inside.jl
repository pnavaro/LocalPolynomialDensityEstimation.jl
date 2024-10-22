export inside

"""
$(SIGNATURES)

Checking if a point is inside a observation window
"""
function inside(point::PlanarPoint, w::ObservationWindow)

    shape = w.boundary
    x, y = point.x, point.y

    inside(x, y, shape)

end


function inside(x::Real, y::Real, shape::Vector{PlanarPoint})

    num_vertices = length(shape)
    inside = false

    # if point is on the boundary return true

    if any((p.x ≈ x && p.y ≈ y) for p in shape)
        return true
    end

    # Store the first point in the shape and initialize the second point
    p1 = shape[1]

    # Loop through each edge in the shape
    for i = 2:num_vertices

        # Get the next point in the shape
        p2 = shape[i]

        # if the point is on the boundary 
        if (y < p1.y) ≠ (y < p2.y)
            if (x < p1.x) ≠ (x < p2.x)
                if (p2.x - p1.x) * (y - p1.y) ≈ (p2.y - p1.y) * (x - p1.x)
                    return true
                end
            end
        end

        # Check if the point is above the minimum y coordinate of the edge
        if y > min(p1.y, p2.y)

            # Check if the point is below the maximum y coordinate of the edge
            if y <= max(p1.y, p2.y)

                # Check if the point is to the left of the maximum x coordinate of the edge
                if x <= max(p1.x, p2.x)

                    # Calculate the x-intersection of the line connecting the point to the edge
                    x_intersection = (y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x

                    # Check if the point is on the same line as the edge or to the left of the x-intersection
                    if p1.x ≈ p2.x || x <= x_intersection

                        # Flip the inside flag
                        inside = !inside

                    end

                end

            end

        end

        # Store the current point as the first point for the next iteration
        p1 = p2

    end

    # Return the value of the inside flag
    return inside

end
