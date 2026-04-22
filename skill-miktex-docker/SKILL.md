---
name: miktex-docker-builder
description: Workflows for building and maintaining the MiKTeX Docker image. Use when the user wants to update packages, rebuild the image, or fix Docker-related LaTeX compilation issues.
---

# MiKTeX Docker Builder

This skill provides specialized workflows for maintaining the `zacsek/miktex` Docker image.

## Building the Image

To build the MiKTeX image:

1.  Use `Dockerfile` and `packages.txt`.
2.  Run the Makefile target:
    ```bash
    make build
    ```

## Managing MiKTeX Packages

When updating or adding new LaTeX packages, modify `packages.txt` and rebuild the image.

The `Dockerfile` uses a "baking" strategy:
1.  Starts from `ubuntu:22.04`.
2.  Installs MiKTeX from official repositories.
3.  Pre-installs a core set of packages via `miktex packages install` from `packages.txt`.
4.  Pre-generates formats (`pdflatex.fmt`, `xelatex.fmt`) and links as root.

### Minimizing Docker Image Size

To keep your MiKTeX image lean:
- Only add necessary packages to `packages.txt`.
- The Dockerfile already includes cleanup commands (`rm -rf /var/cache/miktex`).