# syntax=docker/dockerfile:1
FROM ubuntu:24.04


ARG DEBIAN_FRONTEND=noninteractive
ARG FASTQC_VERSION=0.12.1


# Base utilities (no compilers here; add as needed per tool)
RUN apt-get update && apt-get install -y --no-install-recommends \
wget unzip ca-certificates default-jre \
&& rm -rf /var/lib/apt/lists/*


# Seed location for preinstalled tools (kept read-only inside image)
RUN mkdir -p /opt/seed/apps


# --- Example tool: FastQC ---
RUN set -eux; \
cd /tmp; \
wget -q "https://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${FASTQC_VERSION}.zip" -O fastqc.zip; \
unzip -q fastqc.zip; \
rm fastqc.zip; \
mv FastQC /opt/seed/apps/FastQC; \
chmod +x /opt/seed/apps/FastQC/fastqc


# Copy entrypoint that syncs tools to $HOME/apps (host-mounted)
COPY entrypoint.sh /usr/local/bin/biogent-entrypoint.sh
RUN chmod +x /usr/local/bin/biogent-entrypoint.sh


# Default entrypoint: prepares $HOME/apps, then runs the requested command
ENTRYPOINT ["/usr/local/bin/biogent-entrypoint.sh"]
# If no command is given, you get a shell (see entrypoint)
CMD []
