---
layout: default
title: Apptainer exec command setup
parent: Test run your container
nav_order: 2
---

# Set up an Apptainer `exec` command to run your script on some data

## Apptainer `exec` versus `run`

Two Apptainer commands to launch a container from an image are `exec` and `run`. 

`apptainer exec` will do the equivalent of running a single command in a shell within your container, enabling you to run one command and then end the container. `exec` allows you to use your container to call any command you want.

`apptainer run` expects a container image to have a built-in run script that was specified in an additional `%runscript` section of your image definition file. Using `run` requires a built-in run script to be included at the image build step and limits your container to calling the run script only.

`apptainer run` is a great way to incorporate your run_workflow.sh script into your container image if you only have a single command you will ever want to run with your container image. You could easily update your image definition file to include a `%runscript` section with your script command in it, and then use `apptainer run` to call that script.

Since I want to show examples of running some simple commands within a container, I will be using `exec` in this tutorial. 

More details on `apptainer run` can be found in the [Apptainer run command documentation].
More details on `apptainer exec` can be found in the [Apptainer exec command documentation].

## Apptainer `exec` command overview

The `apptainer exec` command is used to run a container based on the specified container image. What the launched container does depends on the additions and options you send to the command. 

The format of the `apptainer exec` command is like this:

```
apptainer exec [OPTIONS] image_filename.sif [COMMAND] [ARG...]
```

Where you would make the following replacements:
- `[OPTIONS]` gets replaced with any number of option flags that the `apptainer exec` command can take in. There are a number of options you can include which are documented in the [Apptainer exec command documentation].
- `image_filename.sif` gets replaced with the filename of the apptainer image file you built, that you want to run a container from.
- `[COMMAND]` gets replaced with a command you want to run within the container you launch
- `[ARG...]` gets replaced with any arguments to your command from `[COMMAND]` (This is optional depending on your `[COMMAND]`)

The text `[COMMAND]` can be replaced with any command-line command you want to run within your container. It will run it exactly as though you were running it in the environment of the container image you built and configured. Eventually we'll use your custom workflow script command in place of `[COMMAND]`, but for now we will show some simpler examples.

## Example `apptainer exec` command with our example image and `ls`

A very basic Apptainer `exec` command with a sample command COMAND and using the tutorial image file we just built, looks like this:
```
apptainer exec container_tutorial_1_0-dev.sif COMMAND
```

This command is specifying that we want `apptainer exec` to create a container from our image `container_tutorial_1_0-dev.sif` and then run the sample command COMMAND in it.

Here is the same `exec` command that will run `ls`, the command to list the files within the container:
```
apptainer exec container_tutorial_1_0-dev.sif ls
```

This tells `apptainer exec` to create a container from our image `container_tutorial_1_0-dev.sif` and then run the `ls` command in it to list the files within the container system.

If you enter that in your command line and press Enter, this command will launch a container from the tutorial container image and perform the `ls` command in it.

![apptainer-exec-with-ls](containerizing-neuroimaging-workflows/images/apptainer-exec-with-ls.png){:class="img-responsive"}

Apptainer will perform the `ls` command within the container that generated and display what the container is able to view. In this case, I am seeing the same as the contents of my current directory:  

![apptainer-exec-with-ls-and-local-ls](containerizing-neuroimaging-workflows/images/apptainer-exec-with-ls-and-local-ls.png){:class="img-responsive"}

This may be confusing, especially if you've previously worked with Docker. I didn't specify to copy any of my local folders or files into this container image, and I don't want anyone else who uses my container to see my personal files, so is this still a shareable, independent container image that will work on any system?

Yes! What is appearing in the within-container `ls` is not actually a copy of your files. What is happening is that your home directory on your computer is being automatically **mounted** into your container - Apptainer is able to connect the container to your computer and make your computer's files visible to the container. That means your container can see the same folders and files that you can, and (importantly) the container can *make changes to them* too.

