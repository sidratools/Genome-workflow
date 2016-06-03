#!/bin/bash

#SBATCH -J GATK-RealignerTargetCreator
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.GATK-RealignerTargetCreator.log
#SBATCH --error=Err.32.GATK-RealignerTargetCreator.log


echo "time -p $JAVA -jar $GATK -T RealignerTargetCreator -nt 32 -R ${HG19} -known ${MILLS} -I $WORK/${NAME}/$cores/${NAME}.aln.bam -o ${WORK}/${NAME}/${cores}/${NAME}.realigner.intervals"
time -p $JAVA -jar $GATK -T RealignerTargetCreator -nt 32 -R ${HG19} -known ${MILLS} -I $WORK/${NAME}/$cores/${NAME}.aln.bam -o ${WORK}/${NAME}/${cores}/${NAME}.realigner.intervals
