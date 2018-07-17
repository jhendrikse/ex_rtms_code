#!/bin/bash

if [ $# -lt 3 ] ; then
    echo "Script to calculate tissue constituents in an MRS voxel - runs FAST and uses MRS voxel mask"
    echo ""
    echo "Usage: `basename $0` <brain_image> <mrs_voxel_mask> [output_file]"
    echo "  e.g. `basename $0` structs/subj1_brain.nii.gz mrs/subj1_vox1_mask.nii.gz subj1_tissuevols.txt"
    exit 1
fi

# script to calculate constituents in voxel
# derived from one received from Charlie Stagg
# mjt 2007-03-22
# changes to do all three components not just gm
# Matthew Taylor 2007-08-16
# some changes by Jamie Near as well 03/08/2010
#
# version 2 - works with siemens files now
# need to make work with mask image, not .voxel file
#
# Matt 2008-04-08
# Jamie 2010-08-03
# Mark Jenkinson 2011-11  (made it more general wrt filenames)

#STUDYID=$1
#INDIV=$2
#SUBDIR=$3

BRAINIMG=`$FSLDIR/bin/remove_ext $1`
VOXIMG=`$FSLDIR/bin/remove_ext $2`
OUTFILE=`$FSLDIR/bin/remove_ext $3`

#DIR=${HOME}/scratch/${STUDYID}/struc
#STRUCFILE=${HOME}/scratch/${STUDYID}/${INDIV}/images/${INDIV}/*anatomy*.nii.gz
#VOXIMG=${DIR}/${INDIV}_${SUBDIR}_mask.nii.gz
#BRAINDIR=${DIR}/brains/${INDIV}
#BRAINIMG=${BRAINDIR}/${INDIV}_brain
#OUTFILE=${DIR}/${INDIV}_${SUBDIR}_voxel_contents.txt

## Do Brain Extraction
#mkdir -p ${BRAINDIR}
#echo Brain Extraction in progress
#bet ${STRUCFILE} ${BRAINIMG}

# partial volume segmentation
echo partial volume segmentation in progress
$FSLDIR/bin/fast  -t 1 -n 3 ${BRAINIMG}

grey_percent=`$FSLDIR/bin/fslstats ${BRAINIMG}_pve_1 -k ${VOXIMG} -m -v | awk -F ' ' '{print $1}'`
total_volume=`$FSLDIR/bin/fslstats ${BRAINIMG}_pve_1 -k ${VOXIMG} -m -v | awk -F ' ' '{print $3}'`
volume_of_grey=`echo ${grey_percent}*${total_volume} | bc`
white_percent=`$FSLDIR/bin/fslstats ${BRAINIMG}_pve_2 -k ${VOXIMG} -m `
csf_percent=`$FSLDIR/bin/fslstats ${BRAINIMG}_pve_0 -k ${VOXIMG} -m`

echo grey_percent = ${grey_percent}
echo total_vol = ${total_volume}
echo volume of grey = ${volume_of_grey}
echo white_percent = ${white_percent}
echo csf_percent = ${csf_percent}
if [ X${OUTFILE} != X ] ; then
    echo ${BRAINIMG} ${grey_percent} ${white_percent} ${csf_percent} ${total_volume} >> ${OUTFILE}
fi
