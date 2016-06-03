#!/bin/bash
#SBATCH -J GATK-BaseRecalibrator
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.GATK-BaseRecalibrator.log
#SBATCH --error=Err.32.GATK-BaseRecalibrator.log


echo "time -p ${JAVA} -jar ${GATK} -T BaseRecalibrator -nct 32 -I ${WORK}/${NAME}/${cores}/$NAME.realigned.bam -R ${HG19} -knownSites ${DBSNP} -o ${WORK}/${NAME}/${cores}/${NAME}.recal.table "
time -p ${JAVA} -jar ${GATK} -T BaseRecalibrator -nct 32 -I ${WORK}/${NAME}/${cores}/$NAME.realigned.bam -R ${HG19} -knownSites ${DBSNP} -o ${WORK}/${NAME}/${cores}/${NAME}.recal.table 