This may actually differ slightly depending on settings your system administrator has chosen for your Apptainer installation. 
By default Apptainer will mount `$HOME`, `/sys`, `/proc`, `/tmp`, `/var/tmp`, `/etc/resolv.conf`, `/etc/passwd`, and `$PWD`. `$HOME` is an environment variable that indicates your user home directory and is typically located at `/home/usr/yourusername` or `/home/yourusername`. `$PWD` is an environment variable indicating your current working directory. If you are in a directory or subdirectory of one of those paths when you run `apptainer exec` that will automatically be your default directory in the container.

Apptainer incorporates your system information, user information, and existing user permissions when doing this mounting, so you only have access and privileges on the same files you have access and privileges to on your local computer. So when someone else runs a container based on your container image on their system, they won't see your files or directories that you're seeing right now - they will see their own, based on the system where they are running your container image.

You can run the container without this default mounting of your `$HOME` directory by including the `--no-home` option, like this:

```
apptainer exec --no-home container_tutorial_1_0-dev.sif ls
```

When you run that, you'll see all the same files you would see in the container's root directory, `/`, like this:

![apptainer-exec-with-ls-no-home](containerizing-neuroimaging-workflows/images/apptainer-exec-with-ls-no-home.png){:class="img-responsive"}

And if you get the default working directory with `pwd` when you use `apptainer exec --no-home` you'll see the root directory path:

![apptainer-exec-with-pwd-no-home](containerizing-neuroimaging-workflows/images/apptainer-exec-with-pwd-no-home.png){:class="img-responsive"}

More details on Apptainer mounting or bind paths, and the default locations, can be found in the [Apptainer bind path documentation]. 

To run your workflow script we will do a more complicated version of the `apptainer exec containerfile.sif COMMAND` command that will call your script's command-line command in an instance of your container. 

In addition to running single commands with `apptainer exec`, Apptainer also offers functionality to run a container and take actions directly within the container while it's running. This is done using the `apptainer shell` command. Check out the [Apptainer shell command documentation]for more details. That is the equivalent of the `-i` flag for `docker run` and will create a container instance for you and pin it to your command line so you can work directly within the environment of a container.

The rest of this section focuses on launching a container and executing a single command in that container, after which the container will automatically complete and stop running. 


### Use `apptainer exec` to show where your script file is within the container

Our goal is to call your custom workflow script using your container image file and the `apptainer exec` command. To do that, we'll need to call the script from where it is located in the container. In the tutorial image definition file example, the instruction in the `%files` section specified this for our `run_workflow.sh` script file:

```
run_workflow.sh /usr/local/bin/run_workflow.sh
```

The `run_workflow.sh` file got copied into `/usr/local/bin`. So if we list the files in `/usr/local/bin` within an instance of our container, we should see that file name in the list. Here is the `apptainer exec` command to run an instance of our container image and then list the files in that specific directory:

```
apptainer exec container_tutorial_1_0-dev.sif ls /usr/local/bin
```

Here is what the output looks like:

![apptainer-exec-ls-scriptfile](containerizing-neuroimaging-workflows/images/apptainer-exec-ls-scriptfile.png){:class="img-responsive"}

Our script file `run_workflow.sh` shows up in the `/usr/local/bin` folder within a running container.

### Show environment variables with env

Another useful bash shell command to run before we go further is to check out what environment variables are set within the container with `env`, like this:

```
apptainer exec container_tutorial_1_0-dev.sif env
```

This will show a list of all the environment variables that are currently set in the container environment, like this:

![apptainer-exec-single-command-env](containerizing-neuroimaging-workflows/images/apptainer-exec-single-command-env.png){:class="img-responsive"}

Some of these came from the original FreeSurfer `freesurfer/freesurfer:7.3.2` base container and carried over when we built on top of it. Some of these are identical to environment variables on your local system and have been carried over by Apptainer from your local computer into the container. Some of the FSL environment variables are ones that we set in these lines in the `%environment` section of the original container image definition file:

```
export FSLDIR=/usr/local/fsl

export FSLMULTIFILEQUIT=TRUE
export FSLOUTPUTTYPE=NIFTI_GZ

export PATH=$FSLDIR/bin:$PATH
```

