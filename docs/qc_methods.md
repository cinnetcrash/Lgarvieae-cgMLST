# QC methods for the 247-genome build set

Of the 250 *L. garvieae* assemblies retrieved from PubMLST, **247 passed QC** and were used to build the schema. This document records the QC criteria.

## Tools

| Tool | Version | Purpose |
|---|---|---|
| seqkit | 2.x | Per-assembly N50, contig count, length |
| QUAST | 5.2.0 | Assembly QC (L50, GC, largest contig, etc.) |
| BUSCO | 5.8.3 | Gene-completeness vs `lactobacillales_odb12` (367 markers) |
| CheckM2 | 1.1.0 | Completeness + contamination via DIAMOND vs UniRef100 |

## Thresholds

A genome was retained if **all** of these held:

| Metric | Cut-off |
|---|---|
| Assembly size | 1.7 – 2.8 Mb (*L. garvieae* expected ~2.0 – 2.4 Mb) |
| Contigs | ≤ 1000 |
| N50 | ≥ 10 kb |
| CheckM2 completeness | ≥ 85% |
| CheckM2 contamination | < 15% |
| BUSCO complete | ≥ 85% |
| GC content | 36 – 41% |

The thresholds above are deliberately permissive — three tiers (HQ / MQ / LQ) are defined internally; LQ assemblies were still admitted to the build set because chewBBACA tolerates fragmented assemblies well, but were excluded if they failed any single criterion.

## Build-set characteristics

| Metric | Mean | Median |
|---|---|---|
| Genome size | 2.13 Mb | 2.10 Mb |
| Contigs | 41 | 28 |
| N50 | 770 kb | 313 kb |
| CheckM2 completeness | 99.80% | 100.0% |
| CheckM2 contamination | 0.22% | – |
| BUSCO complete | 98.0% | 98.4% |

## Genomes excluded from the build set

| Sample | Reason | Genome (Mb) | Contigs | N50 | CheckM2 compl. | BUSCO C |
|---|---|---|---|---|---|---|
| `251_LG_109_6` | Likely wrong species / synthetic | 2.14 | 1 | 2.14 Mb | 64% | 40% |
| `321_ERR5094895` | Fragmented, incomplete | 1.87 | 217 | 11 kb | 87% | 82% |
| `334_LG_SAV_20` | ~2× expected size (likely mixed culture); BUSCO failed | 4.16 | 94 | 102 kb | 100%* | – |

\* CheckM2 reported 100% completeness despite 2× genome size — this is a known limitation of single-copy marker–based completeness with mixed populations.

## Reproducing the QC

QC was orchestrated via the standalone scripts in this companion folder:

```
qc/
├── run_quast.sh
├── run_busco.sh
└── run_checkm2.sh
```

These are not shipped in this repo (they are not part of the cgMLST schema itself). The QC tables and the integrated `FINAL_genome_qc.tsv` can be regenerated with the commands below:

```bash
# seqkit per-assembly stats
seqkit stats -a -T -j 4 *.fasta > assembly_stats.tsv

# QUAST
quast.py -t 8 --no-icarus --no-plots -o quast_out *.fasta

# BUSCO (5.8.3)
busco -i genomes/ -o busco_out -m genome -l lactobacillales_odb12 --cpu 12 --tar

# CheckM2 (1.1.0)
checkm2 predict --threads 14 -x fasta \
    --input genomes/ --output-directory checkm2_out \
    --database_path /path/to/uniref100.KO.1.dmnd
```
