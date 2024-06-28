function polynomial_sector(k; npoly = 128)
  x1 = (1, 1)
  y1 = (0, 1)
  x2 = LinRange(1, 0, npoly)
  y2 = x2^k
  x3 = (0, 1)
  y3 = (0, 0)

  x = (x1, x2, x3)
  y = (y1, y2, y3)
  owin(poly = list(x = x, y = y))
end

