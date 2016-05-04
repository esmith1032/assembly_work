setwd("/Research/genomics/fungal_assembly/CAZy_output")
cats <- c('AA', 'CBM', 'CE', 'GH', 'GT', 'PL')
cols <- colorRampPalette(c("red", "yellow", "green"))(n = 299)
pdf("CAZy_heatmaps.pdf", height=10.5, width=8)
for (i in 1:length(cats))
  {
  cat <- cats[i]  
  file <- paste(cat, "_matrix.txt", sep="")  
  mat <- as.matrix(read.table(file, header=TRUE))
  heatmap(mat, col=cols, scale="column", Colv=NA, Rowv=NA, main=cat, xlab="CAZy model", ylab="Species")  
  }
dev.off()

pdf("py_CAZy_heatmaps.pdf", height=10.5, width=8)
for (k in 1:length(cats))
  {
  cat <- cats[k]  
  file <- paste("py_", cat, "_matrix.txt", sep="")  
  mat <- as.matrix(read.table(file, header=TRUE))
  heatmap(mat, col=cols, scale="column", Colv=NA, Rowv=NA, main=cat, xlab="CAZy model", ylab="Species")  
  }
dev.off()
