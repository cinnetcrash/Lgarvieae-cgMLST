#!/usr/bin/env bash
#
# Minimal example: type a directory of new L. garvieae assemblies against the
# shipped cgMLST schema.
#
# Usage:
#   ./type_new_isolate.sh <genome_dir> <output_dir> [cpu]
#
# Where <genome_dir> contains one .fasta per isolate.

set -euo pipefail

GENOME_DIR="${1:?Usage: $0 <genome_dir> <output_dir> [cpu]}"
OUT_DIR="${2:?Usage: $0 <genome_dir> <output_dir> [cpu]}"
CPU="${3:-8}"

SCHEMA_DIR="$(cd "$(dirname "$0")/.." && pwd)/schema"

if [[ ! -d "$SCHEMA_DIR" ]]; then
    echo "ERROR: schema not found at $SCHEMA_DIR" >&2
    exit 1
fi

if ! command -v chewBBACA.py >/dev/null 2>&1; then
    echo "ERROR: chewBBACA.py not on PATH. Activate the chewBBACA conda env first:" >&2
    echo "    conda activate chewie" >&2
    exit 1
fi

mkdir -p "$OUT_DIR"

chewBBACA.py AlleleCall \
    -i "$GENOME_DIR" \
    -g "$SCHEMA_DIR" \
    -o "$OUT_DIR" \
    --cpu "$CPU"

echo
echo "Done. Allelic profiles written to: $OUT_DIR/results_alleles.tsv"
echo
echo "Next: build a tree with GrapeTree, e.g."
echo "    grapetree --profile $OUT_DIR/results_alleles.tsv --method MSTreeV2 > tree.nwk"
