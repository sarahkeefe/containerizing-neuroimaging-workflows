# Use FreeSurfer version 7.3.2 as the base image
FROM freesurfer/freesurfer:7.3.2

# Copy in my Freesurfer license file so Freesurfer can run
COPY license.txt /usr/local/freesurfer/.license

# freesurfer/freesurfer:7.3.2 uses CentOS 8
# Install programs using a CentOS 8 package manager
# First clean and update the package repository - just like we would do on a totally new OS installation
RUN yum clean all && yum -y update 

# Then install some dependencies I will need for the next program download and installation steps
# The FSL installer script requires python3
# FSL fslreorient2std requires "bc"
# FSL flirt requires openblas
RUN yum -y install epel-release bc git openblas python3 tar unzip wget

# Run the "fs_install_mcr" script to install the Freesurfer MATLAB compiler runtime
# This step wasn't done by default in the base container.
RUN /usr/local/freesurfer/bin/fs_install_mcr R2014b

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
