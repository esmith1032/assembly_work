#!/usr/bin/perl -w
##Eric Smith

my $proteome_dir = "/bigdata/bioinfo/esmit013/fungal_assembly/genomes/proteomes/";
my @proteomes = glob("${proteome_dir}*.fasta");

foreach my $prot (@proteomes)
  {
  $prot =~ /\S+\/(\S+)_proteins.fasta/;  
  my $species = $1;
  my $taxon;
  if ($species =~ /(\w\w)\w+_(\w)\w+_(\w)\w+/)
    {
    $taxon = "$1$2$3"; 
    }
  elsif ($species =~ /(\w\w)\w+_(\w)(\w)\w+/)
    {
    $taxon = "$1$2$3";  
    }  
  my $outfile = "/bigdata/bioinfo/esmit013/fungal_assembly/maker/orthoMCL/proteomes/${taxon}.fasta";
  open NEW, ">$outfile";
  open PROT, "$prot";
  my $gene_count = 0;
  while (my $line = <PROT>)
    {
    chomp $line;
    if ($line =~ /^>/)
      {
      $gene_count++;  
      $line = ">$taxon|$gene_count";  
      }  
    print NEW "$line\n";
    }
  close NEW;
  close PROT;  
  }
