#!/usr/bin/perl -w
##Eric Smith

use strict;

my %stats;
my $fasta_file = '/bigdata/bioinfo/esmit013/virus_work/trinity_lane2_CTTGTA/Trinity.fasta';
open FASTA, "$fasta_file";
while (my $line = <FASTA>)
  {
  chomp $line;
  if ($line =~ />TRINITY_DN(\d+_c\d+_g\d+)_i\d+\s+len=(\d+)/)
    {
    if ($stats{$1})
      {
      $stats{$1}{isoforms} += 1;
      $stats{$1}{length} += $2;  
      }
    else
      {
      $stats{$1}{isoforms} = 1;
      $stats{$1}{length} = $2;  
      }    
    }  
  }
close FASTA;

my $summary_file = '/bigdata/bioinfo/esmit013/virus_work/trinity_lane2_CTTGTA/trinity_summary.txt';
open SUMMARY, ">$summary_file";  
print SUMMARY "gene\tisoforms\ttotal_len\tavg_len\n";
foreach my $key (sort {$stats{$b}{isoforms} <=> $stats{$a}{isoforms}} keys %stats)
  {
  my $avg_len = $stats{$key}{length}/$stats{$key}{isoforms};
  print SUMMARY "$key\t$stats{$key}{isoforms}\t$stats{$key}{length}\t$avg_len\n";  
  }
