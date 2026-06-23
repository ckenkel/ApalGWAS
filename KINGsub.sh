#!/bin/bash
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --time=02:00:00
#SBATCH --mem=16G
#SBATCH --error=%x_%j.err
#SBATCH --output=%x_%j.out
#SBATCH --array=1-14
##SBATCH --mail-type=END
##SBATCH --mail-user=<yourname>@usc.edu

# enter your job environment parameters here

export config=/scratch1/ckenkel/ApalWGS/Haplotype/vcfSanger/chromOZ.txt
export CHR=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)


#generate subset VCF by samples for relatedness estimation and then combine into single VCF

#bcftools view -S SamplesKING.txt $CHR'_ApalHap.SNPid.vcf.gz' -W=tbi -o $CHR'_ApalHap.KINGSamp.vcf.gz'

bcftools view -S SamplesKINGuniq.txt $CHR'_ApalHap.SNPid.vcf.gz' -W=tbi -o $CHR'_ApalHap.KINGuniqSamp.vcf.gz'
