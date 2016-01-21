module load fastqc

gunzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_CTTGTA.fastq.gz
fastqc --outdir /bigdata/bioinfo/esmit013/virus_work/fastqc /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_CTTGTA.fastq 
gzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_CTTGTA.fastq

gunzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_GCCAAT.fastq.gz
fastqc --outdir /bigdata/bioinfo/esmit013/virus_work/fastqc /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_GCCAAT.fastq 
gzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_GCCAAT.fastq

gunzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_GTGAAA.fastq.gz
fastqc --outdir /bigdata/bioinfo/esmit013/virus_work/fastqc /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_GTGAAA.fastq 
gzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane1_pair1_GTGAAA.fastq

gunzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane2_pair1_CTTGTA.fastq.gz
fastqc --outdir /bigdata/bioinfo/esmit013/virus_work/fastqc /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane2_pair1_CTTGTA.fastq
gzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane2_pair1_CTTGTA.fastq

gunzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane2_pair1_GCCAAT.fastq.gz
fastqc --outdir /bigdata/bioinfo/esmit013/virus_work/fastqc /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane2_pair1_GCCAAT.fastq 
gzip /bigdata/bioinfo/esmit013/virus_work/flowcell315_lane2_pair1_GCCAAT.fastq
