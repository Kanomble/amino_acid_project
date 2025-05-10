# Amino Acid Project
## Analysis of Curvibacter sp. AEP1-3  Growth Media
This project aims to analyze the effect of different amino acid compositions
on the growth behavior of the $\beta$-proteobacterium and facultative symbiont of *Hydra vulgaris* AEP, *Curvibacter* sp. AEP1-3.

## Installation
Download the repository and decompress all data files.
Build from Dockerfile:

```bash
docker build -t amino_acid_project:1.0 .
docker run -dt --name amino_acid_project -v ${PWD}:/amino_acid_project/applications -p 127.0.0.1:8888:8888/tcp amino_acid_project:1.0
```

## Data Availability
Missing data files can be requested by writing an E-Mail to the author of this repository. 
