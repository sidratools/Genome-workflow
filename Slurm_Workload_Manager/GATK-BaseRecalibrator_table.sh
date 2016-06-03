#!/bin/bash

#SBATCH -J GATK-BaseRecalibrator_table
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.GATK-BaseRecalibrator_table.log
#SBATCH --error=Err.32.GATK-BaseRecalibrator_table.log


echo "time -p ${JAVA} -jar ${GATK} -T BaseRecalibrator -nct 32 -I ${WORK}/${NAME}/${cores}/${NAME}.realigned.recal.bam -R ${HG19} -knownSites $DBSNP -BQSR ${WORK}/${NAME}/${cores}/${NAME}.recal.table -o ${WORK}/${NAME}/${cores}/${NAME}.after_recal.table"
time -p ${JAVA} -jar ${GATK} -T BaseRecalibrator -nct 32 -I ${WORK}/${NAME}/${cores}/${NAME}.realigned.recal.bam -R ${HG19} -knownSites $DBSNP -BQSR ${WORK}/${NAME}/${cores}/${NAME}.recal.table -o ${WORK}/${NAME}/${cores}/${NAME}.after_recal.table

