# Building a Nextflow Bioinformatics Environment with Docker on AlmaLinux 8 

This repository contains a Dockerfile for building a Nextflow bioinformatics environment on AlmaLinux 8.

## Maintainer

Sarayut (Nine) Winuthayanon: [LinkedIn](https://www.linkedin.com/in/winuthayanons/)

### Note: 
Please replace `your-docker-username` with your actual Docker Hub username.

### Optional: Remote login to private server
```
ssh -p 50077 ${USER}@bac.beenplus.com
```

### Clone nf_bio repository
```
mkdir -p ~/data/git
cd ~/data/git
git clone git@github.com:mubioinformatics/nf_bio.git
cd ~/data/git/nf_bio
```

### Optional: Clean up unused or dangling Docker objects like containers, networks, images, etc.
```
docker system prune -a
```

### Login to Docker Hub
```
docker login -u your-docker-username
```

### Build the Docker image
```
docker build -t your-docker-username/nf_bio:almalinux8 . -f Dockerfile
```

### Push the Docker image to Docker Hub
```
docker push your-docker-username/nf_bio:almalinux8
```

### Pull the Singularity image on a private server
```
cd ~/data/git/nf_bio/test
singularity pull docker://your-docker-username/nf_bio:almalinux8
```

### Or Pull the Singularity image on the Cluster
```
ssh ${USER}@lewis42.rnet.missouri.edu
srun -p Gpu --account ircf -N1 -n4 -t 0-2:00 --mem=32G --pty /bin/bash
module load singularity
cd ~/data/git/nf_bio/test
singularity pull docker://your-docker-username/nf_bio:almalinux8
```

### Optional: Clear the Singularity cache
```
singularity cache clean
```

### Run Singularity on your private server
```
singularity run nf_bio_almalinux8.sif

nextflow run main.nf
# rm -rf .nextflow* out/ work/
# or
nextflow run main.nf --outdir out_test
# rm -rf .nextflow* out_test/ work/
```

### Run Singularity with a specific version
```
NXF_VER=21.04.1 nextflow -version
# or
export NXF_VER=21.04.1
nextflow -version
```

### Run Singularity with clean environments
```
singularity run --cleanenv nf_bio_almalinux8.sif
```

### Run Singularity with a blind mount of the current directory
```
singularity run --bind $(pwd):/data nf_bio_almalinux8.sif
```

### Or on the Cluster
```
ssh ${USER}@lewis42.rnet.missouri.edu
srun -p Gpu --account ircf -N1 -n4 -t 0-2:00 --mem=32G --pty /bin/bash

cd ~/data/git/nf_bio/test
SIF_FILE="/storage/hpc/data/${USER}/git/nf_bio/test/nf_bio_almalinux8.sif"
singularity run --bind $(pwd):/data --writable-tmpfs --cleanenv ${SIF_FILE}
cd /data
nextflow run main.nf
# rm -rf .nextflow* out/ work/

# or
cd ~/data/git/nf_bio/test
SIF_FILE="/storage/hpc/data/${USER}/git/nf_bio/test/nf_bio_almalinux8.sif"
singularity exec --bind $(pwd):/data --writable-tmpfs --cleanenv ${SIF_FILE} /data/run.sh
# rm -rf .nextflow* out/ work/
```

# Optional: How to use an external $PATH
```
singularity run --bind /storage/hpc:/storage/hpc --bind $(pwd):/data --writable-tmpfs --cleanenv ${SIF_FILE}
export PATH=$PATH:/storage/hpc/group/ircf/software/bin
# or
export PATH=/storage/hpc/group/ircf/software/bin:$PATH
```

# How to run with Docker

### Pull the Docker image
```
docker pull your-docker-username/nf_bio:almalinux8
```

### Run the image with a mounted data volume
```
docker run -it -v $PWD:/data your-docker-username/nf_bio:almalinux8
```