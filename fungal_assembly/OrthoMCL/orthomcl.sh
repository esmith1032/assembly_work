#!/usr/bin/bash
##Eric Smith

cd $PBS_O_WORKDIR

module load orthomcl
module load ncbi-blast
module load mcl

ortho_dir="/bigdata/bioinfo/esmit013/fungal_assembly/maker/orthoMCL"
config_file="${ortho_dir}/orthomcl.config"
blast_file="${ortho_dir}/goodProteins.fasta"
blast_dbfile="${ortho_dir}/goodProteins.db"
blast_out="${ortho_dir}/goodProteins_blast_out.tsv"
similar_seqs="${ortho_dir}/similarSequences.txt"
mcl_input="${ortho_dir}/mclInput"
mcl_output="${ortho_dir}/mclOutput"
groups="${ortho_dir}/groups.txt"
logfile="${ortho_dir}/ortho_mcl.log"
perl /rhome/esmit013/fungal_assembly_scripts/format_fastas_orthomcl.pl

orthomclInstallSchema $config_file

orthomclFilterFasta ${ortho_dir}/proteomes 10 20

makeblastdb -in $blast_file -input_type fasta -out $blast_dbfile -dbtype prot
blastp -db $blast_dbfile -query $blast_file -out $blast_out -outfmt 6 -num_threads 32 -max_target_seqs 100000 -evalue 1

orthomclBlastParser $blast_out ${ortho_dir}/proteomes >> $similar_seqs

orthomclLoadBlast $config_file $similar_seqs

orthomclPairs $config_file $logfile cleanup=no

orthomclDumpPairsFiles $config_file

mcl $mcl_input -o $mcl_output -te 32

orthomclMclToGroups pythium 1000 < $mcl_output > $groups
