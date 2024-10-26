library(MASS)
library(leaps)
library(grpreg)
classify <- function(lst){
  correct = 0 
  add = 0
  less = 0
  error = 0
  xz <- matrix(rownames(data.frame(lst)))
  if('V1'%in%xz & 'V2'%in%xz & 'V3'%in%xz ){
    if(length(xz) == 4)
      correct = correct + 1
    else
      add = add + 1
  } 
  else if('V4'%in%xz | 'V5'%in%xz | 'V6'%in%xz |'V7'%in%xz | 'V8'%in%xz | 'V9'%in%xz |'V10'%in%xz)
    error = error + 1
  else
    less = less + 1
  return(cbind(correct, add, less, error)) #生成行向量
}

generate_data<-function(n,p){
  beta <- as.matrix(runif(4, min = 1, max = 2))
  mean <- rep(0, p)
  sigma <- diag(p)
  X <- MASS::mvrnorm(n, mean, sigma) 
  eps <- rnorm(n)
  y <- cbind(matrix(1, nrow = n, ncol = 1), X)[,1:4] %*%
    beta + as.matrix(eps)
  return(list(y,X,beta,eps))
}

get_result<-function(n, p){
  Lasso <- t(rep(0, 4))
  Scad  <- t(rep(0, 4))
  for (i in 1:500){
    Lasso <- Lasso + simulate(n,p)[[1]]
    Scad <- Scad + simulate(n,p)[[2]]
  }
  Lasso <- Lasso / 500
  Scad <- Scad / 500
  return(rbind(Lasso, Scad))
}

simulate<-function(n,p){
  data <- generate_data(n,p)
  y <- data[[1]]
  X <- data[[2]]
  fit1 <- grpreg(X = X, y = y, penalty = "grLasso")
  lasso <- select(fit1, "BIC")$beta
 
  fit2 <- grpreg(X = X, y = y, penalty = "grSCAD")
  scad <- select(fit2, "BIC")$beta
  scad <- which(scad!=0)
  return(list(classify(lasso), classify(scad)))
}
get_result(200, 10)