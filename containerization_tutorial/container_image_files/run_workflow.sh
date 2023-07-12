#!/bin/bash
#=================================================================
# Containerization Tutorial Script
# Step 5 - The workflow script updated to use command-line input
#     parameters.
#=================================================================
# Script: step5-script_with_cl_inputs.sh
# Author: Sarah Keefe
# Last Updated: 2023-06-10
# 
# Purpose: This is the script from step 4 updated to remove any
# specific (hard-coded) information in your variables and to instead
# accept the same variables as inputs when running this script via
# the command line.
#
# More details can be found in the readme at:
#      https://github.com/sarahkeefe/containerizing-neuroimaging-workflows
#
#=================================================================

#-----------------
# INPUTS
#-----------------
# This is where we will set variables that will be used later
# in the script.
# Anything that someone running the container might want to change
# later should be changed to a variable.

# scans_dir
# This is the directory where the organized scan files are. 
# In the tutorial example, the data is organized into sub-folders for each scan session,
# with a second level of sub-folders for each scan in the session.
# This example is using data from OASIS-3 so this example file path matches what you 
# would see when you use one of the OASIS-3 download scripts to download scans from 
# XNAT Central.
scans_dir=${1}

# freesurfers_dir
# This is the full path to the directory where your FreeSurfer output (subject folders) is located.
# This is the same as the FreeSurfer "SUBJECTS_DIR" that you would have used 
# when running FreeSurfer (where the FreeSurfer output folder gets created).
freesurfers_dir=${2}

# output_dir
# The output directory is the full path to a folder where you want your output data 
# to be saved. 
# For this example, when you adapt this script for use in a container, you will want 
# the folder you enter for "output_directory" to exist before you run the script. 
output_dir=${3}

# session_label
# I'm referring to the subject's specific scan session as the "session label". This is 
# an example from the OASIS-3 dataset. Your own data may be named differently.
#
# In the example data structure, the "scans" folder has a subfolder named 
# for the session label that contains scan subfolders.
# The "freesurfers" folder has a subfolder for the Freesurfer output named for this 
# session label. (In the OASIS-3 dataset, FreeSurfer "subject" folder names are 
# named for the scan session they came from.)
# This example script will look for scans in a folder with this name, and look for a
# FreeSurfer output folder that has this name.
session_label=${4}

# dti_scan_id
# Since our example dataset has a subfolder in scans/${session_label} for each scan
# in the session, we will use the scan files in the folder named for this scan ID.
# You may need to make adjustments for this based on how your own data is organized
# and how your scan folders are named.
dti_scan_id=${5}

# TODO fix and decide if I'm going to have people enter the same name 3x.
# DTI scan input filenames
# Below will be the variables for the filenames of each input file you will need

# dti_scan_filename
# The filename of the NIFTI file for your DTI scan for the scan session you are working with.
dti_scan_filename=${6}
dti_bvec_filename=${7}
dti_bval_filename=${8}

# fi_threshold_value and gradient_value
# These are two of the inputs we are sending to the FSL bet command
# fi_threshold_value refers to the input to -f when running bet, which is the value 
# to use for the fractional intensity threshold
fi_threshold_value=${9}
# gradient_value is the input to the bet -g flag, which is used to set the vertical 
# gradient in the fractional intensity threshold
gradient_value=${10}


#-----------------
# WORKFLOW STEPS
#-----------------
# Our workflow starts here.
echo "Starting containerization tutorial workflow script."

# Empty echo line as a line break before the next step
echo ""

# FSL fslroi
echo "Running fslroi"
# Use fslroi to create an image without diffusion weighting
fslroi ${scans_dir}/${session_label}/${dti_scan_id}/${dti_scan_filename} ${output_dir}/${session_label}_nodif.nii.gz 0 1
# Done with fslroi
echo "Done with fslroi"

echo ""

# FSL Brain Extraction Tool (bet)
echo "Running bet"
# Brain extraction on "nodif.nii.gz" - create binary brain masks for DTI scan
bet ${output_dir}/${session_label}_nodif.nii.gz ${output_dir}/${session_label}_nodif_brain.nii.gz -f ${fi_threshold_value} -g ${gradient_value} -m
echo "Done with bet"

echo ""

# FSL eddy_correct 
echo "Running eddy_correct"
# Run eddy_correct on the "dwi.nii.gz" scan file
eddy_correct ${scans_dir}/${session_label}/${dti_scan_id}/${dti_scan_filename} ${output_dir}/${session_label}_eddy_corrected.nii.gz 0
echo "Done with eddy_correct"

echo ""

# FSL dtifit 
echo "Running dtifit"
# dtifit to apply the tensor model to the diffusion data
# Use the eddy_corrected output plus the bet-extracted nodif file
# Incorporate the bvec and bval information that was part of the original DTI scan file set.
dtifit -k ${output_dir}/${session_label}_eddy_corrected.nii.gz -m ${output_dir}/${session_label}_nodif_brain.nii.gz -r ${scans_dir}/${session_label}/${dti_scan_id}/${dti_bvec_filename} -b ${scans_dir}/${session_label}/${dti_scan_id}/${dti_bval_filename} -o ${output_dir}/${session_label}_dtidata
echo "Done with dtifit"

echo ""

echo "Done with containerization tutorial workflow script."