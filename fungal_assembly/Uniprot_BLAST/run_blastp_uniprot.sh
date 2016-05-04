#!/usr/bin/bash
##Eric Smith

cd $PBS_O_WORKDIR

db_infile=/bigdata/bioinfo/esmit013/fungal_assembly/maker/blast_uniprot/uniprot_sprot.fasta
db_out=/bigdata/bioinfo/esmit013/fungal_assembly/maker/blast_uniprot/uniprot_sprot
proteins=/bigdata/bioinfo/esmit013/fungal_assembly/maker/pythium_brassicum_P1.all.maker.proteins.fasta
out_file=/bigdata/bioinfo/esmit013/fungal_assembly/maker/blast_uniprot/blast_out.txt

module load ncbi-blast

makeblastdb -in $db_infile -out $db_out -input_type fasta -dbtype prot
blastp -db $db_out -query $proteins -out $out_file -outfmt "6 std qlen" -num_threads 32 -max_target_seqs 1 -evalue 1e-6
