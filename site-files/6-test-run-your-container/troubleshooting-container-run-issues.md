---
layout: default
title: Troubleshooting container run issues
parent: Test run your container
nav_order: 3
---

# Troubleshooting container run issues

## Re-setting the output directory for a second (or third) container test

If you run into issues with your container run with your script it's important to re-set your output directory. This will prevent any issues from your script seeing existing data and using incorrect data as input on a repeat run. If you need to rerun, remove all files from the output folder so when you run again, your output will be the same as would be expected if you were running your container for the first time. 

```
rm -r output/*
```

If you want to retain output directories from your previous container run attempts, you can alternatively create a new output directory and update your run command to send the output there. For example, in my first run I used the directory named `output`, but for my second run I could create a new output folder named `output_test2`:
```
mkdir output_test2
```

And then update my run command to map to that new output directory to `/output` instead. For Docker that would be:
```
docker run -v /home/usr/sarah/containerization_tutorial/scans:/scans -v /home/usr/sarah/containerization_tutorial/freesurfers:/freesurfers -v /home/usr/sarah/container_tutorial/output_test2:/output container_tutorial:1.0-dev /usr/local/bin/run_workflow.sh /scans /freesurfers /output OAS30001_MR_d3132 dwi1 sub-OAS30001_sess-d3132_run-01_dwi.nii.gz sub-OAS30001_sess-d3132_run-01_dwi.bvec sub-OAS30001_sess-d3132_run-01_dwi.bval 0.25 0
```
The directory where the output should go will still be called `/output` to Docker, but for you it will be `output_test2` (in this case specifically, `/home/usr/sarah/container_tutorial/output_test2`).

For Apptainer the update would be:
```
```


## Error messages
- find the first error message to diagnose your problem
- you can also run and send your error output to a text file with piping/carrot (get exact name)

## Files not appearing in your output directory
- go to the most recent step where that file should be created. make sure the prior command had the correct input and output. you can try running the same command as a single line (example run command with mapping). you can try setting up a mini-script to test just that step of the container, or test everything up to a particular step.
