#!/bin/bash

#Perform trimming for each sample
#A for-loop is used to loop through all files, as variable file, containing forward reads (ends with _1.fq).
#The variable file2 is determined, which contains the same name as de variable file, but instead saves the reverse files (ends with _2.fq).
#trimmomtatic-0.32.jar is used, the variable file and file2 are used as input.
#Trimmomatic saves four files per sample: two forward and two reverse files (paired and unpaired).
#The name of the files consists of the first 6 characters of the variable file and ends with forward or reverse (paired and unpaired).
#Illuminclip removes adapters, if they are still present.
#Leading and trailing checks the first and last couple of bases, respectively, and removes them if the quality is not high enough.
#Slidingwindow checks for every 4 bases if the average quality score is above or equal to 15, if not these 4 bases will be removed.
#Minlen indicates the minimum length that the reads need to be after the trimming is complete.

path=$1
cd ${path}

mkdir trimmedReads

for file in *_1.fq
do
        file2=${file%%_1.fq}"_2.fq"
        java -jar /usr/share/java/trimmomatic-0.32.jar PE ${file} ${file2} \
        trimmedReads/${file:0:6}_forward_paired.fq \
        trimmedReads/${file:0:6}_forward_unpaired.fq \
        trimmedReads/${file:0:6}_reverse_paired.fq \
        trimmedReads/${file:0:6}_reverse_unpaired.fq \
        ILLUMINACLIP:TruSeq3-PE.fa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:20 MINLEN:50
done


