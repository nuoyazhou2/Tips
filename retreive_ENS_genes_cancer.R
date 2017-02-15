rm(list=ls())
library("biomaRt")
#ensembl54=useMart("ENSEMBL_MART_ENSEMBL", host="may2009.archive.ensembl.org/biomart/martservice/", dataset="hsapiens_gene_ensembl")
#ensembl54=useMart("ENSEMBL_MART_ENSEMBL", host="may2009.archive.ensembl.org/biomart/martservice/", dataset="mmusculus_gene_ensembl")

#ensembl67=useMart("ENSEMBL_MART_ENSEMBL", host="may2012.archive.ensembl.org")
#listDatasets(ensembl67)[grep("Homo",listDatasets(ensembl67)$description),]

ensembl67=useMart("ENSEMBL_MART_ENSEMBL", host="may2012.archive.ensembl.org", dataset="hsapiens_gene_ensembl")
f  = function(x, output) {
                start = as.numeric(x[2])-10000
                end = as.numeric(x[3])+10000
                if (x[1] != "chrM") {
                        chr.region = paste(sub("chr", "", x[1]),start,end, sep=":")
                        results=getBM(attributes = c("ensembl_gene_id"),
                                filters = c("chromosomal_region"),
                                values = chr.region,
                                mart = ensembl67)
                        gene_ids = unique(results$ensembl_gene_id)
                        gene_ids = gene_ids[!is.na(gene_ids)]
                        gene_ids_collapse = paste(gene_ids, sep=",", collapse=",")
                        cat(paste(x[1], x[2], x[3], x[4], x[5], x[6], x[7], x[8], x[9], x[10], gene_ids_collapse, sep="\t"), "\n", file= output, append = T)
                }
        }


fileNames <- Sys.glob("ttest/ttest_signif_cancer_rs*_cancer_vs_normal.txt")
for (file in fileNames) {
	cat(paste0("checking ", file, "\n"))
	file_out = paste("ENS_genes_", file, sep="")
	if (file.exists(file_out)) {
		unlink(file_out)
	}
	table = read.table(file)

	#listAttributes(ensembl67)[grep("gene_name", listAttributes(ensembl67)$name),]
	#listFilters(ensembl67)[grep("biotype", listFilters(ensembl67)$name),]


	apply(table, 1, f, output = file_out)
	
	no_col <- max(count.fields(file_out, sep = "\t"))
	dat = read.table(file_out, fill=TRUE, col.names=1:no_col)

	col_vector = as.vector(dat$X11)
	col_vector = col_vector[col_vector != ""]
	genes = paste(col_vector, collapse=",")
	genes = unique(unlist(strsplit(genes, ",")))

	cat(genes, file=paste("name_", file_out, sep=""), sep="\n")

}
