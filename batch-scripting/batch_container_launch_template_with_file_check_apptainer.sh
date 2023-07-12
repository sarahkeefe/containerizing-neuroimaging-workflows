#!/bin/bash
#=================================================================
# Containerization Tutorial
# Batch container launching script example - Apptainer
# Contains extra steps for checking whether files exist before 
# the container launch step
#=================================================================
# Script: batch_container_launch_template_with_file_check_apptainer.sh
# Author: Sarah Keefe
# Last Updated: 2023-07-11
# 
# Purpose: This script is intended as a template for you to batch run
#      an Apptainer container that you build locally. Follow the 
#      instructions in the online documentation to integrate your 
#      container launch command into this script.
#
# Usage: ./batch_container_launch_template_with_file_check_apptainer.sh 
#       list.csv scans_dir freesurfers_dir output_dir
#     - "list.csv" should be a Unix-formatted, comma separated file 
#         that contains the columns required for your workflow.
#         Before editing, this example uses the containerization 
#         tutorial container image and requires the following 
#         columns in the file:
#           - session_label (The label for the scan session, which
#              should be identical to the folder names in the
#              scans and freesurfers directories)
#           - dti_scan_id (The ID of the DTI scan to use for this session)
#           - fi_threshold_value (the threshold value to send to FSL
#              BET for processing this session)
#           - gradient_value (the gradient value to send to FSL BET
#              for processing this session)
#     - scans_dir should be an absolute path (that starts with "/")
#         to the directory where your session folders with scans are
#         located. The scans directory should contain a folder for
#         each session_label in your CSV, with scan files in it.
#     - freesurfers_dir should be an absolute path (that starts 
#         with "/") to the directory where your FreeSurfer ouptut 
#         folders are located (the same path you would have set as 
#         your FreeSurfer SUBJECTS_DIR after running recon-all. 
#         The FreeSurfers directory should contain a folder for
#         each session_label in your CSV, with its FreeSurfer output 
#         in it.
#     - output_dir should be an absolute path (that starts with "/")
#         to a folder where you want your output data to be saved. In
#         this example template script, this folder will be created
#         if it doesn't already exist.
#
# More details can be found in the readme at:
#      https://github.com/sarahkeefe/containerizing-neuroimaging-workflows
#
#=================================================================

#-----------------
# INPUTS
#-----------------
# input_file
# This should be the name of a Unix-formatted CSV file that will be
# read by this script. The file should contain columns for each variable
# that your run_workflow.sh command needs as input for an individual item
# in your dataset.
# In the example provided, this is a list of scan session labels, scan
# IDs, and corresponding input values to enter into the script (in the
# example DTI containerization workflow this is values for the "fi 
# threshold" and "gradient value" that are inputs to FSL BET).
input_file=${1}

# scans_dir
# This is the directory where the organized scan files are. 
# In the tutorial example, the data is organized into sub-folders for 
# each scan session, with a second level of sub-folders for each scan 
# in the session.
# The scans directory contains one folder named for each session_label, 
# with a sub-folder named for the "dti_scan_id" with the DTI scan files c
# contained in that folder, like this:
# ├── scans (folder)
# │   └── OAS30001_MR_d3132 (folder containing scan subfolders for session)
# │       └── dwi1 (folder for scan ID="dwi1" for session "OAS30001_MR_d3132")
# │           ├── sub-OAS30001_sess-d3132_run-01_dwi.nii.gz (NIFTI file for scan dwi1)
# │           ├── sub-OAS30001_sess-d3132_run-01_dwi.bvec (bvec file for scan dwi1)
# │           ├── sub-OAS30001_sess-d3132_run-01_dwi.bval (bval file for scan dwi1)
# │           └── sub-OAS30001_sess-d3132_run-01_dwi.json (BIDS .json file for scan dwi1)
# The .nii.gz, .json, .bvec, and .bval files should have the same 
# base filename but with different file extensions.
# This example is using data from OASIS-3 so this example file path 
# matches what you would see when you use one of the OASIS-3 download 
# scripts to download scans from XNAT Central.
scans_dir=${2}

# freesurfers_dir
# This is the full path to the directory where your FreeSurfer output 
# (folder of FreeSurfer subject folders) is located.
# This is the same as the FreeSurfer "SUBJECTS_DIR" that you would 
# have used when running FreeSurfer (where the FreeSurfer output 
# folder gets created).
freesurfers_dir=${3}

# output_dir
# The output directory is the full path to a folder where you want 
# your output data to be saved. 
# For this example, when you adapt this script for use in a container, 
# the directory name you choose for "output_directory" does not need 
# to be an existing directory before you run the script - this script
# will create that directory for you.
output_dir=${4}


#-----------------
# SCRIPT STEPS
#-----------------
# Create the output directory
echo "Creating the output directory at ${output_dir}"
mkdir -p ${output_dir}

# Get a date string to use in naming the log files
logdate=$(date +%Y%M%d%H%M%s)

