n <- 10
x1 <- c(70, 75, 65, 74, 72, 68, 78, 66, 70, 65)
x2 <- c(35, 40, 40, 42, 38, 45, 42, 36, 44, 42)
y <- c(160, 260, 210, 265, 240, 220, 275, 160, 275, 250)
dat1 <- do.call(cbind,list(y,x1,x2))
fit <- lm(y ~ x1+ x2)
new <- data.frame(x1 = 75, x2 = 42, x3 = 3.1)  
lm.pred <- predict(fit,new,interval = "prediction",level = 0.95)
lm.pred