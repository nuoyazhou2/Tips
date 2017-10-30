library(gplots)
library(RColorBrewer)
setwd("/Users/Mingyang/Google Drive/BS/")

## mRNA_intersection_10_to_12.txt
data = read.table("/Users/Mingyang/Google Drive/BS/mRNA/mRNA_intersection_10_to_12.txt", header=F, comment.char="#")
mat_data = data.matrix(data[, 1:(ncol(data)-1)])
rownames(mat_data) = data[, ncol(data)]
colnames(mat_data) = c("E10.5 BR1", "E10.5 BR2", "E11.5 BR1", "E11.5 BR2", "E12.5 BR1", "E12.5 BR2")


# creates a 8 x 5 inch image
png("mRNA_intersection_10_to_12.png",    # create PNG for the heat map        
    width = 8*300,        # 5 x 300 pixels
    height = 5*300,
    res = 300)        # smaller font size

cc <- rep(rainbow((ncol(data)-1)/2, start=0, end=.3), each=2)
heatmap.2(mat_data,
          ColSideColors = cc,
          scale = "row",
          density.info="none",  # turns off density plot inside color legend
          trace="none",         # turns off trace lines inside the heat map
          margins =c(12,9),     # widens margins around plot
          col=bluered,       # use on color palette defined earlier
          dendrogram="row",     # only draw a row dendrogram
          Colv="NA")            # turn off column clustering

dev.off()               # close the PNG device
