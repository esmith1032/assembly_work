Assembly workflow

All of the scripts and additional files for running the following steps are in directories named for the program used.

Steps following preprocessing, assembly, and CAP3 re-assembly:

1.	Repeat masking with RepeatScout (all subsequent steps are performed using the repeat-masked assembly)

2.	Gene prediction with MAKER (subsequent steps use predicted amino acid sequence, unless otherwise noted)

3.	Run BUSCO to check for core Eukaryotic genome

4.	Run SignalP to predict secreted proteins

5.	Run TMHMM to predict proteins with transmembrane domains

6.	BLAST against PHI-Base (Pathogen-Host Interaction)

7.	BLAST against NCBI/nr

8.	BLAST against Uniprot database

9.	OrthoMCL to cluster orthologous proteins with other related species’ proteomes

10. CAZy classification/analysis
