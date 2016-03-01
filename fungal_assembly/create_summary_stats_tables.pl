#!/usr/bin/perl -w
##Eric Smith

my @fastas;

my $sga_raw_contig_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/sga_raw_data/fungal_assembly_raw_data-contigs.fa';
push (@fastas, $sga_raw_contig_fasta);
my $sga_raw_scaff_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/sga_raw_data/fungal_assembly_raw_data_scaffolds.fasta';
push (@fastas, $sga_raw_scaff_fasta);
my $sga_processed_contig_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/sga_processed_data/fungal_assembly_processed_data-contigs.fa';
push (@fastas, $sga_processed_contig_fasta);
my $sga_processed_scaff_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/sga_processed_data/fungal_assembly_processed_data_scaffolds.fasta';
push (@fastas, $sga_processed_scaff_fasta);
my $soap_raw_contig_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_raw_data/k_95/soapgraph.contig';
push (@fastas, $soap_raw_contig_fasta);
my $soap_raw_scaff_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_raw_data/k_95/soapgraph.scafSeq';
push (@fastas, $soap_raw_scaff_fasta);
my $soap_processed_contig_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_processed_data/k_95/soapgraph.contig'; 
push (@fastas, $soap_processed_contig_fasta);
my $soap_processed_scaff_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_processed_data/k_95/soapgraph.scafSeq';
push (@fastas, $soap_processed_scaff_fasta);
my $velvet_contig_fasta = '/bigdata/bioinfo/nkatiyar/Projects/Assembly_pythium_P1/velvetnew_200contiglen_91/contigs.fa.contigs.fsa';
push (@fastas, $velvet_contig_fasta);
my $velvet_scaff_fasta = '/bigdata/bioinfo/nkatiyar/Projects/Assembly_pythium_P1/velvetnew_200contiglen_91/contigs.fa';
push (@fastas, $velvet_scaff_fasta);

my $base_dir = '/bigdata/bioinfo/esmit013/fungal_assembly/assembly_summary_tables';
if (-d $base_dir)
  {system(qq{rm -rf $base_dir});}
system(qq{mkdir $base_dir});

foreach my $fasta (values @fastas)
  {      
  my $data_type;
  my $construct;
  my $assembler;
  if ($fasta =~ /raw/)
    {$data_type = 'raw';}  
  elsif ($fasta =~ /processed/ or $fasta =~ /velvet/)
    {$data_type = 'processed';} 
    
  if ($fasta =~ /scaf/)
    {$construct = 'scaffold';}  
  elsif ($fasta =~ /91\/contigs.fa$/)
    {$construct = 'scaffold';}
  else
    {$construct = 'contig';}
    
  if ($fasta =~ /sga/)
    {$assembler = 'sga';}
  elsif ($fasta =~ /soap/)
    {$assembler = 'soap';}
  else
    {$assembler = 'velvet';}
    
  my $line_count = 0;
  my %lengths;
  my %contigs;
  my %cum_length;
  open FASTA, "$fasta";
  while (my $line = <FASTA>)
    {
    chomp $line;
    $line_count += 1;
    if ($line =~ /^>/)
      {
      $total_contigs += 1;
      unless ($line_count == 1)
        {
        foreach my $length (0, 500, 1000, 5000, 10000)
          {
          if ($current_length > $length)
            {
            push (@{$lengths{$length}}, $current_length);
            $contigs{$length} += 1;
            $cum_length{$length} += $current_length;  
            }  
          }  
        }
      $current_length = 0;     
      }
    else
      {
      $current_length += length($line);
      $total_length += length($line);   
      }      
    }
  close FASTA;               
  my %n50;
  my %n90;
  my %avg_lengths;
  foreach my $length (0, 500, 1000, 5000, 10000)
    {
    if (${$lengths{$length}}[0])
      {
      ($n50{$length}, $n90{$length}) = get_stats(\@{$lengths{$length}}, $cum_length{$length});  
      $avg_lengths{$length} = $cum_length{$length} / $contigs{$length};
      }
    else
      {
      ($n50{$length}, $n90{$length}, $avg_lengths{$length}, $contigs{$length}) = (0,0,0,0);  
      }    
    }

  my $max_length = (sort {$b <=> $a} values @{$lengths{0}})[0];

  my $sum_file = "${base_dir}/${assembler}_${data_type}_${construct}_summary_stats.txt";
  open SUMMARY, ">$sum_file";  
  print SUMMARY "Number of sequences\t$total_contigs\nMaximum sequence length (bp)\t$max_length\nAverage length (bp)\t$avg_lengths{0}\nN50 (bp)\t$n50{0}\nN90 (bp)\t$n90{0}\n";
  print SUMMARY "\nSequences > 500bp\n\n";
  print SUMMARY "Number of sequences\t$contigs{500}\nAverage length (bp)\t$avg_lengths{500}\nN50 (bp)\t$n50{500}\nN90 (bp)\t$n90{500}\n";
  print SUMMARY "\nSequences > 1Kb\n\n";
  print SUMMARY "Number of sequences\t$contigs{1000}\nAverage length (bp)\t$avg_lengths{1000}\nN50 (bp)\t$n50{1000}\nN90 (bp)\t$n90{1000}\n";
  print SUMMARY "\nSequences > 5Kb\n\n";
  print SUMMARY "Number of sequences\t$contigs{5000}\nAverage length (bp)\t$avg_lengths{5000}\nN50 (bp)\t$n50{5000}\nN90 (bp)\t$n90{5000}\n";
  print SUMMARY "\nSequences > 10Kb \n\n";
  print SUMMARY "Number of sequences\t$contigs{10000}\nAverage length (bp)\t$avg_lengths{10000}\nN50 (bp)\t$n50{10000}\nN90 (bp)\t$n90{10000}\n";
  close SUMMARY;
  print STDOUT "${assembler}_${data_type}_${construct}: $total_length\n";
  }

sub get_stats
  {
  my ($len_ref, $total_len) = @_;
  my $len_sum = 0;
  my $n50;
  my $n90;
  my $n50_found = 'N';
  N_LOOP: foreach my $len (sort{$b <=> $a} values @$len_ref)
    {
    $len_sum += $len;
    if ($len_sum / $total_len >= 0.5)
      {
      unless ($n50_found eq 'Y')
        {
        $n50 = $len;
        $n50_found = 'Y';
        }  
      }
    if ($len_sum / $total_len >= 0.9)
      {
      $n90 = $len;
      last N_LOOP;  
      }    
    }
  return ($n50, $n90);
  }
