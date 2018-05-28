#!bin/bash

#Step 1: First Quality Control:
path=$1
cd ${path}

#Make fastqcResult
mkdir fastqcResult

#Perform fastqc for each sample using a for-loop for every file in the Data directory.
#Save the output in the fastqcResult directory
for f in *_1.fq; do fastqc $f --outdir=${path}/fastqcResult/; done
for f in *_2.fq; do fastqc $f --outdir=${path}/fastqcResult/; done

