#!/bin/bash
#This script creates a voxel mask image that can be used to
#determine the tissue components within an MRS voxel.

if [ $# -lt 3 ] ; then
  echo "This script creates a voxel mask image that can be used to determine the tissue components within an MRS voxel."
  echo " "
  echo "Usage: `basename $0` <structural_image> <mrs_rda_file> <output_mask_image>"
  echo "  e.g. `basename $0` structs/N11_99/brain.nii.gz mrs/N11_99_999/press.rda mrs_mask.nii.gz"
  exit 1;
fi
#

# Mark Jenkinson 11/2011
# Generalised the use of filenames
#
# Jamie Near 02/08/2010
# Developed with a great deal of help of Mark Jenkinson
# Using some bits of code from Matt Taylor (get_voxel_from_rda.sh)

# Matt Taylor's original code was not designed to handle MRS voxels that
# are tilted with respect to the scanner coordinate space.
# This code has been modified to handle MRS voxels that are tilted
# in any orientation

# This script now accepts structural images with any resolution (not
# only 1x1x1mm).  Modification by Mark Jenkinson


#STUDYID=$1
#INDIV=$2
#SUBDIR=$3

STRUCFILE=$1
MRS_RDA=$2
OUTFILE=$3

#SCANDIR=${HOME}/scratch/${STUDYID}
#MRS_RDA=${SCANDIR}/${INDIV}/${SUBDIR}/*.rda
#STRUCFILE=${SCANDIR}/${INDIV}/images/${INDIV}/*anatomy*nii.gz
#TEMPDIR=${SCANDIR}/struc/temp_${INDIV}_${SUBDIR}
#OUTFILE=${SCANDIR}/struc/${INDIV}_${SUBDIR}_mask

TEMPDIR=`$FSLDIR/bin/tmpnam`X
MATFILE=${TEMPDIR}/mat
mkdir -p ${TEMPDIR}

# get voxel information from .rda file:
POS1=$(strings ${MRS_RDA} | egrep ^VOIPositionSag | cut -d ' ' -f2)
POS2=$(strings ${MRS_RDA} | egrep ^VOIPositionCor | cut -d ' ' -f2)
POS3=$(strings ${MRS_RDA} | egrep ^VOIPositionTra | cut -d ' ' -f2)
VOX1=$(strings ${MRS_RDA} | egrep ^FoVWidth | cut -d ' ' -f2)
VOX2=$(strings ${MRS_RDA} | egrep ^FoVHeight | cut -d ' ' -f2)
VOX3=$(strings ${MRS_RDA} | egrep ^SliceThickness | cut -d ' ' -f2)
ROW1=$(strings ${MRS_RDA} | egrep ^RowVector.0 | cut -d ' ' -f2)
ROW2=$(strings ${MRS_RDA} | egrep ^RowVector.1 | cut -d ' ' -f2)
ROW3=$(strings ${MRS_RDA} | egrep ^RowVector.2 | cut -d ' ' -f2)
COL1=$(strings ${MRS_RDA} | egrep ^ColumnVector.0 | cut -d ' ' -f2)
COL2=$(strings ${MRS_RDA} | egrep ^ColumnVector.1 | cut -d ' ' -f2)
COL3=$(strings ${MRS_RDA} | egrep ^ColumnVector.2 | cut -d ' ' -f2)

# Print the values that were found
#echo subject and voxel = ${INDIV} ${SUBDIR}
echo POS= $POS1 $POS2 $POS3
echo VOX= $VOX1 $VOX2 $VOX3
echo ROW= $ROW1 $ROW2 $ROW3
echo COL= $COL1 $COL2 $COL3

# Get the voxel dimensions of the structural image, as we may need these
# in the future
VST1=$($FSLDIR/bin/fslinfo ${STRUCFILE} | egrep ^pixdim1 | cut -d ' ' -f9)
VST2=$($FSLDIR/bin/fslinfo ${STRUCFILE} | egrep ^pixdim2 | cut -d ' ' -f9)
VST3=$($FSLDIR/bin/fslinfo ${STRUCFILE} | egrep ^pixdim3 | cut -d ' ' -f9)

# Print the values that were found
echo ${VST1} ${VST2} ${VST3}

# Change the sign of the x- and y-coordinates on the **ASSUMPTION** that
# the nifti version of the scanner coordinates and the spectroscopy version
# of the scanner coordinates are related by x -> -x, y -> -y, z -> z

POS1=`echo "$POS1 * -1.0" | bc -l`
POS2=`echo "$POS2 * -1.0" | bc -l`
ROW1=`echo "$ROW1 * -1.0" | bc -l`
ROW2=`echo "$ROW2 * -1.0" | bc -l`
COL1=`echo "$COL1 * -1.0" | bc -l`
COL2=`echo "$COL2 * -1.0" | bc -l`

# While ROW and COL specify two of the axes of the voxel orientation in
# scanner space, we still need a vector to specify the third axis.  We
# will obtain this by performing a cross product of ROW and COL, and we
# will call the resulting vector ZED

ZED1=`echo "($COL2 * $ROW3) - ($COL3 * $ROW2)" |bc`
ZED2=`echo "($COL3 * $ROW1) - ($COL1 * $ROW3)" |bc`
ZED3=`echo "($COL1 * $ROW2) - ($COL2 * $ROW1)" |bc`
echo ZED= ${ZED1} ${ZED2} ${ZED3}

# Get the transformation from the structural image coordinate space (st)
# into the scanner coordinate space (sc)
$FSLDIR/bin/fslval ${STRUCFILE} sto_xyz:1 > ${MATFILE}_st2sc
$FSLDIR/bin/fslval ${STRUCFILE} sto_xyz:2 >> ${MATFILE}_st2sc
$FSLDIR/bin/fslval ${STRUCFILE} sto_xyz:3 >> ${MATFILE}_st2sc
$FSLDIR/bin/fslval ${STRUCFILE} sto_xyz:4 >> ${MATFILE}_st2sc

# Convert the _st2sc matrix so that the input coords (st) are in (FLIRT) mm, not voxels
# deal with potential handedness issues for NEUROLOGICAL vs RADIOLOGICAL
if [ `$FSLDIR/bin/fslorient ${STRUCFILE}` = NEUROLOGICAL ] ; then
    xsize=`$FSLDIR/bin/fslval ${STRUCFILE} dim1`;
    xsize=`echo "($xsize - 1) * $VST1" | bc -l`;
    xmul=`echo "$VST1 * -1" | bc -l`;
    echo "$xmul 0 0 $xsize" > ${MATFILE}_nvox2fmm
else
    echo "$VST1 0 0 0" > ${MATFILE}_nvox2fmm
fi
echo "0 $VST2 0 0" >> ${MATFILE}_nvox2fmm
echo "0 0 $VST3 0" >> ${MATFILE}_nvox2fmm
echo "0 0 0 1" >> ${MATFILE}_nvox2fmm
$FSLDIR/bin/convert_xfm -omat ${MATFILE}_fmm2nvox -inverse ${MATFILE}_nvox2fmm
$FSLDIR/bin/convert_xfm -omat ${MATFILE}_st2sc -concat ${MATFILE}_st2sc ${MATFILE}_fmm2nvox

# We will need the inverse of this matrix:
$FSLDIR/bin/convert_xfm -omat ${MATFILE}_sc2st -inverse ${MATFILE}_st2sc

# Now we are ready to make the initial mask.  Start by puting it in the
# bottom corner of the image.  Only the size will be correct.
# convert VOX1 from mm to structural voxel units
VOX1vox=`echo $VOX1 / $VST1 | bc -l`;
VOX2vox=`echo $VOX2 / $VST2 | bc -l`;
VOX3vox=`echo $VOX3 / $VST3 | bc -l`;
$FSLDIR/bin/fslmaths ${STRUCFILE} -mul 0 -add 1 -roi 0 ${VOX1vox} 0 ${VOX2vox} 0 ${VOX3vox} 0 1 ${TEMPDIR}_vox_start


# Okay, now we need to make a rotation matrix to rotate from the spectroscopy
# voxel coordinate space (sp), into the scanner coordinate space (sc)
echo $(echo ${ROW1} ${COL1} ${ZED1}) 0 > ${MATFILE}_sp2sc_R
echo $(echo ${ROW2} ${COL2} ${ZED2}) 0 >> ${MATFILE}_sp2sc_R
echo $(echo ${ROW3} ${COL3} ${ZED3}) 0 >> ${MATFILE}_sp2sc_R
echo 0 0 0 1 >> ${MATFILE}_sp2sc_R

# Now we need to make two translation matrices to translate from the spectroscopy
# voxel coordinate space, into the scanner coordinate space:
# The first translates by the voxel centre position in scanner space
echo 0 0 0 $(echo ${POS1})> ${MATFILE}_sc_Tc
echo 0 0 0 $(echo ${POS2})>> ${MATFILE}_sc_Tc
echo 0 0 0 $(echo ${POS3})>> ${MATFILE}_sc_Tc
echo 0 0 0 0 >> ${MATFILE}_sc_Tc

# And the second translates back by half of the voxel dimensions.
echo 1 0 0 $(echo -.5*${VOX1} | bc)> ${MATFILE}_sc_Tv
echo 0 1 0 $(echo -.5*${VOX2} | bc)>> ${MATFILE}_sc_Tv
echo 0 0 1 $(echo -.5*${VOX3} | bc)>> ${MATFILE}_sc_Tv
echo 0 0 0 1 >> ${MATFILE}_sc_Tv

# Next, we must concatenate sc2st with sc_Tc to make a new matrix,
# which we will call:  st_Tc

$FSLDIR/bin/convert_xfm -omat ${MATFILE}_st_Tc -concat ${MATFILE}_sc2st ${MATFILE}_sc_Tc

# Now we have all of the matrices that we need.  All we have to do now is
# put them together by concatenating (as well as a bit of tricky manipulation
# as you will soon see).

# We need to make a matrix that contains the 4x4 identity matrix combined with
# the last column of the st_Tc matrix.	We will call the resulting matrix
# Id_st_Tc.  This is where the tricky manipulation happens:
col4=`cat ${MATFILE}_st_Tc | awk '{ print $4 }'`
t1=`echo $col4 | cut -d' ' -f1`
t2=`echo $col4 | cut -d' ' -f2`
t3=`echo $col4 | cut -d' ' -f3`

echo 1 0 0 $t1 > ${MATFILE}_Id_st_Tc
echo 0 1 0 $t2 >> ${MATFILE}_Id_st_Tc
echo 0 0 1 $t3 >> ${MATFILE}_Id_st_Tc
echo 0 0 0 1 >> ${MATFILE}_Id_st_Tc


# Now we just need to do some contatenations:
$FSLDIR/bin/convert_xfm -omat ${MATFILE}_sp2st_R -concat ${MATFILE}_sc2st ${MATFILE}_sp2sc_R
$FSLDIR/bin/convert_xfm -omat ${MATFILE}_sp2st_Tv_R -concat ${MATFILE}_sp2st_R ${MATFILE}_sc_Tv
$FSLDIR/bin/convert_xfm -omat ${MATFILE}_final -concat ${MATFILE}_Id_st_Tc ${MATFILE}_sp2st_Tv_R

$FSLDIR/bin/flirt -in ${TEMPDIR}_vox_start -ref ${STRUCFILE} -out ${OUTFILE} -applyxfm -init ${MATFILE}_final -interp nearestneighbour

#fslview ${STRUCFILE} ${OUTFILE}

#clean up
rm -r ${TEMPDIR}


