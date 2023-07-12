---
layout: default
title: Batch running containers
parent: Use and share your image
nav_order: 1
---

# Batch running containers from your container image

After you are able to run a few examples of your containerized workflow one at a time, you most likely need to run it on a lot of data. This can be made into a pretty straightforward process if your input data is organized consistently. 

## Running a "batch" of containers

You can set up a "batch script" to run a "batch" of your containers in a row. A batch script can take in inputs that will run your container with some consistent inputs across all sessions, but might also take in an input file with one data point per row. Each row would include specifics for each data point, including labeling for that data point, scan IDs, details on where to find those particular files, and other custom parameters that will differ for that particular row.

Example batch scripts for Docker and Apptainer containers have been included in the [batch-scripting] folder of the tutorial Github repository. These scripts expect a list of inputs via a CSV file and take in absolute paths (paths that start with `/`) to point to your scans, freesurfers, and output folders. The script goes through each line in your CSV file and expects to find corresponding scans and freesurfers files for each row. Using that information, it launches the tutorial container once for each row in the CSV, running the process in the background and saving log files.

## Updating the batch script templates for custom use

### Update the inputs
Update the INPUTS section to include any other global inputs you need to send to your container via your `docker run` or `apptainer exec` command. This could include paths to other folders that are on your local machine, or global inputs that you want to send to all containers you launch in the batch.

### Update the input CSV format
The example batch scripts expect a CSV formatted file with the following columns:
```
session_label
dti_scan_id
fi_threshold_value
gradient_value
```

If you are updating the input CSV file columns, determine the list of which columns you need in your CSV for all sessions. Update the line under `# Loop through each row in the CSV file` that reads in the CSV file and ensure that it includes a variable name with no spaces for each column. This is the line to update:
```
cat ${input_file} | while IFS=, read -r session_label dti_scan_id fi_threshold_value gradient_value; do
``` 

What this line does is output the CSV file at `${input_file}` and read the columns from it. In the example scripts there are 4 columns: 
- The first column is expected to contain session labels for the MR scan sessions. The session label is expected to be the name of a folder in both the `${freesurfers_dir}` and `${scans_dir}` folders. For each row in the CSV, the script reads the value in this column into the variable `session_label`.
- The second column is expected to contain the DTI scan ID for the MR scan sessions, which is expected to be the name of a folder in `${scans_dir}/${session_label}` that contains the DTI scan files. For each row in the CSV, the script reads the value in this column into the variable `dti_scan_id`.
- The third column contains the `fi_threshold_value` which is a value that is used as an input to FSL BET. By adding this as a column in our input CSV file, it enables us to change the value on a session-by-session basis. For each row in the CSV, the script reads the value in this column into the variable `fi_threshold_value`.
- The fourth column contains the `gradient_value` which is a value that is used as an input to FSL BET. By adding this as a column in our input CSV file, it enables us to change the value on a session-by-session basis.For each row in the CSV, the script reads the value in this column into the variable `gradient_value`.

Once you determine the CSV file structure for your batch script, if you add or remove columns compared to these, then update this line to add or remove variables from the read-in list. Make sure to check that the variable names you are entering correspond to the column ordering in your CSV.

### Update the `docker run` or `apptainer exec` command
Update the commands in the `Launch a container based on the inputs` section to use your customized workflow command instead of the tutorial example. Instead of using your specific input values from your testing (e.g. OAS30001_MR_d3132 or dwi1), update your command to use the variables that are already in the script or any that you added to the INPUTS section depending on where they are needed. 


## Batch scripting considerations

Be careful when running the script locally and make sure you don't run too many containers for your system to handle. If you are running on a local Docker or Singularity install where too many container runs are likely to slow down your system, it's a good idea to split your input CSV into subsets. Run one subset to launch all the containers at once, then check that they all completed using `docker ps` for Docker or `ps` for Apptainer, and then run the next subset.

If you are running on a high-performance computing system that uses Slurm, you'll need to use a Slurm batch script instead of the bash script examples provided. In the future I hope to provide example Slurm batch scripts to use for this purpose.

----
[batch-scripting]: https://github.com/sarahkeefe/containerizing-neuroimaging-workflows/tree/main/batch-scripting