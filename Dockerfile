FROM ubuntu:22.04

LABEL version="3.5"
LABEL description="MiKTeX environment on Ubuntu 22.04 with XeLaTeX support"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies for MiKTeX repo setup
RUN apt-get update && apt-get install -y \
    curl \
    gnupg2 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Add MiKTeX repository
RUN curl -fsSL https://miktex.org/download/key | gpg --dearmor -o /usr/share/keyrings/miktex.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/miktex.gpg] https://miktex.org/download/ubuntu jammy universe" | tee /etc/apt/sources.list.d/miktex.list

# Install MiKTeX
RUN apt-get update && apt-get install -y \
    miktex \
    && rm -rf /var/lib/apt/lists/*

# Finish MiKTeX setup (shared mode)
RUN miktexsetup finish

# Enable auto-install for missing packages, into the shared tree
# (without AutoAdmin, installs triggered as root land in /root/.miktex and are
# invisible to the runtime user)
RUN initexmf --admin --set-config-value "[MPM]AutoInstall=1" && \
    initexmf --admin --set-config-value "[MPM]AutoAdmin=1"

# Pre-install core packages.
# The package database is refreshed in the same layer, so a cached layer never
# pairs a stale database with a newer remote repository ("Unknown archive file size").
# Note: l3backend is no longer a separate MiKTeX package; its .def files ship in l3kernel.
COPY packages.txt /tmp/packages.txt
RUN miktex --admin packages update-package-database && \
    miktex --admin packages update && \
    while read p; do \
      echo "Installing package: $p"; \
      miktex --admin packages install "$p" || \
        { sleep 5; miktex --admin packages install "$p"; } || \
        echo "Warning: Could not install $p"; \
    done < /tmp/packages.txt && \
    initexmf --admin --update-fndb && \
    miktex --admin formats build pdflatex && \
    miktex --admin formats build xelatex && \
    kpsewhich l3backend-pdftex.def

# Bake in on-the-fly packages by compiling smoke tests that mirror the CV classes.
# AutoInstall pulls in anything missing; a failing compile fails the image build.
COPY smoke/ /tmp/smoke/
WORKDIR /tmp/smoke
RUN for f in altacv-deps developercv-deps; do \
      pdflatex -interaction=nonstopmode -halt-on-error $f.tex && \
      pdflatex -interaction=nonstopmode -halt-on-error $f.tex || { tail -40 $f.log; tail -30 /root/.miktex/texmfs/data/miktex/log/pdflatex.log; exit 1; }; \
    done && \
    xelatex -interaction=nonstopmode -halt-on-error xelatex-deps.tex || { tail -40 xelatex-deps.log; exit 1; }

# Final setup and cleanup
WORKDIR /
RUN initexmf --admin --update-fndb && \
    miktex --admin links install && \
    miktex --admin formats build pdflatex && \
    miktex --admin formats build xelatex && \
    initexmf --admin --mklinks --force && \
    rm -rf /var/cache/miktex /tmp/smoke /tmp/packages.txt

# Setup user
ARG user=miktex
ARG uid=1000
RUN useradd -u ${uid} -m -s /bin/bash ${user}
USER ${user}
WORKDIR /home/${user}/work

# Default entrypoint
ENTRYPOINT ["pdflatex"]
CMD ["--help"]