The FSL and FreeSurfer-specific environment variables will be important for running functions from those programs, and the `PATH` variable is important since that is a list of folders where our container will look for program files[^1], for example where it will look for programs we installed like `fslmaths`. In fact, you can 100% confirm that your container knows where `fslmaths` is by running

```
apptainer exec container_tutorial_1_0-dev.sif fslmaths
```

You'll see the `fslmaths` help block:

![apptainer-exec-single-command-fslmaths](containerizing-neuroimaging-workflows/images/apptainer-exec-single-command-fslmaths.png){:class="img-responsive"}

More details on how Apptainer handles environment variables can be found in the [Apptainer environment and metadata documentation].

## Get your container to see your local data

The container is intended as an isolated environment that is entirely separate from your local files, programs, environment variables, and data. As described earlier, Apptainer mounts your local directories by default. But this doesn't necessarily mean your container will automatically have access to the input files needed to run your script. Your system may have a different configuration of Apptainer, or you might need to point your container at files that are on another filesystem or directory, which can happen in high-performance computing cluster setups. 

Your container by default won't have access to any files that are outside the directories that Apptainer mounts by default or haven't been copied in via the container definition file. You'll need to run your workflow script on specific imaging data, so you need a way to get your imaging dataset into the container. 

You could technically copy all your data files in in the `%run` section of your container image definition file, which would copy all your files into the container image during the `apptainer build` step, but that's not a great idea - it'll increase the container image size considerably, plus you want to be able to share your container image but not give the world access to your dataset. What you need to do to get your container to see your local files without permanently storing them in the container image is to add your own "mount" of a folder with your data in it. This is added as an option to the `apptainer exec` command.

The `-B` or `--bind` flag is the option flag that can be used to mount data into your container. When mounting a folder with `-B`, you send the `-B` option as part of the `apptainer exec` command options section like this:

```
apptainer exec -B X:Y container_tutorial_1_0-dev.sif [COMMAND]
```

To mount a folder, `-B` should be followed by a string in the format `X:Y` as shown above. `X` needs to be replaced with the absolute path (starting with a `/`) to the folder on your local computer that you want your Docker container to see. `Y` should be replaced with the absolute path (starting with `/`) of where you want that folder to "appear" within a running container (so the location where your container will think that folder is).

Here is that sample command with `-B` shown with a more accurate-looking example of the `X` and `Y` folder paths

```
apptainer exec -B /full/path/to/localfolder:/containerdata container_tutorial_1_0-dev.sif [COMMAND]
``` 

In this sample command, any files that are located on your computer at the path `/full/path/to/localfolder` will show up in the folder `/containerdata` in the container that gets launched.

Here is what it looks like with real data. Use `cd` to get into your main `containerization_tutorial` directory. This is the one that contains subfolders for scans, freesurfers, container_image_files, and output, as well as the example scripts. 

![apptainer-tutorial-dir-list](containerizing-neuroimaging-workflows/images/apptainer-tutorial-dir-list.png){:class="img-responsive"}

For your script you'll need the folders with your example data, plus you'll want to send an output folder for script output to go into. So ultimately you want to mount the `freesurfers`, `scans`, and `output` folders into your container. On your local computer, these folders are subfolders your current working directory `containerization_tutorial`. Use `pwd` to get the absolute path of your `containerization_tutorial` directory.

![apptainer-tutorial-dir-pwd](containerizing-neuroimaging-workflows/images/apptainer-tutorial-dir-pwd.png){:class="img-responsive"}

This is the path you'll want to use as the basis for the `X` path - the path to your local folder with your data on your computer. In this case, my containerization tutorial directory is at `/home/sarah/containerization_tutorial`. My data is in these subfolders:
- Scan files are in `/home/sarah/containerization_tutorial/scans`
- FreeSurfer files are in `/home/sarah/containerization_tutorial/freesurfers`
- The empty output directory I created is in `/home/sarah/containerization_tutorial/output`

