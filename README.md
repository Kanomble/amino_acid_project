# eps_project
Analysis of Curvibacter sp. AEP1-3  Growth Media

## Installation

Build from Dockerfile
```bash
docker build -t amino_acid_project:1.0 .
docker run -dt --name amino_acid_project -v ${PWD}:/amino_acid_project/applications -p 127.0.0.1:8888:8888/tcp amino_acid_project:1.0
```

For prokka extension
```bash
docker pull staphb/prokka:latest
cd ../data/curvibacter_assemblies/nucleotide_fasta_files/
docker run -dt --name prokka -v ${PWD}:/amino_acid_project/ staphb/prokka:latest
docker exec -it prokka /bin/bash
```
