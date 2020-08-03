#!/bin/bash
# This script downloads dicoms from XNAT and convert them to nifti using dcm2niix
# Nifti files will be named and organised according to BIDS

# If you havent used xnat-utils before, please load module on your terminal
# It will ask for your log-in details
# Once you've logged on, the module will remember your credentials
# and will allow you to download scans at any time.
# If your password changes you must re-enter your details by loading xnat (module load xnat-utils)
# then enter an xnat function with your authcate username at the end ie. xnat-ls --user <authcate>
# You can then re-enter and save your password.

# BIDS file naming convention:
# t1: sub-000_T1w.nii.gz
# dwi: sub-000_dwi.nii.gz
# rs-fmri: sub-000_task-rest_bold.nii.gz 
# task fmri multiple runs: sub-000_task-nback_run-01_bold.nii.gz
# if you have controls/patients: sub-control000_task-rest_bold.nii.gz / sub-patient000_task-rest_bold.nii.gz
# Accompanying .json files will be created by dcm2niix

# Kristina Sabaroedin and James Morrow BMH, 2017

# Your project paths on your local machine/MASSIVE
PROJDIR=/projects/kg98/
DICOMDIR=$PROJDIR/dicomdir
RAWDATADIR=$PROJDIR/rawdata


if [ ! -d $PROJDIR ]; then mkdir $PROJDIR; echo "making directory"; fi
if [ ! -d $DICOMDIR ]; then mkdir $DICOMDIR; echo "making directory"; fi
if [ ! -d $RAWDATADIR ]; then mkdir $RAWDATADIR; echo "making directory"; fi


# These variables is based on the name of your project and scans on XNAT
# Please edit them accordingly
# Often, scans are named differently on XNAT
# See "First level data cleaning on XNAT" in Evernote for instructions
# After running this script, please check whether all scans are there
# If they are missing, go back on XNAT and see if the scans are named differently

ANATOMICAL=<name of T1 scans on xnat>
REST=<name of resting state scans on xnat>
STUDY=MRH035_ #<change to your study ID>
SESSION=_MR01 #can change to download different sessions

# Text file containing subject IDs
# These IDs just need to be the last three digits (zero padded) i.e. 007, 098, 231, etc
# Change to point to directory where text file is located
SUBJIDS=$(</projects/kg98/<your directory>)

# load modules
module purge;
module load xnat-utils;
# Load the dcm2niix software
module load mricrogl/1.0.20170207
# Module toggles (on/off)
	MODULE1=1 #dcm2niix

# create for loop to loop over IDs
for ID in $SUBJIDS; do 
	
	# Dynamic directories
	SUBDICOMDIR=$DICOMDIR/sub-$ID
	OUTDIR=$RAWDATADIR/sub-$ID;
	EPIOUTDIR=$OUTDIR/func;
	T1OUTDIR=$OUTDIR/anat;

	# Create subject's DICOMS folders 
	mkdir -p $SUBDICOMDIR/

	# Download structural scans from XNAT
	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $ANATOMICAL;

	# Download resting state scans from XNAT
	cd $SUBDICOMDIR/; xnat-get $STUDY$ID$SESSION --scans $REST;

	# Delete intermediate folders
	mv $SUBDICOMDIR/$STUDY$ID$SESSION/* $SUBDICOMDIR

	rm -rf $SUBDICOMDIR/$STUDY$ID$SESSION

	# rename scan directories with more reasonable naming conventions

	# t1
	if [ -d "${SUBDICOMDIR/*$ANATOMICAL}" ]; then 
		mv $SUBDICOMDIR/*$ANATOMICAL $SUBDICOMDIR/t1; 
	else 
		echo "No t1 scan for $ID"; 
	fi

	# resting-state fMRI
	if [ -d "${SUBDICOMDIR/*$REST}" ]; then 
		mv $SUBDICOMDIR/*$REST $SUBDICOMDIR/rfMRI; 
	else 
		echo "No rfMRI scan for $ID"; 
	fi	

	# populate rawdata dir with subjects folders

	if [ ! -d $OUTDIR ]; then mkdir $OUTDIR; echo "$ID - making directory"; fi
	if [ ! -d $EPIOUTDIR ]; then mkdir $EPIOUTDIR; echo "$ID - making func directory"; fi
	if [ ! -d $T1OUTDIR ]; then mkdir $T1OUTDIR; echo "$ID - making anat directory"; fi

	################################ MODULE 1: dcm2niix convert #######################################
	if [ $MODULE1 = "1" ]; then
		echo -e "\nRunning MODULE 1: dcm2niix $ID \n"
		
		# t1
		dcm2niix -f "sub-"$ID"_T1w" -o $T1OUTDIR -b -m n -z y $SUBDICOMDIR"/t1/"

		# fMRI epi
		dcm2niix -f "sub-"$ID"_task-rest_bold" -o $EPIOUTDIR -b -m n -z y $SUBDICOMDIR"/rfMRI/"
		
		echo -e "\nFinished MODULE 1: dcm2niix convert: $ID \n"
	else
		echo -e "\nSkipping MODULE 1: dcm2niix convert: $ID \n"
	fi
	###################################################################################################


done
