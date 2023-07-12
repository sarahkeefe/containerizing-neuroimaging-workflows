---
layout: default
title: Using the tutorial files
parent: Getting started
nav_order: 1
---

# Using the tutorial files

This section will go over how you might effectively use the accompanying example scripts and files in the [containerizing-neuroimaging-workflows Github repository].

## Set yourself up with a copy of the files and folder structure

### Download or clone a copy of the repository

You won't need all the files in the repository, and you could set up the necessary directory structure on your own, but it's easiest to just clone the whole repository and work with that.

You can go to your command line terminal and use `git` to clone the repository:
```
git clone https://github.com/sarahkeefe/containerizing-neuroimaging-workflows.git
```

Or you can download a copy of the repository zip file via the [main repository page], move it to your desired working directory, and then access the folder with that zip file in it via your command line. Then unzip the file and rename the output folder to just `containerizing-neuroimaging-workflows`: 
```
unzip containerizing-neuroimaging-workflows-main && mv containerizing-neuroimaging-workflows-main containerizing-neuroimaging-workflows
```

After either of those steps, you should have obtained a folder called `containerizing-neuroimaging-workflows` with the tutorial files in it. Use `cd` to change your working directory to that folder.
```
cd containerizing-neuroimaging-workflows
```

### Remove unnecessary files from your copy of the repository

If you run `ls` from that folder to list the contents of the folder you are currently in, you should see some subfolders the same as you would see on the Github repository page: `batch-scripting`, `containerization_tutorial`, `image-definition-files`, `site-files`, and a file `README.md`.

To keep things as simple as possible, remove the files and folders you don't need, which is `site-files` and `README.md`:
```
rm README.md
rm -R site-files
```

### Download the example scan session and FreeSurfer output from OASIS-3

We're going to run the test workflow on a sample MR scan session and FreeSurfer output from the OASIS-3 dataset. I'm unfortunately not allowed to share a session from OASIS-3 for this tutorial, so you'll need to download it yourself. 

First get access to the OASIS-3 dataset by going to [https://www.oasis-brains.org] and filling out the data use agreement form. You can say something like "Example imaging data for neuroimaging research containerization tutorial" as your reason for requesting access. Your access should get approved within a couple days and you should be given access to the dataset via [XNAT Central].

Once you have XNAT Central access and can view the OASIS-3 project on the XNAT Central website, use the included download scripts and input files to download the example data as described below. 

The download script for downloading scans and an input file specifying that scan have been included in the `containerization_tutorial/scans` folder. Go into the scans folder:
```
cd containerization_tutorial/scans
```

Run the download script on the included input file, using your XNAT username in place of `your_xnat_central_username` below, and an output folder called `downloaded_scans`:
```
./download_oasis_scans.sh containerization_tutorial_scans_to_download.csv downloaded_scans your_xnat_central_username 
```

Press Enter and enter your password for XNAT Central when it asks. If you type your password correctly, the scan session listed in `containerization_tutorial_scans_to_download.csv` should download into a new subfolder called `downloaded_scans`.
Move everything that is inside the `downloaded_scans` folder up one level, and then remove the empty `downloaded_scans` folder:
```
mv downloaded_scans/* .
rmdir downloaded_scans
```

Your current working directory, the `containerization_tutorial/scans` folder, should now contain a subfolder named `OAS30001_MR_d3132`, and in that folder, there should be a number of scan file folders named for each scan ID, such as `anat1`, `dwi1`, `dwi2`, and so on.

You're done getting the scan data! Next get the Freesurfer data.
Go up a level in the folder tree, back up to the `containerization_tutorial` folder:
```
cd ..
```
The `pwd` command should show that you are in the `containerization_tutorial` folder.

Then use `cd` to go into the `freesurfers` directory:
```
cd freesurfers
```
Then use the provided `download_oasis_freesurfer.sh` script in that folder to download the FreeSurfer output listed in `containerization_tutorial_fs_to_download.csv`, with the following command, but using your XNAT username in place of `your_xnat_central_username`:
```
./download_oasis_freesurfer.sh containerization_tutorial_fs_to_download.csv downloaded_freesurfers your_xnat_central_username
```
Press Enter and enter your password for XNAT Central when it asks. If you type your password correctly, the FreeSurfer output listed in `containerization_tutorial_fs_to_download.csv` should download into a new subfolder called `downloaded_freesurfers`.

Move everything that is inside the `downloaded_freesurfers` folder up one level, and then remove the empty `downloaded_freesurfers` folder:
```
mv downloaded_freesurfers/* .
rmdir downloaded_freesurfers
```

Your current working directory, the `containerization_tutorial/freesurfers` folder, should now contain a subfolder named `OAS30001_MR_d3132`, and in that folder, there should be 6 subfolders that are part of the default FreeSurfer output folder structure: `label`, `mri`, `scripts`, `stats`, `surf`, and `tmp`.

You're done getting the tutorial example data.

## Use the files for each section

### Using the files for the "Convert workflow for containerized use" section

You will use the directory structure you just set up and the example data files you just downloaded to follow along with the steps in the "[Convert workflow for containerized use]" section.

That section will walk you through what goes into each one of the example files in the `containerization_tutorial/convert-workflow-steps` files. For each step in that tutorial section, you can follow along by starting out with the initial file listed on the page, and go through the steps of the guide to figure out how to get from the initial file to the end file.

### Using the files for the "Create image definition file" section
There are two files in the `containerization_tutorial/container_image_files` that are example image definition files: `Dockerfile` for building a Docker image and `apptainer_def.txt` for building an Apptainer image. The "[Create image definition file]" section will explain the contents, structure, and syntax of those files. You can look at the files and tutorial together to learn how to apply those principles to your own image file after you're done with the tutorial.

### Using the files for the "Build the container image" section
The image definition files `Dockerfile` and `apptainer_def.txt` are the input files that will go into building the example container images in the "[Build the container image]" section. To run the example Docker or Apptainer builds, use `cd` to go into the `containerization_tutorial/container_image_files` folder and then run the build commands described in that section. 

### Using the files for the "Test run your container" and "Check container output" sections
When you get to the "[Test run your container]" section and set up your example run command, use the test OASIS-3 data that you downloaded earlier, but ensure that you use your own full file paths on your system when trying out the `docker run` or `apptainer exec` commands on the image you built in the previous step. Bind your `output` folder to send the container output to that folder. 

## Other available files
The other folders in the main repository, `image-definition-files` and `batch-scripting`, contain template files and example files that might be useful when implementing your own workflow.

`[image-definition-files]` contains example Docker and Apptainer image definition files for setting up containers with different base images but similar programs.

`[batch-scripting]` contains script templates described in the [Use and share your image] section.

----

[containerizing-neuroimaging-workflows Github repository]: https://github.com/sarahkeefe/containerizing-neuroimaging-workflows
[main repository page]:https://github.com/sarahkeefe/containerizing-neuroimaging-workflows
[Convert workflow for containerized use]:https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/3-convert-workflow-for-containerized-use
[Create image definition file]:https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/4-create-image-definition-file/
[Build the container image]:https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/5-build-the-container-image/
[Test run your container]:https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/6-test-run-your-container/
[image-definition-files]:https://github.com/sarahkeefe/containerizing-neuroimaging-workflows/tree/main/image-definition-files
[batch-scripting]:https://github.com/sarahkeefe/containerizing-neuroimaging-workflows/tree/main/batch-scripting
[Use and share your image]:https://sarahkeefe.github.io/containerizing-neuroimaging-workflows/8-use-and-share-your-image/