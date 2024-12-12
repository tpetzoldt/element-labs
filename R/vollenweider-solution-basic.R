dat <- read.csv("https://tpetzoldt.github.io/datasets/data/oecd.csv")

## Only P-limited data
dat <- subset(dat, Limitation == "P")

## (A) Standard approach from the course
x <- log(dat$TP)
y <- log(dat$CHLa)

plot(x, y)
reg <- lm(y ~x)
abline(reg)
summary(reg)

## Plot with correct axes
plot(x, y, axes=FALSE) # suppress axis annotations

xtics <- c(10, 100)
ytics <- c(1, 10, 100)

axis(1, at=log(xtics), labels=xtics)
axis(2, at=log(ytics), labels=ytics)
box()

newdata <- data.frame(x=seq(min(x), max(x), length=100))
conflim <- predict(reg, newdata=newdata, interval="confidence")
predlim <- predict(reg, newdata=newdata, interval="prediction")
lines(newdata$x, conflim[,2], col="blue", lty="dashed")
lines(newdata$x, conflim[,3], col="blue", lty="dashed")
lines(newdata$x, predlim[,2], col="red", lty="solid")
lines(newdata$x, predlim[,3], col="red", lty="solid")
