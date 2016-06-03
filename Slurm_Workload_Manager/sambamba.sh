#!/bin/bash

#SBATCH -J Sambamba
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.Sambamba.log
#SBATCH --error=Err.32.Sambamba.log


echo "time -p ${APPS}/sambamba/sambamba index -t 32 ${WORK}/${NAME}/${cores}/${NAME}.aln.bam"
time -p ${APPS}/sambamba/sambamba index -t 32 ${WORK}/${NAME}/${cores}/${NAME}.aln.bam
