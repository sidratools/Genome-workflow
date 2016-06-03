#!/bin/bash

export PATH=/mnt/lustre/tpuser1/apps/JAVA_1.8.0/bin:$PATH
export LD_LIBRARY_PATH=/mnt/lustre/tpuser1/apps/JAVA_1.8.0/lib:$LD_LIBRARY_PATH
export APPS=/mnt/lustre/tpuser1/apps
export REF=/mnt/lustre/tpuser1/ref
export INP=/mnt/lustre/tpuser1/data
export GATK="$APPS/GATK3.3/GenomeAnalysisTK.jar"
export HG19=${REF}/hs37d5.fa
export MILLS=${REF}/Mills_and_1000G_gold_standard.indels.vcf.gz
export DBSNP=${REF}/dbsnp_138.vcf.gz

export cores=32;
#export NAME=sample
export NAME=NA12878
export WORK=/mnt/lustre/tpuser1/work
mkdir -p ${WORK}/${NAME}/${cores}/tmp
export TMPDIR=$WORK/${NAME}/$cores/tmp
export JAVA="/mnt/lustre/tpuser1/apps/JAVA_1.8.0/bin/java -XX:+UseParallelGC -XX:ParallelGCThreads=32  -Xmx64g -Djava.io.tmpdir=${TMPDIR}"




jid=`sbatch ./sleep.sh | awk '{print $NF }'`
echo "Workflow is preparing ..."
for job in bwakit.sh sambamba.sh GATK-RealignerTargetCreator.sh GATK-IndelRealigner.sh GATK-BaseRecalibrator.sh GATK-PrintReads.sh GATK-HaplotypeCaller.sh GATK-BaseRecalibrator_table.sh  ; 
do
  jid=`sbatch --dependency=afterok:$jid ./$job | awk '{print $NF }'` ;
  echo "Job_Name:$job  				 Job_Id: $jid" ;
done 
rm -f slurm-*
