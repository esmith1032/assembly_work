#!/usr/bin/perl -w
#Eric Smith

my ($data_type) = @ARGV;

my $correction_k = 31;
my $min_overlap = 45;
my $assemble_overlap = 111;
my $trim_len = 150;
my $min_contig_len = 50;
my $min_pairs = 5;

my $work_dir = '/bigdata/bioinfo/esmit013/fungal_assembly/sga_' . $data_type . '_data';

system(qq{cd $work_dir});    

my $fq_1 = $work_dir . '/flowcell271_lane5_pair1_val_1.fq';
my $fq_2 = $work_dir . '/flowcell271_lane5_pair3_val_2.fq';
if ($data_type eq 'raw')
  {
  $fq_1 = $work_dir . '/flowcell271_lane5_pair1.fastq';
  $fq_2 = $work_dir . '/flowcell271_lane5_pair3.fastq';  
  }

my $run_id = 'fungal_assembly_'. $data_type . '_data';
my $p = $work_dir . '/' . $run_id;
my $preprocess_fq = $work_dir . '/' . $run_id . '_pp.fq'; 	
my $error_cor_fq = $work_dir . '/' . $run_id . '_ec.fq'; 	
my $filtered_fasta = $work_dir . '/' . $run_id . '_filtered.fasta'; 
my $assembly_gz = $work_dir . '/' . $run_id . '_filtered.asqg.gz'; 
my $contigs_fasta = $work_dir . '/' . $run_id . '-contigs.fa'; 
my $merge_file = $work_dir . '/' . $run_id . '-merged.fa';
my $graph = $work_dir . '/' . $run_id . '-graph.asqg.gz'; 

my $sai_1 = $work_dir . '/' . $run_id . '_1.sai'; 	
my $sai_2 = $work_dir . '/' . $run_id . '_2.sai'; 	
my $contig_sam = $work_dir . '/' . $run_id . '_contigs.sam'; 	
my $scaffold_sam = $work_dir . '/' . $run_id . '_scaffolds.sam'; 	
my $cleaned_sam = $work_dir . '/' . $run_id . '_cleaned.sam'; 	
my $cleaned_bam = $work_dir . '/' . $run_id . '_cleaned.bam'; 	

my $de = $work_dir . '/' . $run_id . '.de'; 	
my $astat = $work_dir . '/' . $run_id . '.astat'; 	
my $scaffold = $work_dir . '/' . $run_id . '.scaf'; 	
my $scaffold_fasta = $work_dir . '/' . $run_id . '_scaffolds.fasta'; 	

##Error Correction
system(qq{sga preprocess --pe-mode 1 -o $preprocess_fq $fq_1 $fq_2});
system(qq{sga index -a ropebwt -t 8 --no-reverse $preprocess_fq -p $p});
system(qq{sga correct -k $correction_k --learn -t 8 -o $error_cor_fq $preprocess_fq});

##Contig assembly
system(qq{sga index -a ropebwt $error_cor_fq -p $p});
system(qq{sga filter -x 2 -t 8 -o $filtered_fasta $error_cor_fq});
system(qq{sga fm-merge -m $min_overlap -t 8 -o $merge_file $filtered_fasta});
system(qq{sga index -d 1000000 -t 8 $merge_file -p $p});
system(qq{sga rmdup -t 8 $merge_file});
system(qq{sga overlap -m $min_overlap $merge_file});
system(qq{sga assemble -r 25 -g .05 -m $assemble_overlap --min-branch-length $trim_len -o $run_id $assembly_gz});

##Scaffolding
##The following BWA steps are done in place of using sga-align, as sga-align does not install with the default SGA installation
system(qq{bwa index $contigs_fasta});
system(qq{bwa mem -t 2 -k 10 $contigs_fasta $fq_1 $fq_2 > $contig_sam});  

system(qq{bwa aln $contigs_fasta $fq_1 > $sai_1});
system(qq{bwa aln $contigs_fasta $fq_2 > $sai_2});
system(qq{bwa sampe $contigs_fasta $sai_1 $sai_2 $fq_1 $fq_2 - > $contig_sam});

system(qq{samtools view -Sb -o $cleaned_bam $contig_sam});

system(qq{sga-bam2de.pl -n $min_pairs --prefix $run_id $contig_sam});
system(qq{sga-astat.py -m $min_contig_len $cleaned_bam > $astat});
system(qq{sga scaffold -m $min_contig_len -a $astat -o $scaffold --pe $de $contigs_fasta})
