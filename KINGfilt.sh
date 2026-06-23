#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --mem=32G
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out
#SBATCH --array=1-14
##SBATCH --mail-type=END
##SBATCH --mail-user=<yourname>@usc.edu

# enter your job environment parameters here

export config=/scratch1/ckenkel/ApalWGS/Expt/GLtest/chromOZ.txt
export CHR=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)


FASTA=/project/ckenkel_26/RefSeqs/ApalGenome/ApalmGenome_vSanger/GCA_964030605.1/GCA_964030605.1_jaAcrPala1.1_genomic.fna

# drop low allele count variants (noninformative)
# Align the alleles to the reference genome, 
# and keep only biallelic records
#bcftools view -e 'INFO/AC<3 | (INFO/AN-INFO/AC)<3' ${CHR}_AllCHR_ExptIMPfilt_HapParent_Merge.vcf.gz -Ou | \
#bcftools norm -f ${FASTA} -c ws -Ou | \
#bcftools view -m 2 -M 2 -W=tbi -Oz -o ${CHR}_AllCHR_ExptIMPfilt_HapParent_Merge_Filt.vcf.gz

bcftools view -e 'INFO/AC<3 | (INFO/AN-INFO/AC)<3' ${CHR}_AllCHR_ExptIMPfilt_plus66_Merge.vcf.gz -Ou | \
bcftools norm -f ${FASTA} -c ws -Ou | \
bcftools view -m 2 -M 2 -W=tbi -Oz -o ${CHR}_AllCHR_ExptIMPfilt_plus66_Merge_Filt.vcf.gz

