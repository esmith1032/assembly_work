#!/usr/bin/bash
##Eric Smith

proteins=/bigdata/bioinfo/esmit013/fungal_assembly/maker/pythium_brassicum_P1.all.maker.proteins.fasta
out_file=/bigdata/bioinfo/esmit013/fungal_assembly/maker/blastp/blast_out.xml

module load ncbi-blast
module load db-ncbi

blastp -db $NCBI_DB/nr -query $proteins -out $out_file -outfmt 5 -num_threads 32 -max_target_seqs 100 -evalue 1e-6