Now for choosing the `Y` path. This can be any folder path that doesn't already exist within the container. It can be any path because you'll be telling your script to look there anyway, since a couple of your script input parameters are paths to a folder of scans, path to a folder of freesurfers, and path to an empty output directory. It has to be an absolute path starting with `/`. For mapping the `scans` directory I'll map it to the very simple path `/scans` - A folder called `scans` located in the base `/` directory in the container folder structure.

Here is an `apptainer exec` command that will mount my example local scans folder into the container at path `/scans`, and then run the `ls /` command within that container:
```
apptainer exec -B /home/sarah/containerization_tutorial/scans:/scans container_tutorial_1_0-dev.sif ls /
```

In this command, the `ls /` at the end of the command will list the files in the `/` folder within a running container, and then the container will stop running. In the output of the list, you'll see the folders your container can see - including scans folder you mounted with `-B`:

![apptainer-tutorial-mount-scans-folder-ls1](containerizing-neuroimaging-workflows/images/apptainer-tutorial-mount-scans-folder-ls1.png){:class="img-responsive"}

You can `ls` the `/scans` folder within the container to show what Docker sees in the `/scans` folder with 
```
apptainer exec -B /home/sarah/containerization_tutorial/scans:/scans container_tutorial_1_0-dev.sif ls /scans
```

You'll see the session folder:

![apptainer-tutorial-mount-scans-folder-ls-scans](containerizing-neuroimaging-workflows/images/apptainer-tutorial-mount-scans-folder-ls-scans.png){:class="img-responsive"}

And when the container finishes running that command, if you list the scans that you can see locally, you'll see the same thing your container sees.

![apptainer-tutorial-mount-scans-folder-local-comparison](containerizing-neuroimaging-workflows/images/apptainer-tutorial-mount-scans-folder-local-comparison.png){:class="img-responsive"}

with that `-B` command and the correct absolute paths, your Apptainer container can now see the contents of your `containerization_tutorial/scans` folder.

To map multiple folders in an `apptainer exec` command, you add extra `-B X:Y` options like this:

```
apptainer exec -B X1:Y1 -B X2:Y2 -B X3:Y3 container_tutorial_1_0-dev.sif [COMMAND]
```

Here is my example with the `scans` folder mapped to `/scans` in the container, `freesurfers` mapped to `/freesurfers`, and `output` mapped to `/output`:

```
apptainer exec -B /home/sarah/containerization_tutorial/scans:/scans -B /home/sarah/containerization_tutorial/freesurfers:/freesurfers -B /home/sarah/containerization_tutorial/output:/output container_tutorial_1_0-dev.sif ls /
```

The `ls /` will show the list of folders the container can see and include the newly mounted `freesurfers` and `output` directories you added on.


## Setting up a command to run your script within the container

Now that you can send your files to the container it's time to set up an exec command specific to your workflow script. As you can see the exec command has a bunch of different parts and can get pretty long, so it's useful to set up your command in a text editor and then paste it into your command line when you are sure it's ready to run.

You'll want to combine the `apptainer exec` command with the correct mounted data folders with the correct `[COMMAND]` to run your workflow script within the container.

Here is a reminder of how to call your run_workflow.sh script after the last part of the the workflow script setup:
```
./run_workflow.sh scans_dir freesurfers_dir output_dir session_label dti_scan_id dti_scan_filename dti_bvec_filename dti_bval_filename fi_threshold_value gradient_value
```

Here is the script command with your specific inputs that you tested earlier from your `containerization_tutorial` folder:
```
./run_workflow.sh scans freesurfers output OAS30001_MR_d3132 dwi1 sub-OAS30001_sess-d3132_run-01_dwi.nii.gz sub-OAS30001_sess-d3132_run-01_dwi.bvec sub-OAS30001_sess-d3132_run-01_dwi.bval 0.25 0
```

Now to adapt this to run within the container.

As mentioned in an earlier section, your Apptainer container image definition file copied the `run_workflow.sh` into `/usr/local/bin`. You can confirm again with this container run and list command:

