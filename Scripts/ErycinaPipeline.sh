#!/bin/bash

#Main script, all parts of the pipeline are called here.
#Get the path where the fastq files are stored:
echo "Write the path where the fastq files are stored: "
read path

#Step 1: First Quality Control:

bash QualityControl.sh ${path}

#Step 2: Trimming:

bash Trimming.sh ${path}

#Step 3: Second Quality Control:

bash QualityControl2.sh ${path}

#Step 4: de novo assembly:

bash Assembly.sh ${path}

#Step 5: Aligning and quantification:

bash Align.sh ${path}

#Step 6: Annotation:

bash Annotation.sh ${path}

#Step 7: Differential expression analysis:

Rscript DifExp.R ${path}







