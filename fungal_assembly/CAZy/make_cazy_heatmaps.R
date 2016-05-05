setwd("/Research/genomics/fungal_assembly/CAZy_output")
library("gplots")
library("devtools")
cats <- c('AA', 'CBM', 'CE', 'GH', 'GT', 'PL')
##cols <- colorRampPalette(c("red", "yellow", "green"))(n = 299)
cols <- colorRampPalette(c("red", "black", "green"))(n = 200)
pdf("CAZy_heatmaps.pdf", height=10.5, width=8)
for (i in 1:length(cats))
  {
  cat <- cats[i]  
  if (cat == "AA")
    {title <- "Auxillary Activities"}
  if (cat == "CBM")
    {title <- "Carbohydrate Binding Modules"}
  if (cat == "CE")
    {title <- "Carbohydrate Esterases"}
  if (cat == "GH")
    {title <- "Glycoside Hydrolases"}
  if (cat == "GT")
    {title <- "Glycosyl Transferases"}
  if (cat == "PL")
    {title <- "Polysaccharide Lyases"}
  file <- paste(cat, "_matrix.txt", sep="")  
  mat <- as.matrix(read.table(file, header=TRUE))
  heatmap.2(mat, col=cols, scale="column", Colv=NA, Rowv=NA, main=title, xlab="CAZy model", ylab="Species", dendrogram = "none", trace = "none", density.info = "none")  
  }
dev.off()

pdf("py_CAZy_heatmaps.pdf", height=10.5, width=8)
for (k in 1:length(cats))
  {
  cat <- cats[k]  
  if (cat == "AA")
    {title <- "Auxillary Activities"}
  if (cat == "CBM")
    {title <- "Carbohydrate Binding Modules"}
  if (cat == "CE")
    {title <- "Carbohydrate Esterases"}
  if (cat == "GH")
    {title <- "Glycoside Hydrolases"}
  if (cat == "GT")
    {title <- "Glycosyl Transferases"}
  if (cat == "PL")
    {title <- "Polysaccharide Lyases"}
  file <- paste("py_", cat, "_matrix.txt", sep="")  
  mat <- as.matrix(read.table(file, header=TRUE))
  heatmap.2(mat, col=cols, scale="column", Colv=NA, Rowv=NA, main=title, xlab="CAZy model", ylab="Species", key = TRUE, dendrogram = "none", trace = "none", density.info = "none")  
  }
dev.off()
