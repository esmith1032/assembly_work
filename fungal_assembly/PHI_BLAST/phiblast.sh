#!/usr/bin/bash

cd $PBS_O_WORKDIR

protein_file=/bigdata/bioinfo/esmit013/fungal_assembly/maker/pythium_brassicum_P1.all.maker.proteins.fasta
db_infile=/bigdata/bioinfo/esmit013/fungal_assembly/phi_base/new_phi_accessions.fasta
db_outfile=/bigdata/bioinfo/esmit013/fungal_assembly/phi_base/new_phi_accessions.db
outfile=/bigdata/bioinfo/esmit013/fungal_assembly/maker/phi_base/phiblast.out

module load ncbi-blast

makeblastdb -in $db_infile -input_type fasta -out $db_outfile -dbtype prot
blastp -db $db_outfile -query $protein_file -out $outfile -outfmt "6 std qlen" -num_threads 32 -max_target_seqs 1 -evalue 1e-6
