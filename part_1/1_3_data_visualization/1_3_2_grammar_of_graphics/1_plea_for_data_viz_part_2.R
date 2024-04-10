library(tidyverse)

a1 <- read_csv("data/anscombe1.csv")
a2 <- read_csv("data/anscombe2.csv")
a3 <- read_csv("data/anscombe3.csv")
a4 <- read_csv("data/anscombe4.csv")

a1
a2
a3
a4

cor(a1$x, a1$y)
cor(a2$x, a2$y)
cor(a3$x, a3$y)
cor(a4$x, a4$y)

mean(a1$x)
mean(a2$x)
mean(a3$x)
mean(a4$x)

mean(a1$y)
mean(a2$y)
mean(a3$y)
mean(a4$y)

sd(a1$x)
sd(a2$x)
sd(a3$x)
sd(a4$x)

sd(a1$y)
sd(a2$y)
sd(a3$y)
sd(a4$y)

plot1 <- a1 |> 
  ggplot(aes(x, y)) +
  geom_point(size = 1.5)

plot2 <- a2 |> 
  ggplot(aes(x, y)) +
  geom_point(size = 1.5)


plot3 <- a3 |> 
  ggplot(aes(x, y)) +
  geom_point(size = 1.5)

plot4 <- a4 |> 
  ggplot(aes(x, y)) +
  geom_point(size = 1.5)

#install.packages("cowplot")
library(cowplot)

plot_grid(plot1, plot2, plot3, plot4, labels=c("1", "2", "3", "4"), ncol = 2, nrow = 2)
