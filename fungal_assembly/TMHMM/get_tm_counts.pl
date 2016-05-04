#!/usr/bin/perl -w
##Eric Smith

my $tm_file = '/bigdata/bioinfo/esmit013/fungal_assembly/maker/tmhmm/tmhmm.out';
my $tm_genes_file = '/bigdata/bioinfo/esmit013/fungal_assembly/maker/tmhmm/tm_genes.txt';
my $no_tm_genes_file = '/bigdata/bioinfo/esmit013/fungal_assembly/maker/tmhmm/no_tm_genes.txt';

my $tm_genes = 0;
my $no_tm_genes = 0;

open TM, "$tm_file";
open TMGENES, ">$tm_genes_file";
open NOTM, ">$no_tm_genes_file";

while (my $line = <TM>)
  {
  chomp $line;
  if ($line =~ /^#\s+(\S+)\s+Number of predicted TMHs:\s+(\d+)/)
    {
    my $gene = $1;
    my $tms = $2;
    if ($tms == 0)
      {
      print NOTM "$gene\t$tms\n";
      $no_tm_genes++;  
      }
    else
      {
      print TMGENES "$gene\t$tms\n";
      $tm_genes++;  
      }    
    }
  }
print STDOUT "tm_genes: $tm_genes\nno_tm_genes: $no_tm_genes\n"; 
