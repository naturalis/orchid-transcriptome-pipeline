#!/bin/bash

path=${1}

cd ${path}


makeblastdb -in ${path}/UniProtDB/UniProt_R_Plants.fasta -dbtype prot -out UniProt_R_Plants

#Blast transcripts against UniProt Reviewed Plants database
blastx -query ${path}/Unigenes.fa.transcripts.fa -db ${path}/UniProt_R_Plants -out AnnotationErycinaReviewed -evalue 1e-20 -num_threads 6 -max_target_seqs 1 -outfmt 6

makeblastdb -in ${path}/UniProtDB/UniProt_U_Orchids.fasta -dbtype prot -out UniProt_U_Orchids

#Blast transcripts against UniProt Unreviewed Orchids database
blastx -query ${path}/Unigenes.fa.transcripts.fa -db ${path}/UniProt_U_Orchids -out AnnotationErycinaUnreviewed -evalue 1e-20 -num_threads 6 -max_target_seqs 1 -outfmt 6


