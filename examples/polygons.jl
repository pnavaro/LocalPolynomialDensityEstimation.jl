using LocalPolynomialDensityEstimation
using Plots

# Define a point to test
point = Point(150, 85)

# +
# Define a polygon
polygon = [
	Point(186, 14),
	Point(186, 44),
	Point(175, 115),
	Point(175, 85)
]


# -

plot(polygon)

x=(0.5,1,0.5,0) 
y=(0,1,2,1) 

poly = [Point(i,j) for (i,j) in zip(x,y)]

plot(poly)

w = Owin( x, y)

w.xrange

w.yrange


