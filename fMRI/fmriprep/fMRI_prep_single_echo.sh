#!/bin/env bash

#SBATCH --job-name=fmriprep
#SBATCH --account=kg98
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --time=1-00:00:00
#SBATCH --mail-user=joshua.hendrikse@monash.edu
#SBATCH --mail-type=FAIL
#SBATCH --mail-type=END
#SBATCH --export=ALL
#SBATCH --mem-per-cpu=8000
#SBATCH --qos=normal
#SBATCH -A kg98
#SBATCH --array=1-38
# IMPORTANT! set the array range above to exactly the number of people in your SubjectIDs.txt file. e.g., if you have 90 subjects then array should be: --array=1-90

SUBJECT_LIST="/home/jhendrik/kg98/Josh/BIDS_data/SubjectIDs.txt"

#SLURM_ARRAY_TASK_ID=1
subject=$(sed -n "${SLURM_ARRAY_TASK_ID}p" ${SUBJECT_LIST})
echo -e "\t\t\t --------------------------- "
echo -e "\t\t\t ----- ${SLURM_ARRAY_TASK_ID} ${subject} ----- "
echo -e "\t\t\t --------------------------- \n"

# paths
workdir=/projects/kg98/Josh/BIDS_data/MR02/temp/${subject} # this directory is just a temp directory where intermediate outputs/files from fmriprep are dumped. It must be subject specific though!
bidsdir=/home/jhendrik/kg98/Josh/BIDS_data/MR02/rawdata # path to a valid BIDS dataset
derivsdir=/home/jhendrik/kg98/Josh/BIDS_data/MR02/derivatives # path to whether derivatives will go. This can be anywhere
fslicense=/home/jhendrik/kg98/Josh/BIDS_data/license.txt # path and freesurfer licence .txt file. Download your own from freesurfer website and store. Or just leave it and use mine!

# other things to consider below:
# 1) -t flag. I have it set to rest but you might want to change this depending on your needs.
# 2) --use-syn-dyc is on. This is a map-free distortion correction method that is currently listed as experimental by fmriprep developers.
# 3) this variant of the code runs freesurfer.

# --------------------------------------------------------------------------------------------------
# MASSIVE modules
module load fmriprep/1.1.1
unset PYTHONPATH 

# Run fmriprep
fmriprep \
--participant-label ${subject} \
--output-space {T1w,template} \
--use-aroma \
--mem_mb 80000 \
-n-cpus 8 \
--fs-license-file ${fslicense} \
--fs-no-reconall \
--use-syn-sdc \
-w ${workdir} \
${bidsdir} \
${derivsdir} \
participant
# --------------------------------------------------------------------------------------------------

echo -e "\t\t\t ----- DONE ----- "

