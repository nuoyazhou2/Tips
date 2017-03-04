# Principal component plot of the samples
pdf("PCA_rld.pdf",height=8,width=10)
data <- plotPCA(rld, intgroup=c("factor","cell"), returnData=TRUE)
percentVar <- round(100 * attr(data, "percentVar"))
data$factor <- factor(data$factor, levels=c("KLF4", "FLAG", "input"), labels=c("KLF4", "FLAG", "INPUT"))
data$cell <- factor(data$cell, levels=c("E14", "3F"), labels=c("E14", "3F"))
ggplot(data, aes(PC1, PC2, color=factor,shape=cell)) + geom_point(size=13) + xlab(paste0("PC1: ",percentVar[1],"% variance")) + ylab(paste0("PC2: ",percentVar[2],"% variance")) + theme_bw() + theme(panel.grid.major = element_blank(), panel.grid.minor = element_blank(), axis.title=element_text(size=40), axis.text=element_text(size=20), legend.title=element_text(size=40), legend.text=element_text(size=30))
dev.off()

