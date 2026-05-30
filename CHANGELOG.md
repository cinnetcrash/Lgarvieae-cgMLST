# Changelog

All notable changes to this schema will be documented here.
This project follows [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`):

- `MAJOR` — the locus set changes (loci added or removed).
- `MINOR` — alleles are added/updated without changing the locus set.
- `PATCH` — documentation, metadata, or reports only.

## [1.0.1] — 2026-05-30

### Added
- Zenodo deposit metadata (`.zenodo.json`) so GitHub releases mint a citable DOI automatically.
- DOI badge in `README.md`.

### Notes
- Schema content (loci, alleles, training file) is unchanged from v1.0.

## [1.0] — 2026-05-29

### Added
- Initial release.
- 1100 cgMLST loci (≥99% presence in build set).
- Two alternative locus sets shipped: cgMLST100 (790 loci) and cgMLST95 (1315 loci).
- Prodigal training file (`schema/Lgarvieae.trn`, table 11).
- Example allelic profiles for the 247 build genomes (`data/example_profiles_247genomes.tsv`).
- Interactive HTML reports (`reports/`).

### Build provenance
- Source: 247 high-quality *L. garvieae* assemblies (post-QC from a 250-genome PubMLST set).
- QC stack: seqkit + QUAST 5.2.0 + BUSCO 5.8.3 (lactobacillales_odb12) + CheckM2 1.1.0.
- Schema construction: chewBBACA v3.5.3, BSR 0.6, default size threshold 0.2.
- 1059 paralogous loci excluded after the build AlleleCall.
