## Hardware settings

module load java/1.8.0
export NO_CORES=32
export QUEUE=nsnodes

## Programs settings
export TMPDIR=/gpfs/projects/NAGA/naga/Sidra_HSW/tmp
export BWAKIT=/gpfs/software/genomics/bwa.kit/run-bwamem
export SAMTOOLS=/gpfs/software/genomics/bwa.kit/samtools
export SAMBAMBA=/gpfs/software/genomics/sambamba/0.5.1/sambamba


export GATK="/gpfs/software/tools/java/1.8.0/bin/java -XX:+UseParallelGC -XX:ParallelGCThreads=${NO_CORES} -Xmx128g -Djava.io.tmpdir=${TMPDIR} -jar /gpfs/software/genomics/GATK/3.3.0/GenomeAnalysisTK.jar"
export PICARD="java -XX:+UseParallelGC -XX:ParallelGCThreads=${NO_CORES} -Xmx128g -Djava.io.tmpdir=${TMPDIR} -jar /gpfs/software/genomics/Picard/1.117/picard.jar"

## Reference settings
export REF=/gpfs/data_jrnas1/ref_data/Hsapiens/hs37d5/hs37d5.fa
export VARDBDIR=/gpfs/data_jrnas1/ref_data/Hsapiens/GRCh37/variation
export MILLS=${VARDBDIR}/Mills_and_1000G_gold_standard.indels.vcf.gz
export DBSNP=${VARDBDIR}/dbsnp_138.vcf.gz
export HAPMAP=${VARDBDIR}/hapmap_3.3.vcf.gz
export OMNI=${VARDBDIR}/1000G_omni2.5.vcf.gz
#export 1000G=${VARDBDIR}/1000G_phase1.snps.high_confidence.vcf.gz

## Project settings
export PRJDIR=/gpfs/projects/NAGA/naga/Sidra_HSW
export INDIR=/gpfs/projects/NAGA/naga/NGS/pipeline/data
export BAMDIR=${PRJDIR}/bam
export VCFDIR=${PRJDIR}/vcf
export LOGDIR=${PRJDIR}/logs


export STEPNAME=(BWAKIT sambamba RealignerTargetCreator IndelRealigner BaseRecalibrator PrintReads HaplotypeCaller BaseRecalibrator2 AnalyzeCovariates)

#export STEPNAME=BWAGATK

export BAMLIST=${PRJDIR}/input.list
export NBBAM=$(cat $BAMLIST | wc -l)
export ALLSMPL=""
#export servid=(20 19)
mkdir -p $BAMDIR
mkdir -p $VCFDIR
mkdir -p $LOGDIR

export var=0

for sample in `cat $BAMLIST`; do
    let "var+=1";
    export tmp2=${sample##*/};
    export prefix=${tmp2%.bam};
    export JNAME=${prefix}_${STEPNAME};
    ### BWAKIT
    export BSUB="bsub -n ${NO_CORES} -q nsnodes -R \"span[hosts=1]\" -J ${STEPNAME[0]}[$var] -o ${LOGDIR}/${prefix}.${STEPNAME[0]}.out -e ${LOGDIR}/${prefix}.${STEPNAME[0]}.err ";
    echo $BSUB;
  #  echo  ${STEPNAME[0]} : $prefix
  #  CMD[0]="$BWAKIT -aHds -t${NO_CORES} -R \"@RG\tID:${prefix}\tLB:${prefix}\tSM:${prefix}\tPL:ILLUMINA\" -o ${BAMDIR}/${prefix} $REF ${INDIR}/${prefix}_1.fq.gz ${INDIR}/${prefix}_2.fq.gz ; " 
    CMD[0]="time -p $BWAKIT -aHds -t${NO_CORES} -R \"@RG\tID:${prefix}\tLB:${prefix}\tSM:${prefix}\tPL:ILLUMINA\" -o ${BAMDIR}/${prefix} $REF ${INDIR}/${prefix}_1.fastq.gz ${INDIR}/${prefix}_2.fastq.gz ; " 
   # echo `eval ${CMD[0]}` ;
  #   eval ${CMD[0]};
    eval ${CMD[0]} | $BSUB;
    CMD2="$SAMTOOLS index ${BAMDIR}/${prefix}.aln.bam ; touch ${BAMDIR}/${prefix}.aln.bam.done ;"
    CMD[1]="time -p $SAMBAMBA index -t ${NO_CORES}  ${BAMDIR}/${prefix}.aln.bam"
    CMD[2]="time -p $GATK -T RealignerTargetCreator -nt ${NO_CORES} -R ${REF} -known ${MILLS} -I ${BAMDIR}/${prefix}.aln.bam -o ${BAMDIR}/${prefix}.realigner.intervals"
    CMD[3]="time -p $GATK -T IndelRealigner -R $REF -known ${MILLS} -I ${BAMDIR}/${prefix}.aln.bam -targetIntervals ${BAMDIR}/${prefix}.realigner.intervals -o ${BAMDIR}/${prefix}.realigned.bam"
    CMD[4]="time -p $GATK -T BaseRecalibrator -nct ${NO_CORES} -I ${BAMDIR}/${prefix}.realigned.bam -R $REF -knownSites $DBSNP -o ${BAMDIR}/${prefix}.recal.table"
    CMD[5]="time -p $GATK -T PrintReads -nct ${NO_CORES} -I ${BAMDIR}/${prefix}.realigned.bam -R $REF -BQSR ${BAMDIR}/${prefix}.recal.table -o ${BAMDIR}/${prefix}.realigned.recal.bam"
    CMD[6]="time -p $GATK -T HaplotypeCaller -nct ${NO_CORES} -pairHMM VECTOR_LOGLESS_CACHING -R $REF -I ${BAMDIR}/${prefix}.realigned.recal.bam --emitRefConfidence GVCF --variant_index_type LINEAR --variant_index_parameter 128000 --dbsnp $DBSNP -o ${VCFDIR}/${prefix}.raw.snps.indels.g.vcf"
    CMD[7]="time -p $GATK -T BaseRecalibrator -nct ${NO_CORES} -I ${BAMDIR}/${prefix}.realigned.bam -R $REF -knownSites $DBSNP -BQSR ${BAMDIR}/${prefix}.recal.table -o ${BAMDIR}/${prefix}.after_recal.table"
    CMD[8]="time -p $GATK -T AnalyzeCovariates -R $REF -before ${BAMDIR}/${prefix}.recal.table -after ${BAMDIR}/${prefix}.after_recal.table -plots ${BAMDIR}/${prefix}.recal_plots.pdf"
    
 
        for stepid in `seq 1 $((${#STEPNAME[@]}-1))`;
        do
            echo  ${STEPNAME[$stepid]} :  $prefix  
            export BSUB="bsub -n ${NO_CORES} -q ${QUEUE} -R \"span[hosts=1]\" -w ${STEPNAME[${stepid}-1]}[$var] -J ${STEPNAME[$stepid]}[$var] -o ${LOGDIR}/${prefix}.${STEPNAME[$stepid]}.out -e ${LOGDIR}/${prefix}.${STEPNAME[$stepid]}.err ";
    #       echo $BSUB;    
    #        echo ${CMD[${stepid}]};
            echo ${CMD[${stepid}]} | $BSUB;    
        done
done

echo " $var samples submitted in ${#STEPNAME[@]} stages";
