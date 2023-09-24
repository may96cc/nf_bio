# Dockerfile to build a Nextflow bioinformatics environment on AlmaLinux 8
FROM almalinux:8

# Label with maintainer info
LABEL Maintainer="Sarayut (Nine) Winuthayanon, https://www.linkedin.com/in/winuthayanons/"

# Update packages and install deps like Java 11, wget, tree
RUN dnf update -y && \
    dnf install -y wget tree java-11-openjdk-devel

# Install Nextflow
RUN wget -qO- https://get.nextflow.io | bash \
  && mv nextflow /usr/local/bin \
  && chmod 755 /usr/local/bin/nextflow 

# Install Miniconda and set PATH
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
RUN bash ~/miniconda.sh -b -p /opt/miniconda
RUN rm -f ~/miniconda.sh
ENV PATH="/opt/miniconda/bin:${PATH}"

# Install Python packages via Conda and Pip 
RUN conda update -n base conda -y
RUN conda install -c bioconda fastqc trimmomatic
RUN pip install multiqc