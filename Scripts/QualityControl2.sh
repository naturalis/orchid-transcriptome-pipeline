#!/bin/bash

path=${1}
cd ${path}

#Make fastqcTrimmed
mkdir fastqcTrimmed

#Perform fastqc for each sample using a for-loop for every file in the trimmedReads directory.
#Save the output in the fastqcTrimmed directory
for f in trimmedReads/*_forward_paired.fq trimmedReads/*_reverse_paired.fq; \
do fastqc $f --outdir=fastqcTrimmed/; done

