n <- 15
x <- 49.2/15
y <- 396.2/15
lxx <- 196.16 - n * x ^ 2
lxy <- 1470.65 - n * x * y
b1 <- lxy / lxx
b0 <- y - b1 * x
