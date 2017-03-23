#!/usr/bin/R
library(ggplot2)

tick  <- c("GE","APPL","GM","BTU","WMT","JPM","LUV")
price <- c(22,900,20,22,80,31,35)
volume<- c(300,500,100,107,400,300,325)
df1 <- data.frame(ticker=tick, price=price, volume=volume)

# Here is an example with default colors
p <- ggplot(df1, aes(volume, price))+ 
  geom_point();
p


# Here is an example with colors specified by user
tick<-c("GE","APPL","GM","BTU","WMT")
ccodes<-c("#3399FF", "#FF0000", "#CC00FF", "#993300", "#66CC00")
cnames<-c("blue", "red", "purple", "brown", "green")
df2=data.frame(ticker=tick, color.codes=ccodes, color.names=cnames)

df3 <-merge(df1,df2, by=("ticker"), all.x=TRUE, all.y=TRUE)
df3$color.code.new <- ifelse(is.na(df3$color.codes), "#000000", as.character(df3$color.codes)) 

p <- ggplot(df3, aes(volume, price,colour = ticker))+ 
  geom_point() 
p + scale_colour_manual(breaks = df3$ticker,values = df3$color.code.new)

