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


## another example
pdf("PCA_rld_rgb.pdf",height=8,width=10)
data <- plotPCA(rld, intgroup=c("condition"), returnData=TRUE)

group_codes = c("KLF4_E14", "input_E14", "KLF4_3F", "FLAG_3F", "input_3F")
color_codes = c(rgb(255,0,0,max=255), rgb(153,153,153,max=255), rgb(0,255,0,max=255), rgb(0,0,255,max=255), rgb(102,102,102,max=255))

percentVar <- round(100 * attr(data, "percentVar"))
data$condition = factor(data$condition, levels = c("KLF4_E14","KLF4_3F","FLAG_3F","input_E14","input_3F"))
#data$factor <- factor(data$factor, levels=c("KLF4", "FLAG", "input"), labels=c("KLF4", "FLAG", "INPUT"))
#data$cell <- factor(data$cell, levels=c("E14", "3F"), labels=c("E14", "3F"))
ggplot(data, aes(PC1, PC2, color=condition)) + geom_point(size=13) + xlab(paste0("PC1: ",percentVar[1],"% variance")) + ylab(paste0("PC2: ",percentVar[2],"% variance")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.title=element_text(size=40), axis.text=element_text(size=20), legend.title=element_text(size=40), legend.text=element_text(size=30)) + scale_colour_manual(values = setNames(color_codes, group_codes))
dev.off()

# reference
# http://stackoverflow.com/questions/21536835/ggplot-colour-points-by-groups-based-on-user-defined-colours
# http://stackoverflow.com/questions/9827193/color-ggplot-points-based-on-defined-color-codes
