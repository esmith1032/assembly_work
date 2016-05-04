#!/usr/bin/bash
##Eric Smith

genome_file=/bigdata/bioinfo/esmit013/fungal_assembly/maker/pythium_brassicum_P1.all.maker.proteins.fasta
output=busco_out
script=/bigdata/bioinfo/esmit013/fungal_assembly/busco/BUSCO_v1.1b1/BUSCO_v1.1b1.py

cd $PBS_O_WORKDIR

module load db-ncbi
module load ncbi-blast 
module load hmmer

python $script -o $output -in $genome_file -l eukaryota -m OGS -c 32
