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


export HARDCALL=/scratch1/ckenkel/ApalWGS/Haplotype/vcfSanger/

# merge shallow and hap vcfs into single vcf by chromosome (done to speed up processing time)

#bcftools merge ${CHR}_GL_allLoci_realign_IGP099_IMP_DR2099.vcf.gz ${HARDCALL}${CHR}_ApalHap.KINGSamp.vcf.gz -m both -i IDV:sum,DP:sum,DP4:sum,AD:sum,MQ:avg -W=tbi -Oz -o ${CHR}_AllCHR_ExptIMPfilt_HapParent_Merge.vcf.gz

bcftools merge ${CHR}_GL_allLoci_realign_IGP099_IMP_DR2099.vcf.gz ${HARDCALL}${CHR}_ApalHap.KINGuniqSamp.vcf.gz -m both -i IDV:sum,DP:sum,DP4:sum,AD:sum,MQ:avg -W=tbi -Oz -o ${CHR}_AllCHR_ExptIMPfilt_plus66_Merge.vcf.gz
