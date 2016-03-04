#!/usr/bin/perl -w
##Eric Smith

my $overall_summary_file = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_summary_stats.txt';
open STATS, ">$overall_summary_file";
print STATS "K\traw_scaffold_num\traw_assembled_bases\traw_N50\traw_max_len\tprocessed_scaffold_num\tprocessed_assem
bled_bases\tprocessed_N50\tprocessed_max_len\n";
for (my $k = 35; $k <=99; $k += 4)
  {
  my $raw_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_raw_data/k_' . $k . '/soapgraph.scafSeq';
  my $raw_summary = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_raw_data/k_' . $k . '/assembly_stats.txt';
  my $processed_fasta = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_processed_data/k_' . $k . '/soapgraph.scafSe
q';
  my $processed_summary = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_processed_data/k_' . $k . '/assembly_stats
.txt';

  open RAW_SUM, ">$raw_summary";
  open PRO_SUM, ">$processed_summary";
  open RAW, "$raw_fasta";
  open PROCESSED, "$processed_fasta";

  my @raw_lengths;
  my $current_raw_length;
  my $raw_total_length = 0;
  my $raw_line_count = 0;
  my $raw_total_contigs = 0;
    
  my @processed_lengths;
  my $current_processed_length;
  my $processed_total_length = 0;
  my $processed_line_count = 0;
  my $processed_total_contigs = 0;
  
  while (my $raw_line = <RAW>)
    {
    chomp $raw_line;
    $raw_line_count += 1;
    if ($raw_line =~ /^>/)
      {
      $raw_total_contigs += 1;
      unless ($raw_line_count == 1)
        {
        push @raw_lengths, $current_raw_length;
        }
      $current_raw_length = 0;     
      }
    else
      {
      $current_raw_length += length($raw_line);
      $raw_total_length += length($raw_line);   
      }      
    }
  push @raw_lengths, $current_raw_length;
  while (my $processed_line = <PROCESSED>)
    {
    chomp $processed_line;
    $processed_line_count += 1;
    if ($processed_line =~ /^>/)
      {
      $processed_total_contigs += 1;
      unless ($processed_line_count == 1)
        {
        push @processed_lengths, $current_processed_length;
        }
      $current_processed_length = 0;     
      }
    else
      {
      $current_processed_length += length($processed_line);
      $processed_total_length += length($processed_line);   
      }      
    }
  push @processed_lengths, $current_processed_length;
  my $raw_n50;
  my $raw_len_sum = 0;
  RAW_N50_LOOP: foreach my $raw_len (sort{$a <=> $b} values @raw_lengths)
    {
    $raw_len_sum += $raw_len;
    if ($raw_len_sum >= $raw_total_length / 2)
      {
      $raw_n50 = $raw_len;
      last RAW_N50_LOOP;  
      }  
    }

  my $processed_n50;
  my $processed_len_sum = 0;
  PROCESSED_N50_LOOP: foreach my $processed_len (sort{$a <=> $b} values @processed_lengths)
    {
    $processed_len_sum += $processed_len;
    if ($processed_len_sum >= $processed_total_length / 2)
      {
      $processed_n50 = $processed_len;
      last PROCESSED_N50_LOOP;  
      }  
    }
    
  my $raw_maximum_length = (sort {$b <=> $a} values @raw_lengths)[0];
  my $raw_avg_len = $raw_total_length / $raw_total_contigs;

  my $processed_maximum_length = (sort {$b <=> $a} values @processed_lengths)[0];
  my $processed_avg_len = $processed_total_length / $processed_total_contigs;

  print STATS "$k\t$raw_total_contigs\t$raw_total_length\t$raw_n50\t$raw_maximum_length\t$processed_total_contigs\t$
processed_total_length\t$processed_n50\t$processed_maximum_length\n";
  print RAW_SUM "Contig_number:\t$raw_total_contigs\nN50:\t$raw_n50\nAverage_length:\t$raw_avg_len\nTotal_length:\t$
raw_total_length\nMaximum_length:\t$raw_maximum_length\n";
  print PRO_SUM "Contig_number:\t$processed_total_contigs\nN50:\t$processed_n50\nAverage_length:\t$processed_avg_len
\nTotal_length:\t$processed_total_length\nMaximum_length:\t$processed_maximum_length\n";
  close RAW_SUM;
  close PRO_SUM;
  close RAW;
  close PROCESSED;
  }
