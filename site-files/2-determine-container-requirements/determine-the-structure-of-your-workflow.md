---
layout: default
title: Determine the structure of your workflow
parent: Determine container requirements
nav_order: 1
---

# Determine the structure of your workflow

## Gather your list of workflow commands

Make sure you have the list of commands that you will need to run and determine the order you need to run them in. Determine what your input files are and what output files are expected at the end of your workflow. 

## Get the command-line equivalents of GUI programs

If you are running programs in a program that uses a user interface, such as some FSL programs, use the documentation for that specific program to determine the equivalent commands that do the same task via the text-only command line, and try the command-line commands out to make sure they give the output you expect. 

## Get a list of software programs your workflow requires

Make a list of all the software programs that are required for your commands, including any programming languages such as Python or R. Make a note of whether you need specific versions of any of these languages or packages in order to run your workflow in the way you want.

In the next step you will determine where those programs can be sourced from for installation into your container.