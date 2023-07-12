---
layout: default
title: Viewing log output
parent: Check container output
nav_order: 1
---

# Viewing container log output

As your containerized workflow runs, it will write output to the console displaying its progress. For shorter workflows such as the one demonstrated, it is relatively easy to examine the output just via viewing the console output. For longer workflows you may want to save the logs other ways in order to view them later. 

## Output redirection to log files

You can use command-line tools such as output redirection to send output from your command to a text file for later viewing:
```
docker run -v /home/usr/sarah/containerization_tutorial/scans:/scans -v /home/usr/sarah/containerization_tutorial/freesurfers:/freesurfers -v /home/usr/sarah/container_tutorial/output:/output container_tutorial:1.0-dev /usr/local/bin/run_workflow.sh /scans /freesurfers /output OAS30001_MR_d3132 dwi1 sub-OAS30001_sess-d3132_run-01_dwi.nii.gz sub-OAS30001_sess-d3132_run-01_dwi.bvec sub-OAS30001_sess-d3132_run-01_dwi.bval 0.25 0 > docker_run_command_output_log.txt
```

```
apptainer exec -B /home/sarah/containerization_tutorial/scans:/scans -B /home/sarah/containerization_tutorial/freesurfers:/freesurfers -B /home/sarah/container_tutorial/output:/output container_tutorial_1_0-dev.sif /usr/local/bin/run_workflow.sh /scans /freesurfers /output OAS30001_MR_d3132 dwi1 sub-OAS30001_sess-d3132_run-01_dwi.nii.gz sub-OAS30001_sess-d3132_run-01_dwi.bvec sub-OAS30001_sess-d3132_run-01_dwi.bval 0.25 0 > apptainer_exec_command_output_log.txt
```

## Docker logs by container name

In Docker, you can add on the `-d` option to run the container in the background in "detached mode". Then you can run `docker ps` to get the list of currently running containers, get your container's assigned name, and then use `docker logs` to view the log output.

First run the command and include the `-d` flag, which will free up the command line for you to run other commands:
```
docker run -d -v /home/usr/sarah/containerization_tutorial/scans:/scans -v /home/usr/sarah/containerization_tutorial/freesurfers:/freesurfers -v /home/usr/sarah/container_tutorial/output:/output container_tutorial:1.0-dev /usr/local/bin/run_workflow.sh /scans /freesurfers /output OAS30001_MR_d3132 dwi1 sub-OAS30001_sess-d3132_run-01_dwi.nii.gz sub-OAS30001_sess-d3132_run-01_dwi.bvec sub-OAS30001_sess-d3132_run-01_dwi.bval 0.25 0
```
That will run the container in the background and output a long container ID string that looks like this:

```
83feefeb506439d3e6bec4596489f063c12067663338f75bca281d1959b7db3c
```

You can get the logs of that container ID by running:
```
docker logs 83feefeb506439d3e6bec4596489f063c12067663338f75bca281d1959b7db3c
```

That output will show the entire log so far. You can rerun that command to show the updated logs as the container runs.

While the container is running, you can also get the assigned container name from the current active container list. Get the active container list with:
```
docker ps
```

You'll see your currently running containers and a generated container name:

![docker-detached-container-name](images/docker-detached-container-name.png){:class="img-responsive"}

In this case the container name is ```intelligent_babbage```. You can then use that name as an input to `docker logs`:
```
docker logs intelligent_babbage
```

## Apptainer logs and process management via Unix

Since Apptainer does not use a centralized service to manage running containers, there is no equivalent way to add a detach flag to `apptainer exec` or view logs via an `apptainer` command. Apptainer output and processes can be used and managed by standard Unix process management commands and features. Unix commands that allow the user to view running processes, bring a running process to the foreground and background, and view and save log output, are the Apptainer equivalent of Docker's container process management commands.

By default an Apptainer command will show its output in your command console. For options like running a process in the background, you can use commands like `nohup` and `&` to run a process detached from the console, `bg` and `fg` to background and foreground a running process, and `ps` to view currently active processes. When running an Apptainer process in the background with a command like `nohup [COMMAND] &`, you could then use output redirection to send your Apptainer process log output to a file, like this:
```
nohup $([YOUR APPTAINER RUN COMMAND] > logfile.txt) & 
```

Documentation on some of the Unix process management comands can be found via [the "Controlling Processes" secton of the Linux Documentation Project] and on other documentation sites and courses available on the internet.

----
[the "Controlling Processes" secton of the Linux Documentation Project]:https://tldp.org/LDP/GNU-Linux-Tools-Summary/html/x5368.htm