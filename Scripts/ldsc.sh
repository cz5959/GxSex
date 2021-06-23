#!/bin/sh

# file paths
PLINK=$SCRATCH/GWAS_Results/$1
FILE_PATH=$SCRATCH/LD_practice/$1
LD_SCORE=$SCRATCH/LD_practice/LD_scores
PARTITION=$SCRATCH/LD_practice/Partitioned
NEALE=$SCRATCH/Neale_Lab/Standing_Height
echo $1

# set up environment
cd /scratch1/08005/cz5959/ldsc 
source activate ldsc

#### reformat summary stat
# need rsid; effect allele; non-effect allele; sample size; p-value; signed summ stat (beta or log odds, z-score, etc)
# plinkc
munge_sumstats.py --sumstats $PLINK/both_sex_all.${1}.glm.linear --snp ID --a2 AX --N-col OBS_CT --out $FILE_PATH/${1}_both_sex --merge-alleles $LD_SCORE/w_hm3.snplist
munge_sumstats.py --sumstats $PLINK/female_all.${1}.glm.linear --snp ID --a2 AX --N-col OBS_CT --out $FILE_PATH/${1}_female --merge-alleles $LD_SCORE/w_hm3.snplist
munge_sumstats.py --sumstats $PLINK/male_all.${1}.glm.linear --snp ID --a2 AX --N-col OBS_CT --out $FILE_PATH/${1}_male --merge-alleles $LD_SCORE/w_hm3.snplist
# neale lab
#munge_sumstats.py --sumstats $NEALE/neale_height_tab_ldsc.txt --out $FILE_PATH/neale_height --merge-alleles $LD_SCORE/w_hm3.snplist

#### LD Score Regression
# compute heritability and ldsc intercept
# plink
ldsc.py --h2 $FILE_PATH/${1}_both_sex.sumstats.gz --w-ld-chr $LD_SCORE/eur_w_ld_chr/ --ref-ld-chr $LD_SCORE/eur_w_ld_chr/ --out $FILE_PATH/${1}_both_sex_h2
ldsc.py --h2 $FILE_PATH/${1}_female.sumstats.gz --w-ld-chr $LD_SCORE/eur_w_ld_chr/ --ref-ld-chr $LD_SCORE/eur_w_ld_chr/ --out $FILE_PATH/${1}_female_h2
ldsc.py --h2 $FILE_PATH/${1}_male.sumstats.gz --w-ld-chr $LD_SCORE/eur_w_ld_chr/ --ref-ld-chr $LD_SCORE/eur_w_ld_chr/ --out $FILE_PATH/${1}_male_h2
# neale
#ldsc.py --h2 $FILE_PATH/neale_height.sumstats.gz --w-ld-chr $LD_SCORE/eur_w_ld_chr/ --ref-ld-chr $LD_SCORE/eur_w_ld_chr/ --out $FILE_PATH/neale_height_h2

# ldsc summary
grep -h -A 4 "h2:" $FILE_PATH/*h2.log > ${1}_ldsc.txt


# partitioned heritability
ldsc.py	--h2 $FILE_PATH/${1}_both_sex.sumstats.gz --ref-ld-chr $PARTITION/baseline/baseline. --w-ld-chr $PARTITION/weights_hm3_no_hla/weights. --overlap-annot --frqfile-chr $PARTITION/1000G_frq/1000G.mac5eur. --out $FILE_PATH/${1}_both_sex_baseline
ldsc.py	--h2 $FILE_PATH/${1}_female.sumstats.gz --ref-ld-chr $PARTITION/baseline/baseline. --w-ld-chr $PARTITION/weights_hm3_no_hla/weights. --overlap-annot --frqfile-chr $PARTITION/1000G_frq/1000G.mac5eur. --out $FILE_PATH/${1}_female_baseline
ldsc.py	--h2 $FILE_PATH/${1}_male.sumstats.gz --ref-ld-chr $PARTITION/baseline/baseline. --w-ld-chr $PARTITION/weights_hm3_no_hla/weights. --overlap-annot --frqfile-chr $PARTITION/1000G_frq/1000G.mac5eur. --out $FILE_PATH/${1}_male_baseline
# cell type group analysis

echo completed

