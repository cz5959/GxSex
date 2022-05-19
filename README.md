# Amplification is the Primary Mode of Gene-by-Sex Interaction in Complex Human Traits

## update configuration file 

### single snp analysis
./manhattan.R -p -n
    # need summ stat file

./snp_annotation.sh -p
    # need summ stat and 1000G file, plink

### ld score regression
./ldsc_basic.sh -p
    # need summ stat, ld score files, ldsc
./r2_by_h2.R

### mash
./mash_setup.R -p -m
./mash_100.R -p -m
./mash_posterior.R -p -m

./mash_heatmap.R -p -n
./phenovar_by_phenomean.R
    # need pheno_names.txt, sex_ids.txt
./phenovar_by_amplification.R
    # need pheno_meanvar from previous, pheno_names, mash_weights

### mash pvalue
mash_p_threshold.R -p

mash_pvalue_plot.R -p -n -m
mash_pvalue_null_plot.R -m 
    # need null weights table
nontrivial.R
    # need relative_h2.txt from r2_by_h2.R, mash_weights from GWAS directory

### mash simulations
environ_matrix.R
    # need maf_sample_20k.txt in QC dir, output to GWAS dir
environ_small.R
environ_large.R
environ_mash.R
environ_heatmap.R

### PGS 
PGS_testset_1.R
PGS_GWAS_2.R
PGS_CT_SCORE_4.R
PGS_predict_5_linear.R

PGS_plot_final.R
    # need pgs_linear_results_five.txt, output pgs_combined_r2.txt
pheno_pgs.R
    # directions to move best pgs file to gwas/pheno directory    #!
pheno_pgs_overall.$
    # need sexspecific_pheno_pgs_lm.txt from previous

### testosterone as underlier
G_testosterone.R
G_testosterone_pgs.R
G_corr_testosterone.R
G_corr_testosterone_pgs.R
G_corr_testosterone_age.R

### shared amplification
gen_env_bootstrap.R 
    # need ldsc_results.txt in LDSC directory

### selection

