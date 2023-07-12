# Use Ubuntu 22:04 as the base image
FROM ubuntu:22.04

# Install programs using an Ubuntu package manager
# First clean and update the package repository - just like we would do on a totally new OS installation
RUN apt-get -y update && apt-get -y upgrade

# Then install some dependencies I will need for the next program download and installation steps
# The FSL installer script requires python3
# FSL fslreorient2std requires "bc"
# FSL flirt requires openblas
RUN apt-get -y install bc git openblas tar wget curl zip unzip python3

# FreeSurfer installation and setup
# Use "wget" to download FreeSurfer 7.3.2 tar.gz file and save it as "fs.tar.gz"
RUN wget https://surfer.nmr.mgh.harvard.edu/pub/dist/freesurfer/7.3.2/freesurfer-linux-ubuntu22_amd64-7.3.2.tar.gz -O fs.tar.gz

# Use "tar" to untar the downloaded FreeSurfer program .tar.gz file
# Use --exclude to exclude some directories we don't need, to keep the container image size down
RUN tar --no-same-owner -xzvf fs.tar.gz \
    --exclude='freesurfer/trctrain' \
    --exclude='freesurfer/subjects/fsaverage_sym' \
    --exclude='freesurfer/subjects/fsaverage3' \
    --exclude='freesurfer/subjects/fsaverage4' \
    --exclude='freesurfer/subjects/fsaverage5' \
    --exclude='freesurfer/subjects/fsaverage6' \
    --exclude='freesurfer/subjects/cvs_avg35' \
    --exclude='freesurfer/subjects/cvs_avg35_inMNI152' \
    --exclude='freesurfer/subjects/bert' \
    --exclude='freesurfer/subjects/V1_average' \
    --exclude='freesurfer/average/mult-comp-cor'

# The extracted .tar.gz file automatically is in a folder "freesurfer".
# Move this folder to /usr/local, because that is where I want it installed.
RUN mv freesurfer /usr/local

# Remove the .tar.gz file we downloaded and unzipped
RUN rm fs.tar.gz

# Set up some required FS environment variables 
# Set the OS variable based on our container image operating system
ENV OS Linux

# Set these based on where we just installed the program (in /usr/local/freesurfer)
ENV FREESURFER_HOME /usr/local/freesurfer
ENV FREESURFER /usr/local/freesurfer
ENV SUBJECTS_DIR /usr/local/freesurfer/subjects
ENV LOCAL_DIR /usr/local/freesurfer/local
ENV FSFAST_HOME /usr/local/freesurfer/fsfast
ENV FMRI_ANALYSIS_DIR /usr/local/freesurfer/fsfast
ENV FUNCTIONALS_DIR /usr/local/freesurfer/sessions

# Set environment variables that specify default FreeSurfer options
ENV FS_OVERRIDE 0
ENV FIX_VERTEX_AREA ""
ENV FSF_OUTPUT_FORMAT nii.gz

# Set environment variables for MNI requirements
ENV MINC_BIN_DIR /usr/local/freesurfer/mni/bin
ENV MINC_LIB_DIR /usr/local/freesurfer/mni/lib
ENV MNI_DIR /usr/local/freesurfer/mni
ENV MNI_DATAPATH /usr/local/freesurfer/mni/data
ENV PERL5LIB /usr/local/freesurfer/mni/lib/perl5/5.8.5
ENV MNI_PERL5LIB /usr/local/freesurfer/mni/lib/perl5/5.8.5

# Modify the PATH variable to incorporate the FreeSurfer folder paths
ENV PATH /usr/local/freesurfer/bin:/usr/local/freesurfer/fsfast/bin:/usr/local/freesurfer/tktools:/usr/local/freesurfer/mni/bin:$PATH

# Copy in my Freesurfer license file so Freesurfer can run
COPY license.txt /usr/local/freesurfer/.license

# Run the "fs_install_mcr" script to install the Freesurfer MATLAB compiler runtime
RUN /usr/local/freesurfer/bin/fs_install_mcr R2014b

# FSL installation and setup
# Download FSL installer Python script
RUN wget -q http://fsl.fmrib.ox.ac.uk/fsldownloads/fslinstaller.py && chmod 775 fslinstaller.py

# Run the FSL installer python script
# We are installing FSL to /usr/local/fsl within the container
RUN python3 fslinstaller.py -d /usr/local/fsl --fslversion 6.0.4

# Set FSL-related environment variables
# FSL installer installed to /usr/local/fsl in the previous step, so that is our FSLDIR
ENV FSLDIR /usr/local/fsl

# Other FSL environment variables
# You can change these if you want depending on your preferred settings
ENV FSLMULTIFILEQUIT TRUE
ENV FSLOUTPUTTYPE NIFTI_GZ

# Add the FSLDIR to the PATH variable within the container image so 
# FSL programs appear in the command line when you run a container.
ENV PATH $FSLDIR/bin:$PATH

# Run the FSL config setup script
RUN /bin/bash -c 'source /usr/local/fsl/etc/fslconf/fsl.sh'

# Example of copying over a folder of parcellation files into your container
# The "parc" directory in your folder and all its contents will get copied to /usr/local/parc
COPY parc /usr/local/parc

# Copy your run script into the container
# I'm copying it to /usr/local/bin but you can put it wherever you like.
COPY run_workflow.sh /usr/local/bin/run_workflow.sh
