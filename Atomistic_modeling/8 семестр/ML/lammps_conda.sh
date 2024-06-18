#!/bin/bash

conda create --name lmp_env
conda activate lmp_env
conda install conda-forge::lammps
