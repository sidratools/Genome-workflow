#!/bin/bash

#SBATCH -J BWAKIT
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.bwakit.log
#SBATCH --error=Err.32.bwakit.log

echo "time -p $APPS/bwa.kit/run-bwamem -aHds -t28 -R "@RG\tID:${NAME}\tLB:${NAME}\tSM:${NAME}\tPL:ILLUMINA" -o $WORK/${NAME}/$cores/${NAME} ${REF}/hs37d5.fa $INP/input/${NAME}_1.fastq.gz $INP/input/${NAME}_2.fastq.gz | sh ";
time -p $APPS/bwa.kit/run-bwamem -aHds -t28 -R "@RG\tID:${NAME}\tLB:${NAME}\tSM:${NAME}\tPL:ILLUMINA" -o $WORK/${NAME}/$cores/${NAME} ${REF}/hs37d5.fa $INP/input/${NAME}_1.fastq.gz $INP/input/${NAME}_2.fastq.gz | sh ;
