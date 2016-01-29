#!/usr/bin/perl -w
##Eric Smith

#usage: perl run_soap_k_51_91.pl processed
##perl run_soap_k_51_91.pl raw

my ($data_type) = @ARGV;

my $base_dir = '/bigdata/bioinfo/esmit013/fungal_assembly/soap_' . $data_type . '_data/';
my $config_file = $base_dir . 'soap.config';

for (my $k = 51; $k <= 99; $k += 4)
  {
  my $k_dir = $base_dir . 'k_' . $k . '/';
  if (-d $k_dir)
    {system(qq{rm -rf $k_dir});}
  system(qq{mkdir $k_dir});
  
  my $o_file = $k_dir . '/k_' . $k . '.o';
  my $e_file = $k_dir . '/k_' . $k . '.e';
  my $sh_file = $k_dir . 'soap_k_' . $k . '.sh';
  open SH, ">$sh_file"; 
  print SH "module load SOAPdenovo2\nSOAPdenovo-127mer all -s $config_file -K $k -o ${k_dir}/soapgraph";
  system(qq{chmod +x $sh_file});
  system(qq{qsub $sh_file -l mem=512gb -q highmem -o $o_file -e $e_file});
  }

