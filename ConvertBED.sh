#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out
##SBATCH --mail-type=END
##SBATCH --mail-user=<yourname>@usc.edu

# enter your job environment parameters here
module load plink2/alpha-6.5

# merge chromosome vcfs into single vcf
#plink2 --vcf AllCHR_GL_allLoci_realign_IGP099_IMP_DR2099_dummyID.vcf.gz --make-bed --out AllCHR_GL_allLoci_realign_IGP099_IMP_DR2099_dummyID_binary_fileset

#plink2 --vcf AllCHR_ExptIMPfilt_HapParent_Merge_Filt_dummyID.vcf.gz --make-bed --out AllCHR_ExptIMPfilt_HapParent_Merge_Filt_dummyID_binary_fileset

plink2 --vcf AllCHR_ExptIMPfilt_plus66_Merge_Filt_dummyID.vcf.gz --make-bed --out AllCHR_ExptIMPfilt_plus66_Merge_Filt_dummyID_binary_fileset

