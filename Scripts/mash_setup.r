#!/usr/bin/env Rscript

# load libraries
library(ashr, lib.loc="/work/08005/cz5959/frontera/R/x86_64-pc-linux-gnu-library/4.0/")
library(mashr, lib.loc="/work/08005/cz5959/frontera/R/x86_64-pc-linux-gnu-library/4.0/")

# arguments and set working directory
setwd("/scratch1/08005/cz5959/LD_practice/LD_scores")
load(file="LD_groups.RData")
args <- commandArgs(trailingOnly=TRUE)
pheno <- args[1]
wd <- paste("/scratch1/08005/cz5959/GWAS_Results/",pheno,sep="")
setwd(wd)

# load results - summstats
female_file <- paste("female_all.",pheno,".glm.linear",sep="")
male_file <- paste("male_all.",pheno,".glm.linear",sep="")
female_df <- read.table(female_file,sep="\t",head=FALSE, 
col.names=c("CHROM","POS","ID","REF","ALT","A1","AX","TEST","OBS_CT","BETA","SE","TSTAT","P"), 
colClasses = c(rep("integer",2), rep("character", 3), rep("NULL", 4), rep("numeric",2), "NULL", "numeric"))
male_df <- read.table(male_file,sep="\t",head=FALSE,
col.names=c("CHROM","POS","ID","REF","ALT","A1","AX","TEST","OBS_CT","BETA","SE","TSTAT","P"),
colClasses = c(rep("integer",2), rep("character", 3), rep("NULL", 4), rep("numeric",2), "NULL", "numeric"))

#load results - clumped
female_file <- paste("female_",pheno,"_tab.clumped",sep="")
male_file <- paste("male_",pheno,"_tab.clumped",sep="")
female_clump <- read.table(female_file,sep="\t",head=TRUE)
male_clump <- read.table(male_file,sep="\t",head=TRUE)

# add new ID column CHROM:POS:REF:ALT:ID
female_df$VAR <- paste(female_df$CHROM, female_df$POS, female_df$REF, female_df$ALT, female_df$ID, sep=":")
male_df$VAR <- paste(male_df$CHROM, male_df$POS, male_df$REF, male_df$ALT, male_df$ID, sep=":")
female_df$index <- seq.int(nrow(female_df))
male_df$index <- seq.int(nrow(male_df))

# LD groups merge with p-values
LD_groups <- merge(pos_groups, female_df[c("index","P")], by="index")
LD_groups <- merge(LD_groups, male_df[c("index","P")], by="index")

# create matrix
conditions <- c("female", "male")
r <- nrow(female_df)
BETA <- matrix(c(female_df$BETA, male_df$BETA), nrow=r, ncol=2, dimnames=list(c(female_df$VAR),conditions))
SE <- matrix(c(female_df$SE, male_df$SE), nrow=r, ncol=2, dimnames=list(c(female_df$VAR),conditions))

#### MASH ###
# read in data
data = mash_set_data(BETA, SE)

# strong subset index list
strong_f <- female_df[female_df$ID %in% female_clump$SNP,]
strong_f <- strong_f[strong_f$P < 5e-8,'index']
strong_m <- male_df[male_df$ID %in% male_clump$SNP,]
strong_m <- strong_m[strong_m$P < 5e-8,'index']
strong <- unique(c(strong_f,strong_m))

# save Rdata
summstat_pos <- df$POS
save(summstat_pos, LD_groups, data, strong, file= paste(pheno,"_mash.RData",sep=""))