#!/usr/bin/perl -w
#Eric Smith

use DBI;
prepareDbh();

our $contig_table = "sga_virus_assembly_contigs";
our $scaffold_table = "sga_virus_assembly_scaffolds";

my $fq_dir = '/Research/genomics/fungal_assembly/';

$dbh->do(qq{drop table if exists $contig_table});
$dbh->do(qq{create table $contig_table
	          (svac_id int auto_increment primary key,
		         contig varchar(20),
		         contig_len int,
		         index(contig))});

$dbh->do(qq{drop table if exists $scaffold_table});
$dbh->do(qq{create table $scaffold_table
	        (svas_id int auto_increment primary key,
		       scaffold varchar(20),
		       scaffold_len int,
		       avg_cov decimal(8,1),
		       index(scaffold))});

my $correction_k = 31;
my $min_overlap = 45;
my $assemble_overlap = 111;
my $trim_len = 150;
my $min_contig_len = 50;
my $min_pairs = 5;

my $work_dir = '/Research/genomics/fungal_assembly';

chdir $work_dir;    

my $read_len = 100;

my $log = $work_dir . '/sga.log'; 	

my $fq_1 = $fq_dir . '/flowcell271_lane5_pair1.fastq';
my $fq_2 = $fq_dir . '/flowcell271_lane5_pair3.fastq';

my $run_id = 'fungal_assembly';
my $preprocess_fq = $work_dir . '/' . $run_id . '_pp.fq'; 	
my $error_cor_fq = $work_dir . '/' . $run_id . '_ec.fq'; 	
my $filtered_fasta = $work_dir . '/' . $run_id . '_filtered.fasta'; 
my $assembly_gz = $work_dir . '/' . $run_id . '_filtered.asqg.gz'; 
my $contigs_fasta = $work_dir . '/' . $run_id . '-contigs.fa'; 
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

my $time = localtime;
print STDOUT "$time\tBeginning SGA\n";

system(qq{sga preprocess --pe-mode 1 -o $preprocess_fq $fq_1 $fq_2 2>&1 >> $log});
system(qq{sga index --no-reverse $preprocess_fq 2>&1 >> $log});
system(qq{sga correct -k $correction_k --learn  -o $error_cor_fq $preprocess_fq 2>&1 >> $log});
system(qq{sga correct --algorithm=overlap --threads=100 -r 3 -o $error_cor_fq $preprocess_fq 2>&1 >> $log});
system(qq{sga index $error_cor_fq 2>&1 >> $log});
system(qq{sga filter -x 2 -o $filtered_fasta $error_cor_fq 2>&1 >> $log});
system(qq{sga overlap -m $min_overlap $filtered_fasta 2>&1 >> $log});
system(qq{sga assemble -r 25 -g .05 -m $assemble_overlap --min-branch-length $trim_len -o $run_id $assembly_gz 2>&1 >> $log});

$time = localtime;
print STDOUT "$time\tMapping contigs\n";

system(qq{bwa index $contigs_fasta 2>&1 >> $log});
system(qq{bwa mem -t 2 -k 10 $contigs_fasta $fq_1 $fq_2 > $contig_sam 2>> $log});  

system(qq{bwa aln $contigs_fasta $fq_1 > $sai_1 2>&1 >> $log});
system(qq{bwa aln $contigs_fasta $fq_2 > $sai_2 2>&1 >> $log});
system(qq{bwa sampe $contigs_fasta $sai_1 $sai_2 $fq_1 $fq_2 - > $contig_sam 2>&1 >> $log});

system(qq{perl /Research/gambiae/tapl/remove_bad_sam_lines.pl $contig_sam $cleaned_sam 2>&1 >> $log});
system(qq{samtools view -Sb -o $cleaned_bam $cleaned_sam 2>&1 >> $log});

$time = localtime;
print STDOUT "$time\tScaffolding\n";

system(qq{sga-bam2de_edited.pl -n $min_pairs -m 200 --prefix $run_id $cleaned_sam 2>&1 >> $log});
system(qq{sga-astat.py -m $min_contig_len $cleaned_bam > $astat 2>> $log});
system(qq{sga scaffold -m $min_contig_len -a $astat -o $scaffold --pe $de $contigs_fasta 2>&1 >> $log});
system(qq{sga scaffold2fasta --use-overlap --write-unplaced -m $min_contig_len -a $graph -r $read_len -o $scaffold_fasta $scaffold 2>&1 >> $log});

open CONTIGS, "$contigs_fasta";
while (my $line = <CONTIGS>)
  {
  if ($line =~ />(\S+)\s+(\d+)/)
    {
	  $dbh->do(qq{insert into $contig_table
		            values
		            (null, '$1', $2)});
    }	
  }
close CONTIGS;

system(qq{bwa index $scaffold_fasta 2>&1 >> $log});
system(qq{bwa mem -t 2 -k 10 $scaffold_fasta $fq_1 $fq_2 > $scaffold_sam 2>> $log});  

open SCAFFOLD_SAM, "$scaffold_sam";

my %cum_coverages = ();
while (my $line = <SCAFFOLD_SAM>)
  {
  unless ($line =~ /^@/)
    {
    chomp $line;
    my @values = split /\t/, $line;
  
    my $aln_len = 0;
    while ($values[5] =~ /(\d+)([MIDNSHPX=])/g)
      {
      my $len = $1;
      my $tag = $2;
      if ($tag eq 'M')
        {$aln_len += $len;}
      }
    $cum_coverages{$values[2]} += $aln_len;
    }
  }
close SCAFFOLD_SAM;

open SCAFFOLDS, "$scaffold_fasta";
while (my $line = <SCAFFOLDS>)
  {
  if ($line =~ />(\S+)\s+(\d+)/)
    {
	  $dbh->do(qq{insert into $scaffold_table
		            values
		            (null, '$1', $2, $cum_coverages{$1} / $2)});
    }	
  }
close SCAFFOLDS;

$time = localtime;
print STDOUT "$time\tDone\n";

sub reverse_comp
  {
  my ($seq) = @_;
  $seq = reverse($seq);
  $seq =~ tr/ACGTacgt/TGCAtgca/;  
  return $seq;
  }

sub prepareDbh
  {
	my $username = "david";
	my $password = "drosophila";
	my $database = "genomics_work";


	my $dsn = "DBI:mysql:$database:localhost";
	our $dbh = DBI->connect($dsn,$username,$password);
  }
