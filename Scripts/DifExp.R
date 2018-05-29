library (DESeq2)

args <- commandArgs(TRUE)
setwd(args)

#Read the data into R
seqdata <- read.delim("GeneMatrix.txt", stringsAsFactors = FALSE)
sampleinfo <- read.delim("Sampleinfo.txt")
stages <- sampleinfo[,2]
stages <- c(levels(stages))
combine <- combn(length(stages), 2, FUN = NULL, simplify = TRUE)

#Only the countdata, remove first column
countdata <- seqdata[,-(1:1)]
countdata <- round(countdata)

#Store gene_id as rownames
rownames(countdata) <- seqdata[,1]
rownames(sampleinfo) <- colnames(countdata)

#The columnnames are now in the same order as the samplenames
table(colnames(countdata)==sampleinfo$SampleName)


#Create DEseqDataSetFromMatrix
datasetdds <- DESeqDataSetFromMatrix(countData = countdata,
                                     colData = sampleinfo,
                                    design = ~ Status)
datasetdds

#Remove low expressed genes:
nrow(datasetdds)
keep <- rowSums(counts(datasetdds)) >=100
datasetdds <- datasetdds[keep,]
nrow(datasetdds)

#Run DESeq pipeline
datasetdds <- DESeq(datasetdds)

#PCA plot:
png('PCAplot.png')
library(ggplot2)
trans <- normTransform(datasetdds)
dataPCA <- plotPCA(trans, intgroup=c("SampleName", "Status"), returnData=TRUE)
percent <- round(100 * attr(dataPCA, "percent"))
ggplot(dataPCA, aes(PC1, PC2, color=SampleName,shape=Status))+
  geom_point(size=3)+
  xlab(paste0("PC1: ", percent[1], "% variance"))+
  ylab(paste0("PC2: ", percent[2], "% variance"))+
  coord_fixed()
dev.off()


for (i in 1:ncol(combine)) {
  a <- stages[combine[,i]]
  resultdds <- results(datasetdds, contrast=c("Status", a))
  summary(resultdds)
  resultSig <- subset(resultdds, padj < 0.1)
  b <- paste0(toString(a[1]), "_", toString(a[2]), ".csv")  

  #Genes with the strongest downregulation
  filename1 <- paste0("downregulation", "_", toString(b))
  write.csv(resultSig[order(resultSig$log2FoldChange), ], filename1)
  
  #Strongest upregulation
  filename2 <- paste0("upregulation", "_", toString(b))
  write.csv(resultSig[order(resultSig$log2FoldChange, decreasing=TRUE), ], filename2)
  
  #MA plot
  c <- paste0(toString(a[1]), "_", toString(a[2]))
  MA <- paste0("MAplot", "_", toString(c), ".png")
  png(MA)
  plotMA(resultdds, ylim=c(-20,20), main=c)
  dev.off()
}


