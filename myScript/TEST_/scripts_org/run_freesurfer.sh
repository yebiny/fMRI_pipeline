#!/bin/bash
# author: Alexa Tompary
# modified by kimghootae@gmail.com (Dec 21, 2018)

set -e  # fail immediately on error

source globals.sh
recon-all -i data/nifti/-s -s bert -sd freesurfer -all 