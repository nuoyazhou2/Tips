#!/usr/usc/R/3.3.2/bin/R

library("BSgenome.Mmusculus.UCSC.mm9")
library("ggplot2")
library("methylKit")
library("ggbio")

#system(paste("cat","DISTAL_INTERACTION_SITES_518.bed","| awk '{print $1\".\"$2\" \"$1\" \"$2\" \"$3\" +\"\" \"0\" \"0\" \"log($4)/log(10)}' >", "density.txt"))
system(paste("cat","DISTAL_INTERACTION_SITES_pValue_adjusted_864.bed","| awk '{print $1\".\"$2\" \"$1\" \"$2\" \"$3\" +\"\" \"0\" \"0\" \"(-log($4)/log(10))}' >", "density.txt"))
system(paste("sed -i '1iid chr start end strand pvalue qvalue meth.diff' density.txt"))

chr.len = seqlengths(Mmusculus)

chr.len = chr.len[grep("_|M|Y", names(chr.len), invert = T)]
myIdeo <- GRanges(seqnames = names(chr.len), ranges = IRanges(start = 1, width = chr.len))
seqlevels(myIdeo) = names(chr.len)
seqlengths(myIdeo) = (chr.len)
#chr.len

my_density_data<-read.table("density.txt",header=TRUE)
mynew<-as.data.frame(my_density_data)
#mynew
myDiff=new("methylDiff",mynew,sample.ids=c("test1","control1"),assembly="mm9",context="CpG", treatment=c(1,0),destranded=FALSE,resolution="base")


g.per = as(myDiff, "GRanges")
g.per = keepSeqlevels(g.per, names(chr.len))
values(g.per)$id = "hyper"
myIdeo
g.per


mypalette <- colorRampPalette(c("white","yellow","orange","red","violetred"))
pdf(file="density.pdf",height=8,width=8)
p <- autoplot(seqinfo(myIdeo)) + ggtitle("Interaction Heat Map")
p <- p + layout_karyogram(g.per, geom="rect", aes(fill= meth.diff,color= meth.diff),rect.height=8)
p <- p + scale_colour_gradientn(colours=mypalette(4),name="-log(p)")
p <- p + scale_fill_gradientn(colours=mypalette(4),name="-log(p)")
p
dev.off()

#mypalette <- colorRampPalette(c("white","light yellow","orange","red","violetred"))
#pdf(file="density.pdf",height=8,width=8)
#p <- autoplot(seqinfo(myIdeo)) + ggtitle("Interaction Heat Map")
#p <- p + layout_karyogram(g.per, geom="rect", aes(fill= meth.diff,color= meth.diff),rect.height=8)
#p <- p + scale_colour_gradientn(colours=mypalette(5),breaks=c(0,1,10,100,1000,10000),limits=c(0,10000))
#p <- p + scale_fill_gradientn(colours=mypalette(5),breaks=c(0,1,10,100,1000,10000),limits=c(0,10000))
#p
#dev.off()

