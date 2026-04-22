FROM ubuntu:22.04

LABEL version="3.4"
LABEL description="Reproducible MiKTeX environment on Ubuntu 22.04 with XeLaTeX support"

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

# Enable auto-install for missing packages (shared)
RUN initexmf --admin --set-config-value "[MPM]AutoInstall=1"

# Copy local files needed for a test build to "bake in" packages
COPY . /tmp/cv-project/
WORKDIR /tmp/cv-project/

# Pre-install core packages
COPY packages.txt /tmp/packages.txt
RUN miktex --admin packages update-package-database && \
    miktex --admin packages update && \
    while read p; do \
      echo "Installing package: $p"; \
      miktex --admin packages install "$p" || echo "Warning: Could not install $p"; \
    done < /tmp/packages.txt

# Bake in on-the-fly packages by running test compilations
# This will trigger auto-installation for both pdflatex and xelatex dependencies.
# We create a dummy fonts dir if it doesn't exist to prevent xelatex from failing hard on Zapfino
RUN mkdir -p output && \
    mkdir -p restaurant_menu/fonts && \
    pdflatex -interaction=nonstopmode -output-directory=output en/main.tex || echo "pdflatex bake done" && \
    xelatex -interaction=nonstopmode -output-directory=output restaurant_menu/restaurant_menu.xelatex || echo "xelatex bake done"

# Final setup and cleanup
RUN initexmf --admin --update-fndb && \
    miktex --admin links install && \
    miktex --admin formats build pdflatex && \
    miktex --admin formats build xelatex && \
    initexmf --admin --mklinks --force && \
    rm -rf /var/cache/miktex && \
    rm -rf /tmp/cv-project

# Setup user
ARG user=miktex
ARG uid=1000
RUN useradd -u ${uid} -m -s /bin/bash ${user}
USER ${user}
WORKDIR /home/${user}/work

# Default entrypoint
ENTRYPOINT ["pdflatex"]
CMD ["--help"]
