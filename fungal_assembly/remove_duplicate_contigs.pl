#!/usr/bin/perl -w
##Eric Smith

my $fasta_file = '/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout/merged_assembly_cap3_singles_contigs_no_nulls_tr.fasta';
my %scaffolds;

open FASTA, "$fasta_file";
my $head;
my $body;
my $line_count = 0;
while (my $line = <FASTA>)
  {
  $line_count++;
  chomp $line;
  if ($line =~ /^>/)
    {
    unless ($line_count == 1)
      {
      $scaffolds{$head}{seq} = $body;
      $scaffolds{$head}{len} = length($body);
      }
    $head = $line;  
    $body = '';
    }
  else
    {
    $body .= $line;  
    }    
  }
$scaffolds{$head}{seq} = $body;
$scaffolds{$head}{len} = length($body);
close FASTA;

my $new_file = '/bigdata/bioinfo/esmit013/fungal_assembly/repeat_scout_no_dups/merged_assembly_no_dups.fasta';
open NEW, ">$new_file";
my $scaffs_removed = 0;
my $len_removed = 0;
my $processed = 0;
foreach my $scaffold (sort {$scaffolds{$a}{len} <=> $scaffolds{$b}{len}} keys %scaffolds)
  {
  $processed++;
  if ($processed % 100 == 0)
    {
    my $time = localtime();
    print STDOUT "$time\t$processed\n";
    }
  my $contained = 'N';  
  my $current_seq = $scaffolds{$scaffold}{seq};
  CHECK_LOOP: foreach my $new_scaff (sort {$scaffolds{$a}{len} <=> $scaffolds{$b}{len}} keys %scaffolds)
    {
    next CHECK_LOOP if $new_scaff eq $scaffold;
    if ($scaffolds{$new_scaff}{seq} =~ /$current_seq/)
      {
      $contained = 'Y';
      $scaffs_removed++;
      $len_removed += $scaffolds{$scaffold}{len};
      last CHECK_LOOP;
      }    
    }  
  unless ($contained eq 'Y')
    {
    print NEW "$scaffold\n$scaffolds{$scaffold}{seq}\n";  
    }
  delete $scaffolds{$scaffold};
  } 
close NEW;  
print STDOUT "Scaffolds removed: $scaffs_removed\nBases removed: $len_removed\n";
