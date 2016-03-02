#!/usr/bin/bash
##Eric Smith

cd $PBS_O_WORKDIR

genome_file=/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout_no_dups/merged_assembly_no_dups.fasta
genome_out_file=/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout_no_dups/merged_assembly_no_dups.fasta.out
freq_file=/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout_no_dups/merged_assembly_no_dups_repeats.freq
repeat_file=/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout_no_dups/merged_repeats.fasta
filtered1_repeat_file=/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout_no_dups/merged_repeats_filtered1.fasta
filtered2_repeat_file=/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout_no_dups/merged_repeats_filtered2.fasta

module load RepeatScout
module load RepeatMasker
module load trf
module load nseg

build_lmer_table -l 15 -sequence $genome_file -freq $freq_file -v 
RepeatScout -sequence $genome_file -output $repeat_file -freq $freq_file -l 15
cat $repeat_file | filter-stage-1.prl > $filtered1_repeat_file
RepeatMasker -pa 16 -s -lib $filtered1_repeat_file $genome_file
cat $filtered1_repeat_file | filter-stage-2.prl --cat $genome_out_file --thresh 10 > $filtered2_repeat_file
RepeatMasker -pa 16 -s -lib $filtered2_repeat_file -nolow -norna -no_is -gff $genome_file
