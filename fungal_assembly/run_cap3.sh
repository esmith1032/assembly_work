##To merge velvet and soap assemblies; can be used to reassmble velvet and soap assemblies individually, as well

module load cap3

cat velvet_assembly.fasta soap_assembly.fasta > merged_assembly.fasta
cap3 /bigdata/bioinfo/esmit013/fungal_assembly/CAP3/merged_assembly.fasta
