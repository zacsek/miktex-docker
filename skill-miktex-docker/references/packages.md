# LaTeX Packages for CV Generation

The following packages are required for the `altacv` and `developercv` classes. This list is used in the reproducible Dockerfile.

## Package List
- `accsupp`: Accessibility support.
- `adjustbox`: Graphics adjustment.
- `auxhook`: Hooks for auxiliary files.
- `changepage`: Page layout changes.
- `cmap`: Better search/copy-paste for pdfLaTeX.
- `collectbox`: Box collection.
- `dashrule`: Dashed rules.
- `enumitem`: List customization.
- `environ`: Environment handling.
- `epstopdf-pkg`: Convert EPS to PDF.
- `etoolbox`: Tool box for LaTeX programming.
- `everyshi`: Every shipout.
- `extsizes`: Base class extensions.
- `fontawesome5`: Modern icons.
- `fontawesome`: Legacy icons (used by DeveloperCV).
- `fontaxes`: Font selection tools.
- `geometry`: Page layout management.
- `hycolor`: Color for hyperref.
- `hyperref`: Clickable links.
- `ifmtarg`: Check if macro argument is empty.
- `koma-script`: scrlfile and others.
- `kvoptions`: Key-value options.
- `kvsetkeys`: Key-value management.
- `lato`: Lato font.
- `lipsum`: Placeholder text.
- `multirow`: Multi-row table cells.
- `paracol`: Parallel columns.
- `pdfx`: PDF/A support.
- `pgf`: TikZ backend.
- `ragged2e`: Better ragged alignment.
- `raleway`: Raleway font.
- `refcount`: Reference counting.
- `rerunfilecheck`: Check if rerun is needed.
- `roboto`: Roboto font.
- `tcolorbox`: Colored boxes.
- `tikzfill`: TikZ fill patterns.
- `trimspaces`: Space trimming.
- `url`: URL handling.
- `xcolor`: Color management.
- `xkeyval`: Key-value options.
- `xmpincl`: XMP metadata.
- `latex-tools`: Standard LaTeX tools (including `longtable`, `multicol`).
- `biber`: Bibliography backend.
- `latex-bin`: Core LaTeX binaries.
- `pdflatex`: pdfLaTeX engine.

## Reproducible Build
The `Dockerfile.new` uses a "baking" strategy:
1.  Starts from `ubuntu:22.04`.
2.  Installs MiKTeX from official repositories.
3.  Pre-installs a core set of packages via `miktex packages install`.
4.  Runs a "test compilation" during build to trigger `AutoInstall` for any remaining dependencies (like `ms`, `showframe`, `luxi`).
5.  Pre-generates formats (`pdflatex.fmt`) and links as root.

Build the image:
```bash
docker build -t zacsek/miktex:reproducible -f Dockerfile.new .
```
