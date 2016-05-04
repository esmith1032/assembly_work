#!/usr/bin/bash

cd $PBS_O_WORKDIR

proteins=/bigdata/bioinfo/esmit013/fungal_assembly/maker/pythium_brassicum_P1.all.maker.proteins.fasta
outfile=/bigdata/bioinfo/esmit013/fungal_assembly/maker/tmhmm/tmhmm.out

module load tmhmm

tmhmm $proteins > $outfile
