#!/usr/bin/bash
##Eric Smith

cd $PBS_O_WORKDIR

module swap perl/5.22.0
module load maker/2.31.8

module load augustus
module load db-ncbi
module load exonerate
module load genemarkHMM
module load ncbi-blast
module load RepeatMasker
module load SNAP
module load wu-blast

maker -RM_off -base pythium_brassicum_P1 -cpus 16
