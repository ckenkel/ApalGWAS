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


# merge chromosome vcfs into single vcf
#bcftools concat -f cat_list -W=tbi -Oz -o AllCHR_ExptIMPfilt_HapParent_Merge_Filt.vcf.gz

#bcftools concat -f cat_list2 -W=tbi -Oz -o AllCHR_GL_allLoci_realign_IGP099_IMP_DR2099.vcf.gz

bcftools concat -f cat_list3 -W=tbi -Oz -o AllCHR_ExptIMPfilt_plus66_Merge_Filt.vcf.gz
