# Lactococcus garvieae cgMLST schema

[![License: CC BY 4.0](https://img.shields.io/badge/License-CC_BY_4.0-lightgrey.svg)](https://creativecommons.org/licenses/by/4.0/)
[![chewBBACA](https://img.shields.io/badge/chewBBACA-%E2%89%A53.5.3-blue)](https://github.com/B-UMMI/chewBBACA)
[![Loci](https://img.shields.io/badge/cgMLST_loci-1100-success)]()
[![Build genomes](https://img.shields.io/badge/build_set-247_genomes-informational)]()

A core-genome MLST schema for *Lactococcus garvieae*, built with [chewBBACA](https://github.com/B-UMMI/chewBBACA) from 247 high-quality genome assemblies.

## Schema at a glance

| Parameter | Value |
|---|---|
| Species | *Lactococcus garvieae* |
| Default cgMLST loci | **1100** (present in ≥99% of build genomes) |
| Alternative thresholds shipped | cgMLST100 (790), cgMLST95 (1315) |
| Build tool | chewBBACA v3.5.3 |
| Gene prediction | Pyrodigal/Prodigal, single mode, translation table 11 |
| BLAST Score Ratio | 0.6 |
| Allele size variation threshold | 0.2 |
| Schema version | v1.0 |
| Build date | 2026-05-29 |

## Quick start — type a new isolate

```bash
git clone https://github.com/cinnetcrash/Lgarvieae-cgMLST.git
conda activate chewie    # chewBBACA >= 3.5.3 required

chewBBACA.py AlleleCall \
    -i path/to/my_new_genomes/ \
    -g Lgarvieae-cgMLST/schema \
    -o my_results \
    --cpu 8
```

The output `results_alleles.tsv` is an allelic profile per genome and can be loaded into [GrapeTree](https://github.com/achtman-lab/GrapeTree) or [PHYLOViZ](https://online.phyloviz.net/) to draw minimum spanning trees and infer transmission.

See [`docs/usage.md`](docs/usage.md) for full options and `examples/` for ready-to-run scripts.

## Repository layout

```
Lgarvieae-cgMLST/
├── README.md                    # this file
├── LICENSE                      # CC BY 4.0
├── CITATION.cff                 # how to cite
├── CHANGELOG.md
├── schema/                      # ← give this folder to chewBBACA AlleleCall
│   ├── Lgarvieae.trn            # Prodigal training file (table 11)
│   ├── .schema_config           # chewBBACA config (do not edit)
│   ├── *.fasta                  # 1100 locus FASTAs (all known alleles)
│   └── short/                   # representative alleles for BLAST seeding
│       └── *_short.fasta        # 1100 files
├── data/
│   ├── locus_list_cgMLST99.txt          # 1100 loci ← default
│   ├── locus_list_cgMLST100.txt         # 790 loci (strict)
│   ├── locus_list_cgMLST95.txt          # 1315 loci (relaxed)
│   ├── locus_presence_absence.tsv       # presence/absence in the build set
│   └── example_profiles_247genomes.tsv  # allelic profiles of the 247 build genomes
├── reports/
│   ├── cgMLST_loci_report.html          # interactive locus presence plot
│   └── schema_report.html               # schema-wide quality report
├── docs/
│   ├── build_pipeline.md                # how this schema was built
│   ├── usage.md                         # how to type new isolates
│   └── qc_methods.md                    # QC of the 247 build genomes
└── examples/
    └── type_new_isolate.sh              # one-line example
```

## Schema construction

The schema was built from a curated set of 247 *L. garvieae* assemblies retrieved from PubMLST, after multi-tool QC (seqkit + QUAST + BUSCO + CheckM2). See [`docs/qc_methods.md`](docs/qc_methods.md) for the QC criteria and [`docs/build_pipeline.md`](docs/build_pipeline.md) for the exact chewBBACA commands.

Summary statistics from the build's `AlleleCall` run on the 247 input genomes:

| Category | Count |
|---|---|
| Total CDSs classified | 470 934 |
| EXC (exact match) | 323 427 |
| INF (inferred new allele) | 118 439 |
| Paralog flags (NIPH + NIPHEM) | 8 002 |
| Loci removed as paralogous | 1 059 |

## Choosing a presence threshold

| File | Threshold | Loci | When to use |
|---|---|---|---|
| `data/locus_list_cgMLST100.txt` | 100% (present in all 247 build genomes) | 790 | Highest specificity, smallest schema |
| **`data/locus_list_cgMLST99.txt`** | **≥99%** | **1100** | **Default — recommended for outbreak typing** |
| `data/locus_list_cgMLST95.txt` | ≥95% | 1315 | Relaxed; larger core for evolutionary studies |

The schema ships with all alleles for every locus in the largest set. To restrict allele calling to a stricter threshold, pass `--gl data/locus_list_cgMLST100.txt` to `AlleleCall`.

## Limitations

- Source set is biased toward published isolates (clinical, fish-pathogenic, dairy). Environmental and rumen isolates are under-represented and may generate many INF calls.
- 1 059 paralogous loci were excluded. Some may be true single-copy in specific lineages.
- Built from short-read assemblies; complete genome–based refinement would shrink the cgMLST set further.

## Versioning

This is **v1.0**. The schema follows semantic versioning (`MAJOR.MINOR.PATCH`):
- `MAJOR` — locus set changes (loci added/removed).
- `MINOR` — alleles added without changing the locus set.
- `PATCH` — metadata/docs only.

See [`CHANGELOG.md`](CHANGELOG.md).

## License

The schema and associated data are released under [CC BY 4.0](https://creativecommons.org/licenses/by/4.0/). You are free to share and adapt with attribution.

## How to cite

If you use this schema, please cite both this repository and the underlying tools — see [`CITATION.cff`](CITATION.cff).

## Contributing

Bug reports, allele updates from new isolates, and improvements to docs are welcome via pull request or issue. For large additions (e.g. a new geographic/host clade), please open an issue first so we can coordinate a versioned release.
