#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=01:00:00
#SBATCH --mem=32G
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out
##SBATCH --mail-type=END
##SBATCH --mail-user=<yourname>@usc.edu

# enter your job environment parameters here


# estimate kinship
#king -b AllCHR_ExptIMPfilt_HapParent_Merge_Filt_dummyID_binary_fileset.bed --kinship --cpus 1

#king -b AllCHR_GL_allLoci_realign_IGP099_IMP_DR2099_dummyID_binary_fileset.bed --kinship

#king -b AllCHR_ExptIMPfilt_plus66_Merge_Filt_dummyID_binary_fileset.bed --kinship

#plink2 --bfile AllCHR_ExptIMPfilt_HapParent_Merge_Filt_dummyID_binary_fileset --make-king square --make-king-table

#plink2 --bfile AllCHR_GL_allLoci_realign_IGP099_IMP_DR2099_dummyID_binary_fileset --make-king square --make-king-table

plink2 --bfile AllCHR_ExptIMPfilt_plus66_Merge_Filt_dummyID_binary_fileset --make-king square --make-king-table
