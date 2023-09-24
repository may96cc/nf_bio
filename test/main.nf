#!/usr/bin/env nextflow
nextflow.enable.dsl=2

params.outdir = "./out"
params.inputdir = "./fastq_data"

// Define channel for input data
Channel
    .fromFilePairs("${params.inputdir}/*_{R1,R2}.fastq")
    .map { sample_id, files -> [sample_id, files[0], files[1]] }
    .set { data_fastq }

process runFastQC {
    publishDir "${params.outdir}/fastqc_reports", mode: 'copy'

    input:
    tuple val(sample_id), path(r1), path(r2)

    output:
    path "*.html", emit: fastqc_html
    path "*.zip", emit: fastqc_zip

    script:
    """
    fastqc ${r1} ${r2}
    """
}

process runTrimmomatic {
    publishDir "${params.outdir}/trimmed", mode: 'copy'

    input:
    tuple val(sample_id), path(r1), path(r2)

    output:
    path "trimmed/*", emit: trim_output

    script:
    """
    mkdir -p trimmed
    mkdir -p unpaired
    trimmomatic PE -phred33 ${r1} ${r2} \
        trimmed/${r1.baseName}_R1_trimmed.fastq unpaired/${r1.baseName}_R1_unpaired.fastq \
        trimmed/${r2.baseName}_R2_trimmed.fastq unpaired/${r2.baseName}_R2_unpaired.fastq \
        LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36
    """
}

process runFastQCTrimmed {
    publishDir "${params.outdir}/fastqc_reports/trimmed", mode: 'copy'

    input:
    tuple val(sample_id), path(reads)

    output:
    path "*.html", emit: fastqc_trim_html
    path "*.zip", emit: fastqc_trim_zip

    script:
    """
    fastqc ${reads}
    """
}

process runMultiQC {
    publishDir "${params.outdir}/multiqc", mode: 'copy'

    input:
    path(fastqc_html)
    path(fastqc_zip)
    path(fastqc_trim_html)
    path(fastqc_trim_zip)

    output:
    path "multiqc_report.html", emit: multiqc_report

    script:
    """
    mkdir -p multiqc_data
    multiqc . -f -o multiqc_data
    cp multiqc_data/multiqc_report.html .  # Move the report to the expected location
    """
}

workflow {
    runFastQC( data_fastq )
    runTrimmomatic( data_fastq )
    runFastQCTrimmed( runTrimmomatic.out.trim_output )
    runMultiQC( runFastQC.out.fastqc_html, runFastQC.out.fastqc_zip, runFastQCTrimmed.out.fastqc_trim_html, runFastQCTrimmed.out.fastqc_trim_zip )
}

