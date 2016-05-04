#!/usr/bin/perl -w
##Eric Smith

my $peptide1_file = '/bigdata/bioinfo/esmit013/fungal_assembly/maker/signalp/signal_peptides_1.gff';
my $peptide2_file = '/bigdata/bioinfo/esmit013/fungal_assembly/maker/signalp/signal_peptides_2.gff';
my $peptide_outfile = '/bigdata/bioinfo/esmit013/fungal_assembly/maker/signalp/all_signal_peptides.txt';

open PEP1, "$peptide1_file";
open OUT, ">$peptide_outfile";

while (my $line_1 = <PEP1>)
  {
  next if $line_1 =~ /^#/;
  chomp $line_1;
  $line_1 =~ /(^\S+)\t/;
  my $gene_1 = $1;
  print OUT "$gene_1\n";
  }
close PEP1;

open PEP2, "$peptide2_file";
while (my $line_2 = <PEP2>)
  {
  chomp $line_2;
  next if $line_2 =~ /^#/;
  $line_2 =~ /(^\S+)\t/;
  my $gene_2 = $1;
  print OUT "$gene_2\n";
  }
close PEP2;
close OUT;
