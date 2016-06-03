#!/bin/bash

#SBATCH -J GATK-HaplotypeCaller
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks-per-node=32
#SBATCH --output=Out.32.GATK-HaplotypeCaller.log
#SBATCH --error=Err.32.GATK-HaplotypeCaller.log

echo "time -p $JAVA -jar $GATK -T HaplotypeCaller -nct 32 -pairHMM VECTOR_LOGLESS_CACHING -R ${HG19} -I ${WORK}/${NAME}/${cores}/${NAME}.realigned.recal.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 --dbsnp $DBSNP  -o $WORK/${NAME}/$cores/${NAME}.raw.snps.indels.g.vcf"
time -p $JAVA -jar $GATK -T HaplotypeCaller -nct 32 -pairHMM VECTOR_LOGLESS_CACHING -R ${HG19} -I ${WORK}/${NAME}/${cores}/${NAME}.realigned.recal.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 --dbsnp $DBSNP  -o $WORK/${NAME}/$cores/${NAME}.raw.snps.indels.g.vcf


