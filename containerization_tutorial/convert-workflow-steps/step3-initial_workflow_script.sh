#!/bin/bash
#=================================================================
# Containerization Tutorial Script
# Step 3 - Workflow commands converted into a bash script
#=================================================================
# Script: step3-initial_workflow_script.sh
# Author: Sarah Keefe
# Last Updated: 2023-06-10
# 
# Purpose: This is the set of updated commands from step 2, 
# converted into a bash script that can be called as a single 
# command. Comments and "echo" printout statements have been added 
# to let the person running the script know what step is happening.
#
# More details can be found in the readme at:
#      https://github.com/sarahkeefe/containerizing-neuroimaging-workflows
#
#=================================================================

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
fslroi scans/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.nii.gz output/OAS30001_MR_d3132_nodif.nii.gz 0 1
# Done with fslroi
echo "Done with fslroi"

echo ""

# FSL Brain Extraction Tool (bet)
echo "Running bet"
# Brain extraction on "nodif.nii.gz" - create binary brain masks for DTI scan
bet output/OAS30001_MR_d3132_nodif.nii.gz output/OAS30001_MR_d3132_nodif_brain.nii.gz -f 0.25 -g 0 -m
echo "Done with bet"

echo ""

# FSL eddy_correct 
echo "Running eddy_correct"
# Run eddy_correct on the "dwi.nii.gz" scan file
eddy_correct scans/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.nii.gz output/OAS30001_MR_d3132_eddy_corrected.nii.gz 0
echo "Done with eddy_correct"

echo ""

# FSL dtifit 
echo "Running dtifit"
# dtifit to apply the tensor model to the diffusion data
# Use the eddy_corrected output plus the bet-extracted nodif file
# Incorporate the bvec and bval information that was part of the original DTI scan file set.
dtifit -k output/OAS30001_MR_d3132_eddy_corrected.nii.gz -m output/OAS30001_MR_d3132_nodif_brain.nii.gz -r scans/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.bvec -b scans/OAS30001_MR_d3132/dwi1/sub-OAS30001_sess-d3132_run-01_dwi.bval -o output/OAS30001_MR_d3132_dtidata
echo "Done with dtifit"

echo ""

echo "Done with containerization tutorial workflow script."