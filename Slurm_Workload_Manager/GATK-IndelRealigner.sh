#!/bin/bash

#SBATCH -J GATK-IndelRealigner
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.GATK-IndelRealigner.log
#SBATCH --error=Err.32.GATK-IndelRealigner.log

echo "time -p ${JAVA} -jar ${GATK} -T IndelRealigner -R ${HG19} -known ${MILLS} -I ${WORK}/${NAME}/${cores}/${NAME}.aln.bam -targetIntervals  ${WORK}/${NAME}/${cores}/${NAME}.realigner.intervals -o  ${WORK}/${NAME}/${cores}/${NAME}.realigned.bam"
time -p ${JAVA} -jar ${GATK} -T IndelRealigner -R ${HG19} -known ${MILLS} -I ${WORK}/${NAME}/${cores}/${NAME}.aln.bam -targetIntervals  ${WORK}/${NAME}/${cores}/${NAME}.realigner.intervals -o  ${WORK}/${NAME}/${cores}/${NAME}.realigned.bam