```
apptainer exec container_tutorial_1_0-dev.sif ls /usr/local/bin
```

So when you call your script command in the container, you'll use `/usr/local/bin/run_workflow.sh` instead of `./run_workflow.sh`, like this:

```
/usr/local/bin/run_workflow.sh scans_dir freesurfers_dir output_dir session_label dti_scan_id dti_scan_filename dti_bvec_filename dti_bval_filename fi_threshold_value gradient_value
```

The first 3 inputs to your script command are the `scans_dir` for scan file directory, `freesurfers_dir` for the freesurfers directory, and `output_dir` for the directory to send output files to. Now you know how to mount those three folders into a running instance of your container. When you update your run_workflow.sh script call for your in-container run, you'll enter the Apptainer mounted locations of those folders as the inputs. So since your container sees your local `scans` folder at `/scans`, your local `freesurfers` folder at `/freesurfers`, and your local `output` folder at `/output`, you would send the folder paths your container can see as those inputs to the script, like this:

```
/usr/local/bin/run_workflow.sh /scans /freesurfers /output session_label dti_scan_id dti_scan_filename dti_bvec_filename dti_bval_filename fi_threshold_value gradient_value
```

That takes care of where the inputs and outputs come from - every other input to your script can be entered the exact same way as if you were running locally:
```
/usr/local/bin/run_workflow.sh /scans /freesurfers /output OAS30001_MR_d3132 dwi1 sub-OAS30001_sess-d3132_run-01_dwi.nii.gz sub-OAS30001_sess-d3132_run-01_dwi.bvec sub-OAS30001_sess-d3132_run-01_dwi.bval 0.25 0
```

That's the container-specific `[COMMAND]` part you want to send to your `apptainer exec` command. Combine that with the command that mounts your data directories to get the full run command for your custom workflow:

```
apptainer exec -B /home/sarah/containerization_tutorial/scans:/scans -B /home/sarah/containerization_tutorial/freesurfers:/freesurfers -B /home/sarah/container_tutorial/output:/output container_tutorial_1_0-dev.sif /usr/local/bin/run_workflow.sh /scans /freesurfers /output OAS30001_MR_d3132 dwi1 sub-OAS30001_sess-d3132_run-01_dwi.nii.gz sub-OAS30001_sess-d3132_run-01_dwi.bvec sub-OAS30001_sess-d3132_run-01_dwi.bval 0.25 0
```

In each of the `-B` inputs, you'll need to replace `/home/usr/sarah/` with the absolute path to where your `containerization_tutorial` directory is located, to tell Apptainer to mount your data locations on your specific system.

## Run your run command

Since the `-B` mount option uses absolute paths, you can actually run this `apptainer exec` command from any folder location on your machine. Paste your entire customized `apptainer exec` command into the command line and press Enter. You should see output from the commands on your screen:

![apptainer-tutorial-full-exec-command-in-action](containerizing-neuroimaging-workflows/images/apptainer-tutorial-full-run-command-in-action.png){:class="img-responsive"}

And when it's done, you should see the expected output files appear in your local `output` folder:

![apptainer-tutorial-full-exec-command-output](containerizing-neuroimaging-workflows/images/apptainer-tutorial-full-exec-command-output.png){:class="img-responsive"}



----

[Apptainer run command documentation]: https://apptainer.org/docs/user/main/cli/apptainer_run.html
[Apptainer exec command documentation]: https://apptainer.org/docs/user/main/cli/apptainer_exec.html
[Apptainer bind path documentation]: https://apptainer.org/docs/user/main/bind_paths_and_mounts.html#system-defined-bind-paths
[Apptainer shell command documentation]: https://apptainer.org/docs/user/main/cli/apptainer_shell.html
[Apptainer environment and metadata documentation]: https://apptainer.org/docs/user/main/environment_and_metadata.html


[^1]: [A quick overview of the PATH variable can be found on Wikipedia and in many other Unix resources elsewhere.](https://en.wikipedia.org/wiki/PATH_(variable)).
