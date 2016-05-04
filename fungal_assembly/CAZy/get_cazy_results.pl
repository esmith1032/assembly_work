#!/usr/bin/perl -w
##Eric Smith

my $cazy_dir = "/Research/genomics/fungal_assembly/CAZy_output/";
my $class_counts = "${cazy_dir}cazy_cat_counts.txt";
my $prev_value;
my $py_prev_value;
my @cazy_outs = glob("${cazy_dir}*cazy_hits.txt");
my %hits;
my %no_criteria;
my %all_species;
my %cats;
my %plot;

foreach my $caz (@cazy_outs)
  {
  $caz =~ /\S+\/(\w+)_cazy_hits.txt/;
  my $species = $1;
  unless ($all_species{$species})
    {$all_species{$species} = 'Y';}
  my $filtered_file = "${cazy_dir}${species}_cazy_filtered_hits.txt";
  open CAZ, "$caz";
  open FILT, ">$filtered_file";
  while (my $line = <CAZ>)
    {
    chomp $line;  
    my @values = split /\t/, $line;
    $values[1] =~ /(\w+)\.hmm/;
    my $hmm = $1;
    if ($values[2] < 1e-5 and $values[4] - $values[3] > 80 and $values[5] > 0.3)
      {
      print FILT "$values[0]\t$values[1]\n";  
      if ($hits{$hmm}{$species})
        {$hits{$hmm}{$species}++;}
      else
        {$hits{$hmm}{$species} = 1;}    
      }
    elsif ($values[2] < 1e-3 and $values[4] - $values[3] < 80 and $values[5] > 0.3)
      {
      print FILT "$values[0]\t$values[1]\n";  
      if ($hits{$hmm}{$species})
        {$hits{$hmm}{$species}++;}
      else
        {$hits{$hmm}{$species} = 1;}    
      }
    else
      {
      if ($no_criteria{$species})
        {$no_criteria{$species}++;}
      else
        {$no_criteria{$species} = 1;}    
      }       
    }  
  close CAZ;
  close FILT;
  }

open CATS, ">$class_counts";
print CATS "Species\tCAZy_model\tHits\n";
foreach my $cat (sort {lc $a cmp lc $b} keys %hits)
  {
  $cat =~ /(\D+)/;
  my $cat_abb = $1;
  push @{$cats{$cat_abb}}, $cat;    
  foreach my $new_species (keys %all_species)
    {
    if ($hits{$cat}{$new_species})
      {
      print CATS "$new_species\t$cat\t$hits{$cat}{$new_species}\n";  
      }
    else
      {
      print CATS "$new_species\t$cat\t0\n";  
      }    
    }  
  }

foreach my $no_new_species (keys %all_species)
  {
  if ($no_criteria{$no_new_species})  
    {
    print CATS "$no_new_species\tNC\t$no_criteria{$no_new_species}\n";  
    }
  else
    {
    print CATS "$no_new_species\tNC\t0\n";  
    }  
  }
close CATS;

foreach my $check_cat (keys %cats)
  {
  for (my $j = 0; $j < scalar @{$cats{$check_cat}}; $j++)
    {
    my $plot_cat = ${$cats{$check_cat}}[$j];
    $plot{all}{$plot_cat} = 'N';
    $plot{py}{$plot_cat} = 'N';
    my $species_count = 0;
    my $py_species_count = 0;
    foreach my $plot_spec (keys %all_species)
      {
      $species_count++;
      if ($plot_spec =~ /^py/)
        {$py_species_count++;}
      my $current_value = 0;
      if ($hits{$plot_cat}{$plot_spec})
        {
        $current_value = $hits{$plot_cat}{$plot_spec};  
        }
      if ($species_count == 1)
        {$prev_value = $current_value;}  
      if ($plot_spec =~ /^py/ and $py_species_count == 1)
        {$py_prev_value = $current_value;}
      if ($current_value != $prev_value and $plot{all}{$plot_cat} eq 'N')
        {
        $plot{all}{$plot_cat} = 'Y';  
        }
      if ($plot_spec =~ /^py/ and $current_value != $py_prev_value and $plot{py}{$plot_cat} eq 'N')
        {
        $plot{py}{$plot_cat} = 'Y';  
        }      
      }  
    }  
  }

foreach my $short_cat (keys %cats)
  {
  my $broad_file = "${cazy_dir}${short_cat}_matrix.txt";
  my $py_broad = "${cazy_dir}py_${short_cat}_matrix.txt";
  open BROAD, ">$broad_file";
  open PYBROAD, ">$py_broad";
  for (my $i = 0; $i < scalar @{$cats{$short_cat}}; $i++)
    {
    if ($plot{all}{${$cats{$short_cat}}[$i]} eq 'Y')
      {
      print BROAD "\t${$cats{$short_cat}}[$i]";
      }
    if ($plot{py}{${$cats{$short_cat}}[$i]} eq 'Y')
      {
      print PYBROAD "\t${$cats{$short_cat}}[$i]";
      }  
    }
  print BROAD "\n";
  print PYBROAD "\n";
  foreach my $spec (sort keys %all_species)
    {
    my $short_spec;  
    if ($spec =~ /(\w\w)\w+_(\w)\w+_(\w)\w+/)
      {
      $short_spec = "$1$2$3";  
      }
    elsif ($spec =~ /(\w\w)\w+_(\w)(\w)\w+/) 
      {
      $short_spec = "$1$2$3";  
      }   
    print BROAD "$short_spec";
    if ($spec =~ /^py/)
      {
      print PYBROAD "$short_spec";  
      }
    for (my $k = 0; $k < scalar @{$cats{$short_cat}}; $k++)
      {
      if ($hits{${cats{$short_cat}}[$k]}{$spec} and $plot{all}{${cats{$short_cat}}[$k]} eq 'Y')  
        {
        print BROAD "\t$hits{${cats{$short_cat}}[$k]}{$spec}";
        if ($spec =~ /^py/ and $plot{py}{${cats{$short_cat}}[$k]} eq 'Y')
          {
          print PYBROAD "\t$hits{${cats{$short_cat}}[$k]}{$spec}";            
          }
        }
      elsif ($plot{all}{${cats{$short_cat}}[$k]} eq 'Y')
        {
        print BROAD "\t0";
        if ($spec =~ /^py/ and $plot{py}{${cats{$short_cat}}[$k]} eq 'Y')
          {
          print PYBROAD "\t0"; 
          }
        }    
      }  
    print BROAD "\n";
    if ($spec =~ /^py/)
      {print PYBROAD "\n";}
    }     
  close BROAD;
  close PYBROAD;
  }
