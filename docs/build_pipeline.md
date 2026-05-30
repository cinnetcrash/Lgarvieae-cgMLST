# How this schema was built

This document is the exact pipeline used to produce v1.0 of the schema. It is included so the schema can be rebuilt or extended deterministically.

## Inputs

- **Source**: 250 *Lactococcus garvieae* assemblies downloaded from PubMLST (`contigs_fasta.tar.gz`).
- **After QC**: 247 assemblies (3 excluded — see [`qc_methods.md`](qc_methods.md)).

## Software versions used

| Tool | Version |
|---|---|
| seqkit | 2.x |
| QUAST | 5.2.0 |
| BUSCO | 5.8.3 (lineage `lactobacillales_odb12`) |
| CheckM2 | 1.1.0 |
| Prodigal | 2.6.3 |
| chewBBACA | 3.5.3 |
| BLAST+ | 2.15.x (chewBBACA conda dependency) |

## Step 1 — Prodigal training file

Trained on `148_LG26.fasta` (the most contiguous assembly in the build set: 3 contigs, 2.67 Mb, N50 = 2.6 Mb).

```bash
prodigal -i 148_LG26.fasta -t Lgarvieae.trn -p single
```

The resulting `Lgarvieae.trn` is shipped in `schema/`.

## Step 2 — CreateSchema (wgMLST seed)

```bash
chewBBACA.py CreateSchema \
    -i genomes/ \
    -o chewie_out \
    --n Lgarvieae_wgMLST \
    --ptf Lgarvieae.trn \
    --cpu 14 \
    --bsr 0.6
```

Result:
- 505 461 CDSs predicted across the 247 genomes.
- 884 highly similar sequences removed during deduplication.
- **9379 wgMLST loci** in the seed schema.
- Run time: ~2 min.

## Step 3 — AlleleCall

```bash
chewBBACA.py AlleleCall \
    -i genomes/ \
    -g chewie_out/Lgarvieae_wgMLST \
    -o allelecall_out \
    --cpu 14
```

Result:
- 470 934 CDSs classified.
- 323 427 EXC + 118 439 INF.
- 8 002 paralog flags (NIPH/NIPHEM).
- Run time: ~3.5 min.

## Step 4 — Identify and exclude paralogous loci

```bash
cut -f2 allelecall_out/paralogous_loci.tsv \
  | tail -n +2 \
  | tr '|' '\n' \
  | sort -u \
  > paralog_loci_list.txt
```

→ 1 059 unique loci flagged across the build set.

## Step 5 — ExtractCgMLST

```bash
chewBBACA.py ExtractCgMLST \
    -i allelecall_out/results_alleles.tsv \
    -o cgmlst_out \
    --r paralog_loci_list.txt \
    --t 0.95 0.99 1.0
```

Result:

| Threshold | Locus count |
|---|---|
| 1.00 (present in all 247) | 790 |
| 0.99 | **1100 (default)** |
| 0.95 | 1315 |

## Step 6 — Assemble the shareable package

The schema in `schema/` contains FASTAs only for the 1100 cgMLST99 loci plus their `short/` representatives, `Lgarvieae.trn`, and `.schema_config`. The two alternative threshold lists are shipped in `data/`.

## How to rebuild

Given the same 247 assemblies (and same chewBBACA version), the locus set is deterministic. Allele numbering, however, depends on input order — alleles will be the same sequences but may have different integer IDs if you re-run.

## How to extend

To add more genomes without renumbering existing alleles:

```bash
chewBBACA.py AlleleCall \
    -i new_genomes/ \
    -g schema \
    -o new_results \
    --cpu 8
# new alleles are appended to schema/*.fasta automatically
```

The schema directory is updated in place. If you'd like the extension contributed back to this repo, open a pull request — see [`usage.md`](usage.md).
