module load trinity-rnaseq
module unload perl
module load perl/5.22.0
Trinity --seqType fq --max_memory 128G --normalize_reads --min_contig_length 1000 --single /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane2_pair1_CTTGTA_filter.fastq --output /bigdata/bioinfo/esmit013/virus_work/trinity_lane2_CTTGTA
