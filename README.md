# Dockerfile to build a Nextflow bioinformatics environment on AlmaLinux 8 

### Optional How to install docker on AlmaLinux 8    
```
sudo dnf -y --refresh update
sudo dnf -y upgrade
sudo dnf -y install yum-utils
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo dnf -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo systemctl start docker
sudo systemctl enable docker
```

### Optional How to install Apptainer on AlmaLinux 8  
```  
sudo dnf install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
wget -c https://github.com/apptainer/apptainer/releases/download/v1.2.3/apptainer-1.2.3-1.x86_64.rpm
sudo dnf -y install apptainer-1.2.3-1.x86_64.rpm 
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

### Build image
```
docker build -t your-docker-account/nf_bio:almalinux8 . -f Dockerfile
```

### Login to docker hub
```
docker login -u your-docker-account
```

### Push image to Docker Hub
```
docker push your-docker-account/nf_bio:almalinux8
```

### Pull Singularity image
```
cd ~/data/git/nf_bio/test
singularity pull docker://your-docker-account/nf_bio:almalinux8
# or login to cluster to pull
ssh ${USER}@lewis42.rnet.missouri.edu
srun -p Gpu --account ircf -N1 -n4 -t 0-2:00 --mem=32G --pty /bin/bash
module load singularity
cd ~/data/git/nf_bio/test
singularity pull docker://your-docker-account/nf_bio:almalinux8
```

### Clear Singularity cache
```
singularity cache clean
```

### Run Singularity
```
singularity run nf_bio_almalinux8.sif
# or
nextflow run main.nf --outdir out_test
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
SIF_FILE="/home/sw7v6/sif/nf_bio_almalinux8.sif"
SIF_FILE="/home/sw7v6/data/git/sif/nf_bio_almalinux8.sif"
singularity run --bind $(pwd):/data --writable-tmpfs --cleanenv ${SIF_FILE}
# Command line below it's going to use your home directory to
singularity exec --bind $(pwd):/data --writable-tmpfs --cleanenv ${SIF_FILE} /data/run.sh
singularity exec --bind $(pwd):/data --writable-tmpfs --cleanenv ${SIF_FILE} nextflow run /data/test/main.nf --inputdir "/data/test/fastq_data" --outdir "/data/test/out_test" -work-dir "/storage/hpc/scratch/sw7v6/work"
```

# How to run with Docker

### Pull docker image
```
docker pull your-docker-account/nf_bio:almalinux8
```

### Run image with mounted data volume
```
docker run -it -v $PWD:/data your-docker-account/nf_bio:almalinux8
```
