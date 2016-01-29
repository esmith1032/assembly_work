library(fields)

setwd("~/Desktop")

pdf("soap_assembly_stats.pdf", height=8, width=10.5)

assembly_stats <- read.table("soap_assembly_stats.txt", header = TRUE, sep = "\t")

par(mfrow=c(2,2))

plot(-100, -100, xlim=c(min(assembly_stats$K), max(assembly_stats$K)), ylim=c(min(min(assembly_stats$raw_scaffold_num), min(assembly_stats$processed_scaffold_num)), max(max(assembly_stats$raw_scaffold_num), max(assembly_stats$processed_scaffold_num))), xlab='kmer', ylab='number of scaffolds', main='Total Scaffolds', frame.plot=T)
lines(assembly_stats$K, assembly_stats$raw_scaffold_num, col='red')
lines(assembly_stats$K, assembly_stats$processed_scaffold_num, col='black')
legend(80, max(assembly_stats$raw_scaffold_num), c("Raw Data", "Processed Data"), fill = c("red", "black"), cex=0.75)

plot(-100, -100, xlim=c(min(assembly_stats$K), max(assembly_stats$K)), ylim=c(min(min(assembly_stats$raw_max_len), min(assembly_stats$processed_max_len)), max(max(assembly_stats$raw_max_len), max(assembly_stats$processed_max_len))), xlab='kmer', ylab='maximum length', main='Maximum Scaffold Length', frame.plot=T)
lines(assembly_stats$K, assembly_stats$raw_max_len, col='red')
lines(assembly_stats$K, assembly_stats$processed_max_len, col='black')
legend(80, max(max(assembly_stats$raw_max_len), max(assembly_stats$processed_max_len)), c("Raw Data", "Processed Data"), fill = c("red", "black"), cex=0.75)

plot(-100, -100, xlim=c(min(assembly_stats$K), max(assembly_stats$K)), ylim=c(min(min(assembly_stats$raw_N50), min(assembly_stats$processed_N50)), max(max(assembly_stats$raw_N50), max(assembly_stats$processed_N50))), xlab='kmer', ylab='N50', main='N50', frame.plot=T)
lines(assembly_stats$K, assembly_stats$raw_N50, col='red')
lines(assembly_stats$K, assembly_stats$processed_N50, col='black')
legend(80, max(max(assembly_stats$raw_N50), max(assembly_stats$processed_N50)) - 4000, c("Raw Data", "Processed Data"), fill = c("red", "black"), cex=0.75)

plot(-100, -100, xlim=c(min(assembly_stats$K), max(assembly_stats$K)), ylim=c(min(min(assembly_stats$raw_assembled_bases), min(assembly_stats$processed_assembled_bases)), max(max(assembly_stats$raw_assembled_bases), max(assembly_stats$processed_assembled_bases))), xlab='kmer', ylab='assembled bases', main='Assembly Size', frame.plot=T)
lines(assembly_stats$K, assembly_stats$raw_assembled_bases, col='red')
lines(assembly_stats$K, assembly_stats$processed_assembled_bases, col='black')
legend(80, max(max(assembly_stats$raw_assembled_bases), max(assembly_stats$processed_assembled_bases)) - 2500000, c("Raw Data", "Processed Data"), fill = c("red", "black"), cex=0.75)

par(mfrow=c(1,1))
dev.off()
