#!/bin/bash

#To do: install RSEM-1.3.0 and save in the chosen directory.

path=${1}
cd ${path}

#RSEM: step 1
#Prepare reference file
#RSEM-1.3.0/rsem-prepare-reference --bowtie2 --bowtie2-path ~/bin/Bowtie2-2.3.3.1 \
#Unigenes.fa Unigenes.fa

cd trimmedReads/
b=""
d=""
for file in *
do
       if [[ ${file} == *_forward_paired.fq ]]
       then
               a=${file}","
               b+=${a}
       elif [[ ${file} == *_reverse_paired.fq ]]
       then
               c=${file}","
               d+=${c}
       fi
done

b=${b::-1}
d=${d::-1}

l=$(echo ${b} | tr ',' ' ' | wc -w)
e=$(echo ${b} | tr ',' ' ' | awk '{print $1}')
f=$(echo ${d} | tr ',' ' ' | awk '{print $1}')


for (( i=2; i<=l+1; i++))
do
        #RSEM: step 2:
        #Align and calculate expression
        ${path}/RSEM-1.3.0/rsem-calculate-expression -p 20 --paired-end --bowtie2 --bowtie2-path ~/bin/Bowtie2-2.3.3.1 \
        ${e} ${f} ${path}/Unigenes.fa ${path}/Align_${e:0:6}
	e=$(echo ${b} | tr ',' ' ' | cut -d ' ' -f${i})
        f=$(echo ${d} | tr ',' ' ' | cut -d ' ' -f${i})
done


#rsem-generate-data-matrix to extract input matrix from expression results
cd ${path]
results=""

for file in *
do
        if [[ ${file} == *.genes.results ]]
        then
                a=${file}" "
                results+=${a}
        fi
done

${path}/RSEM-1.3.0/rsem-generate-data-matrix ${results} > ${path}/GeneMatrix.txt


