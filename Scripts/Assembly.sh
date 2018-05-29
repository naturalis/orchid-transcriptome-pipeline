
#!/bin/bash

#To do:
#Install Trinity and store directory in the same path as the rest of the files.
#Trinity-v2.5.1 is used for de novo assembly.
#Install iAssembler for clustering of transcripts.

path=${1}

cd ${path}/trimmedReads/

#Remove unpaired files, these will not be used in the constructing of the transcriptome
rm *_unpaired.fq

#Export path of bowtie2 that will be used.
export PATH=~/bin/Bowtie2-2.3.3.1:$PATH

#A for-loop is used to loop through every file (variable=file).
#If the name of the file ends with _forward_paired.fq, the name of the file will be saved in the variable a, followed by a comma.
#The variable a will be concatenated at variable b.
#A string with the forward reads, separated by commas is constructed in this way.
#If the file does not end with _forward_paired.fq, the file name will be saved in the variable c, followed by a comma.
#The variable c will be concatenated at variable d, and in this way a string containing all the reverse reads is constructed.
b=""
d=""
for file in *
do
       if [[ ${file} == *_forward_paired.fq ]]
       then
               a=${file}","
               b+=${a}
       else
               c=${file}","
               d+=${c}
       fi
done

#The comma at the end of variable b and d will be removed.
b=${b::-1}
d=${d::-1}

#Trinity is used for a de novo assembly:
#The path to Trinity is first given, followed by the type of sequences that are used as input (fastq).
#The maximal memory that can be used is set to 20GB.
#The forward reads are saved in the variable b and  are used as input for the --left parameter.
#The reverse reads are saved in the variable d and are used as input for the --right parameter.
#The lib_type parameter is set to RF, which means that paired-end data will be used.
#The amount of CPU is set to 20.
${path}/trinityrnaseq-Trinity-v2.5.1/Trinity --seqType fq --max_memory 20G --output ${path}/Trinity_output \
--left ${b} --right ${d} --SS_lib_type RF --CPU 20

#Get Trinity statistics after the assembly
trinityrnaseq-Trinity-v2.5.1/util/TrinityStats.pl Trinity_output/Trinity.fasta > TrinityStatistics.txt 

#cluster transcripts
mv ${path}/Trinity_output/Trinity.fasta ${path}/iAssembler-v1.3.3.x64/
cdhit-est -i ${path}/iAssembler-v1.3.3.x64/Trinity.fasta -o ${path}/Unigenes.fa -n 9 -d 0 -M 0 -T 20


