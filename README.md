# Genomic regions associated with endosymbiont shuffling and areal growth in the endangered elkhorn coral, Acropora palmata
Biodiversity losses continue to outpace traditional management, underscoring the need for genetic interventions to bolster rates of natural adaptation. We undertook a genome-wide association study to investigate the genomic basis of areal growth, endosymbiont association, and thermal tolerance traits by subjecting replicate ramets of 156 genets of Acropora palmata to a one-month long thermal stress experiment. This repository contains the bioinformatic and statistical scripts necessary to re-create analyses, as well as raw input data used to generate figures. Raw FASTQ reads can be obtained from NCBI’s SRA under BioProject PRJNA1078365. 

Files in this repository 
-----------

1. Apal_GWAS.txt: Annotated bioinformatic workflow for genotyping and imputation (including read QC, filtering and genotype calls) and GWAS (accounting for relatedness and dominant endosymbiont type). Custom shell scripts used for the genotyping an imputation pipeline can be found in the sister repository at https://github.com/ckenkel/ApalConGen and additional shell scripts used for GWAS analysis are listed below. Installation instructions are given for other published softwares. Note that this pipeline was written for a cluster which uses a SLURM scheduler. 
	- Additional Shell Scripts specific to GWAS analysis:
	  - KINGsub.sh
	  - KINGmerge.sh
	  - KINGfilt.sh
	  - KINGcat.sh
	  - ConvertBED.sh
	  - KINest.sh
	  - KINGmerge.sh
	  - KINGrename.sh
	  - KINest.sh
	  
	- Input files:
	  - SamplesKINGuniq.txt
      - Phenotypes.tab
	  - AllCHR_ExptIMPfilt_plus66_Merge_Filt_dummyID_binary_fileset_KINGrelate_GEMMA_plusSelfs.tab
	
2. RuthGates_SiteMap_vGWAS.qmd: Annotated R script for generating site map as shown in Figure 1
   
3. RuthGates_SurvivalGrowthSymTypesQC_00.qmd: Annotated R script for QC of trait data and integration of qPCR data for symbiont typing. 
	- Input file: GMMetadataFinal_FinalMetaData_29Apr24.csv
	- Input file: RG_sym_host_Tech_Reps_Averaged_NewCorrectionCalc_plusCV.csv
    - Output file: traitsFiltered_SymTypeSubset.rds 

4. RuthGates_SurvivalGrowthSymTypesStats_01.qmd and RuthGates_SurvivalGrowthSymTypesPlots_02.qmd: Annotated R scripts for visualization and statistical analyses of QC-ed trait data as well as plotting traits as a function of genotype dosage post-GWAS. Script to generate normalized phenotypes for GWAS.
	- Input file: traitsFiltered_SymTypeSubset.rds 
	- Input file: RelatednessKey.csv
	- Input file: GWAS_SNPsOfInterest.vcf.gz
	- Output file: Phenotypes.tab

5. ApalmMorphologicalPlasticity_SAgrowth.R: Annotated R script for QC, visualization and statistical analyses of surface area growth in A. palmata field transplants.
	- Input file: ApalmMorphologicalPlasticity_rready.csv