# Read your input file and each column
echo "Reading in input CSV file ${input_file}"
cat ${input_file} | while IFS=, read -r session_label dti_scan_id fi_threshold_value gradient_value; do
	# Output which session we are on
	echo "Starting with session label=${session_label}"

	#-----------------
	# Check for FreeSurfer
	# session directory
	#-----------------
	# Make sure we have a FreeSurfer output directory for our scan session
	echo "Checking for a FreeSurfer output folder for session label=${session_label}"

	freesurfer_session_directory=${freesurfers_dir}/${session_label}

	if ! [ -d "${freesurfer_session_directory}" ]; then
		# We did not find a FreeSurfer output folder for this session
		# Continue to the next row in the CSV with "continue"
		echo "Did not find FreeSurfer folder for session ${session_label}. Expected to find it at ${freesurfer_session_directory} but it was not there. Continuing to the next session."
		continue
	fi

	# If we got to this point, then we found the FreeSurfer directory and can continue.
	echo "Found FreeSurfer output folder at ${freesurfer_session_directory}."	

	#-----------------
	# Find DTI folder
	# based on scan ID
	#-----------------
	# Make sure we have the correct number and types of files for our DTI scan ID
	echo "Checking for scan files for scan ID=${dti_scan_id}"

	# Get a list of files in the expected scan folder
	dti_scan_folder=${scans_dir}/${session_label}/${dti_scan_id}
	# Check if this directory exists
	if ! [ -d ${dti_scan_folder} ]; then
		# We did not find a folder for this session and scan ID
		# Continue to the next row in the CSV with "continue"		
		echo "Did not find scan folder for session ${session_label}. Expected to find it at ${dti_scan_folder} but it was not there. Continuing to the next session."
		continue
	fi

	# If we got to this point, then we found the scan folder and can continue.
	echo "Found scan folder ${dti_scan_folder}. Proceeding with processing on this session."	

	#-----------------
	# Check NIFTI file 
	# based on scan ID
	#-----------------
	# Get the full path of the first NIFTI file in the folder
	# Use "find" and pipe to "head -n 1" to get the first result of our find command
	# Using "*.nii*" in case we have .nii instead of .nii.gz file types
	nifti_filepath=`find ${dti_scan_folder} -type f -name "*.nii*" | head -n 1`

	if ! [ -f "${nifti_filepath}" ]; then
		# We did not find a NIFTI file for this session and scan ID
		# Continue to the next row in the CSV with "continue"
		echo "Did not find NIFTI file for session ${session_label}, scan ID=${dti_scan_id}. Expected to find it at ${nifti_filepath} but it was not there. Continuing to the next session."
		continue
	fi

	# If we got to this point, we found the correct NIFTI file and can continue.
	echo "Found NIFTI file at ${nifti_filepath}. Proceeding."	

	#-----------------
	# Check bvec/bval file 
	# based on NIFTI name
	#-----------------
	# Remove .nii.gz or .nii file extensions
	filepath_basename=`echo ${nifti_filepath} | sed 's/\.nii\.gz//g; s/\.nii//g'`
	# Add on .bvec file extension to get .bvec filename
	bvec_filepath=${filepath_basename}.bvec
	bval_filepath=${filepath_basename}.bval

	if ! [ -f ${bvec_filepath} ] || ! [ -f ${bval_filepath} ]; then
		# We did not find bvec and bval files with the same name as the NIFTI
		# Continue to the next row in the CSV with "continue"
		echo "Did not find bvec or bval file for session ${session_label}, scan ID=${dti_scan_id}. Expected to find bvec at ${bvec_filepath} and bval at ${bval_filepath} but one or both of them were not there. Continuing to the next session."
		continue
	fi

	# If we got to this point, then we found the bvec and bval files and can continue.
	echo "Found bvec file at ${bvec_filepath}."
	echo "Found bval file at ${bval_filepath}."
	echo "Proceeding."

	# Get the filename only for the bvec and bval files since that is what we need in the script
	nifti_filename=`basename ${nifti_filepath}`
	bvec_filename=`basename ${bvec_filepath}`
	bval_filename=`basename ${bval_filepath}`

	#-----------------
	# Create log file
	#-----------------
	# Create a log file name to send our output log info to
	# so we can refer to it later
	log_filename=${session_label}_container_tutorial_run_${logdate}.log
	log_filepath=${output_dir}/${session_label}/${log_filename}

	#-----------------
	# Launch a container
	# based on the inputs
	#-----------------
	# We now have the required inputs for our command.
	# Replace the command inputs with our variables determined above.
	# Run the command in detached mode with "-d" and send the output to a log file
	apptainer_cmd="apptainer exec -B ${scans_dir}:/scans -B ${freesurfers_dir}:/freesurfers -B ${output_dir}:/output container_tutorial_1_0-dev.sif /usr/local/bin/run_workflow.sh /scans /freesurfers /output ${session_label} ${dti_scan_id} ${nifti_filename} ${bvec_filename} ${bval_filename} ${fi_threshold_value} ${gradient_value}"

	# Output the full Apptainer command you are going to run to the console
	echo ${apptainer_cmd} > ${log_filepath} 

	# Use bash "eval" to run the Apptainer command
	# use "nohup" first to run the container process in the background
	eval ${apptainer_cmd} &

	# Done with this row in the CSV
	echo "Apptainer container launched for session label=${session_label}, DTI scan ID=${dti_scan_id}"

done

echo "Done with batch launch script."