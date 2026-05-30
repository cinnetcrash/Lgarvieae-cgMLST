# Using the schema

## Requirements

- [chewBBACA](https://github.com/B-UMMI/chewBBACA) ≥ 3.5.3
- BLAST+ (installed automatically with chewBBACA via conda)
- 4+ CPU cores recommended; 8+ for larger isolate sets

Conda install:

```bash
conda create -n chewie -c bioconda chewbbaca
conda activate chewie
```

## Type a new isolate

```bash
chewBBACA.py AlleleCall \
    -i path/to/my_new_genomes/ \
    -g schema \
    -o my_results \
    --cpu 8
```

Inputs:
- `-i` — a directory of assembled `.fasta` files (one genome per file). Draft assemblies are fine.
- `-g` — the `schema/` directory from this repo.
- `-o` — where the output goes.

Key output files (in `my_results/`):
- `results_alleles.tsv` — allelic profile per isolate.
- `results_statistics.tsv` — per-isolate counts of EXC / INF / paralog calls.
- `paralogous_loci.tsv` — loci flagged as paralogous in your isolates.

## Use a stricter or more relaxed locus set

The schema ships with three pre-extracted locus lists. To restrict allele calling to a specific subset (e.g. cgMLST100):

```bash
chewBBACA.py AlleleCall \
    -i my_new_genomes/ \
    -g schema \
    -o my_results \
    --gl data/locus_list_cgMLST100.txt \
    --cpu 8
```

## Compare profiles between isolates

[GrapeTree](https://github.com/achtman-lab/GrapeTree) is the easiest tool:

```bash
pip install grapetree
grapetree --profile my_results/results_alleles.tsv --method MSTreeV2 > tree.nwk
```

Open `tree.nwk` in any tree viewer (FigTree, iTOL) or directly in the GrapeTree web app.

[PHYLOViZ Online](https://online.phyloviz.net/) accepts the same TSV without conversion.

## Combine your profiles with the reference set

```bash
chewBBACA.py JoinProfiles \
    -p data/example_profiles_247genomes.tsv my_results/results_alleles.tsv \
    -o combined_profiles.tsv
```

Now `combined_profiles.tsv` lets you see where your isolates fall relative to the 247 build genomes.

## Submit new alleles back to the schema

If your isolates introduce many INF (inferred new) alleles that you'd like to share, please open a pull request with:
- The `results_alleles.tsv` from your AlleleCall run.
- A short note on the host/source of the new isolates.

We'll merge alleles into a MINOR version bump.

## Troubleshooting

**"No bins found" / no FASTA detected** — check `-i` points at a directory of `.fasta` files (default extension). Pass `-x fna` or `-x fasta` to override.

**Many ALM/ASM calls** — alleles fall outside the size variation threshold (0.2 by default). Consider whether your isolates are contaminated or come from a divergent lineage.

**AlleleCall is slow** — increase `--cpu`. Memory is rarely the bottleneck; BLAST CPU is.

**Schema config mismatch errors** — make sure you're using chewBBACA ≥ 3.5.3. Older versions wrote a different config format.
