#!/usr/bin/bash
##Eric Smith

cd $PBS_O_WORKDIR

proteins1=/bigdata/bioinfo/esmit013/fungal_assembly/maker/signalp/prot_seq_1.faa
proteins2=/bigdata/bioinfo/esmit013/fungal_assembly/maker/signalp/prot_seq_2.faa
gff1=/bigdata/bioinfo/esmit013/fungal_assembly/maker/signalp/signal_peptides_1.gff
gff2=/bigdata/bioinfo/esmit013/fungal_assembly/maker/signalp/signal_peptides_2.gff

module load signalp

signalp -t euk -n $gff1 $proteins1
signalp -t euk -n $gff2 $proteins2
