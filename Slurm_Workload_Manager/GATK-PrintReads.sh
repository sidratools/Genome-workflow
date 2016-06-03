#!/bin/bash

#SBATCH -J GATK-PrintReads
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.GATK-PrintReads.log
#SBATCH --error=Err.32.GATK-PrintReads.log

echo "time -p ${JAVA} -jar ${GATK} -T PrintReads -nct 32 -I ${WORK}/${NAME}/${cores}/${NAME}.realigned.bam -R ${HG19} -BQSR ${WORK}/${NAME}/${cores}/${NAME}.recal.table -o $WORK/${NAME}/$cores/${NAME}.realigned.recal.bam "
time -p ${JAVA} -jar ${GATK} -T PrintReads -nct 32 -I ${WORK}/${NAME}/${cores}/${NAME}.realigned.bam -R ${HG19} -BQSR ${WORK}/${NAME}/${cores}/${NAME}.recal.table -o $WORK/${NAME}/$cores/${NAME}.realigned.recal.bam

