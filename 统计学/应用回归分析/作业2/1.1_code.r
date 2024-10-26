n <- 6
female <- c(0, 0, 0, 1, 0, 1)
earnings <- c(14600, 5000, 32000, 47000, 161525, 33000)
hours <- c(45, 45, 40, 40, 50, 40)
week <- c(52, 52, 51, 52, 52, 52)
X = earnings / (hours * week) 
Y = female
A <- data.frame(a = X,b = Y) 
mytable <-table(A[[1]],A[[2]]) # 构造频数表
v = margin.table(mytable,1) /  margin.table(mytable) 
EEXWhenY = v * Y # 求期望E(E(X|Y))
summary(EEXWhenY) # E(E(X|Y)) = EX = 1/3
