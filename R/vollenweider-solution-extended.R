dat <- read.csv("https://tpetzoldt.github.io/datasets/data/oecd.csv")

x <- log(dat$TP)
y <- log(dat$CHLa)

## Plot with correct axes, version 2, elegant
plot(x, y, xlim=log(c(1, 1000)), ylim=log(c(0.1, 1000)), 
     axes=FALSE, xlab="", ylab="") # suppress axis annotations
xtics <- 10^(0:3)
ytics <- 10^(-1:2)
axis(1, at=log(xtics), labels=xtics)
axis(2, at=log(ytics), labels=ytics, las=1) # las=1  numbers horizontally

## axis annotations with correct units superscript
mtext(expression("TP ("~mg~m^{-3}~")"), line=2.5, side=1)
mtext(expression("CHLa ("~mg~m^{-3}~")"), line=2.5, side=2)
box()

## minor tics and grid lines
xminor <- sort(unique(xtics %o% 1:9))
axis(1, at=log(xminor), labels=NA, tcl=-0.25)
abline(v = log(xminor), lty="dotted", col="grey")

yminor <- sort(unique(ytics %o% 1:9))
axis(2, at=log(xminor), labels=NA, tcl=-0.25)
abline(h = log(yminor), lty="dotted", col="grey")

# points again, so that they are in the foreground
# #006ab2 is a color from the TU Dresden corporate design palette
points(x, y, pch=16, col=c("#717778", "#93107d", "#69af22")[factor(dat$Limitation)])

legend("bottomright", legend=c("P limited", "N limited", "Light limited"),
       pch=16, col=c("#69af22", "#93107d", "#717778"))

reg <- lm(y ~ x, subset=dat$Limitation=="P")
abline(reg)
summary(reg)

## coefficients and r2
p <- coef(reg)
r2 <- 1 - var(residuals(reg))/var(y)

## annotations to the plot
text(log(2), log(400), substitute(paste(CHLa, " = ", a~TP^b),
                                  list(a=round(exp(p[1]), 2),
                                       b=round(p[2], 2))))
text(log(1.85), log(150), substitute(paste(r^2, " = ", r2), list(r2=round(r2, 2))))

## confidence limits
newdata <- data.frame(x=seq(par("usr")[1], par("usr")[2], length=100))
conflim <- predict(reg, newdata=newdata, interval="confidence")
predlim <- predict(reg, newdata=newdata, interval="prediction")

## matlines can draw multiple lines from a matrix at once
matlines(newdata$x, conflim[,2:3], col="blue", lty="dashed")
matlines(newdata$x, predlim[,2:3], col="red", lty="solid")
