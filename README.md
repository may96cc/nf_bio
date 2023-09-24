# Dockerfile to build a Nextflow bioinformatics environment on AlmaLinux 8 

## Maintainer

Sarayut (Nine) Winuthayanon: [LinkedIn](https://www.linkedin.com/in/winuthayanons/)

### Please change `winuthayanon` to `your-docker-username`

### Optional remote login to private server
```
ssh -p 50077 ${USER}@bac.beenplus.com
```

### Clone nf_bio
```
mkdir -p ~/data/git
cd ~/data/git
git clone git@github.com:mubioinformatics/nf_bio.git
cd ~/data/git/nf_bio
```

### Clean up unused or dangling Docker objects like containers, networks, images etc.
```
docker system prune -a
```

### Login to docker hub
```
docker login -u winuthayanon
```

### Build image
```
docker build -t winuthayanon/nf_bio:almalinux8 . -f Dockerfile
```

### Push image to Docker Hub
```
docker push winuthayanon/nf_bio:almalinux8
```

### Pull Singularity image on private server
```
cd ~/data/git/nf_bio/test
singularity pull docker://winuthayanon/nf_bio:almalinux8
```

### Or Pull Singularity image on Cluster
```
ssh ${USER}@lewis42.rnet.missouri.edu
srun -p Gpu --account ircf -N1 -n4 -t 0-2:00 --mem=32G --pty /bin/bash
module load singularity
cd ~/data/git/nf_bio/test
singularity pull docker://winuthayanon/nf_bio:almalinux8
```

### Clear Singularity cache
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

### Run Singularity with specific version
```
NXF_VER=21.04.1 nextflow -version
# or
export NXF_VER=21.04.1
nextflow -version
```

### Run Singularity with clean evironments
```
singularity run --cleanenv nf_bio_almalinux8.sif
```

### Run Singularity with blind mount current directory
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

# How to run with Docker

### Pull docker image
```
docker pull winuthayanon/nf_bio:almalinux8
```

### Run image with mounted data volume
```
docker run -it -v $PWD:/data winuthayanon/nf_bio:almalinux8
```
