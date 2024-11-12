# AUTHOR Lukas Becker
# amino acid project GitHub
# miniconda - Dockerfile
#

#base image; maybe choose another image
FROM ubuntu:focal

# Download and install required software
RUN apt-get update -y && apt-get upgrade -y && apt-get install curl -y && apt-get install wget bzip2 libdw1 -y && apt-get install libgl1-mesa-glx -y && apt-get install libglib2.0-0 -y
RUN apt-get update -y && (apt-get install -t buster-backports -y mafft fasttree || apt-get install -y mafft fasttree)

# Software and packages for the E-Direct Tool
RUN apt-get -y -m update && DEBIAN_FRONTEND="noninteractive" apt-get install -y cpanminus libxml-simple-perl libwww-perl libnet-perl build-essential tzdata

ENV TZ=Europe/Berlin
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# set working directory
WORKDIR /amino_acid_project

# Download & install BLAST
# This RUN cmd might fail due to connection problems with NCBI servers, if you face any issues, repeat the build step
RUN curl ftp://ftp.ncbi.nlm.nih.gov/blast/executables/blast+/2.11.0/ncbi-blast-2.11.0+-x64-linux.tar.gz | tar -zxvpf-

# Download & install NCBI EDIRECT
#RUN curl -s ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/edirect.tar.gz | \
# tar xzf - && \
# cpanm HTML::Entities && \
# edirect/setup.sh
#new command for downloading the e-direct software
RUN sh -c "$(curl -fsSL ftp://ftp.ncbi.nlm.nih.gov/entrez/entrezdirect/install-edirect.sh)"
RUN mv $HOME/edirect .

# Update path environment variable
ENV PATH="/amino_acid_project/edirect:$PATH"

# Update path environment variable
ENV PATH="/amino_acid_project/ncbi-blast-2.11.0+/bin:$PATH"

# Download and install anaconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_23.1.0-1-Linux-x86_64.sh
#-b Batch mode with no PATH modifications to ~/.bashrc
RUN bash Miniconda3-py38_23.1.0-1-Linux-x86_64.sh -b -p /amino_acid_project/miniconda3
RUN rm Miniconda3-py38_23.1.0-1-Linux-x86_64.sh

# Update path environment variable
ENV PATH="/amino_acid_project/miniconda3/bin:$PATH"

# Add conda channels
RUN conda config --add channels defaults
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge
RUN conda config --set channel_priority strict
RUN conda install notebook
# RUN conda install -c conda-forge -c bioconda -c defaults prokka
# Download wget and pandas
COPY requirements.txt /amino_acid_project/
RUN pip install -r requirements.txt

RUN mkdir /amino_acid_project/applications
COPY . /amino_acid_project/applications

#set appropriate working directory in order to allow development with docker
WORKDIR /amino_acid_project/applications

# Delete not required packages etc..
RUN apt-get autoremove --purge --yes && apt-get clean && rm -rf /var/lib/apt/lists/*
# Optional commands e.g. initiating scripts

#open port for jupyter notebook
EXPOSE 8888

CMD ["jupyter", "nbclassic", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
