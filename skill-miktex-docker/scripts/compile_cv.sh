#!/bin/bash
# Script to compile LaTeX CV using MiKTeX Docker container

set -e

if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <tex_file> [docker_image]"
    exit 1
fi

TEX_FILE=$1
DOCKER_IMAGE=${2:-"zacsek/miktex:full"}
OUTPUT_DIR="output"

mkdir -p "$OUTPUT_DIR"

echo "Compiling $TEX_FILE using $DOCKER_IMAGE..."

# Use absolute path for pwd to avoid issues with some docker versions
PWD=$(pwd)

docker run --rm -t \
    --network none \
    -v "$PWD":/data \
    "$DOCKER_IMAGE" \
    "pdflatex -interaction=nonstopmode -output-directory=$OUTPUT_DIR $TEX_FILE"

echo "Compilation successful. Output in $OUTPUT_DIR/"
