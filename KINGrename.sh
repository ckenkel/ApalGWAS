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
#bcftools annotate --rename-chrs CHR_list_dummy AllCHR_ExptIMPfilt_HapParent_Merge_Filt.vcf.gz -W=tbi -Oz -o AllCHR_ExptIMPfilt_HapParent_Merge_Filt_dummyID.vcf.gz

#bcftools annotate --rename-chrs CHR_list_dummy AllCHR_GL_allLoci_realign_IGP099_IMP_DR2099.vcf.gz -W=tbi -Oz -o AllCHR_GL_allLoci_realign_IGP099_IMP_DR2099_dummyID.vcf.gz

bcftools annotate --rename-chrs CHR_list_dummy AllCHR_ExptIMPfilt_plus66_Merge_Filt.vcf.gz -W=tbi -Oz -o AllCHR_ExptIMPfilt_plus66_Merge_Filt_dummyID.vcf.gz
