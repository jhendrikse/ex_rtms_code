#!/bin env bash

subject_list="/projects/kg98/Josh/BIDS_data/SubjectIDs_backup.txt"

cat $subject_list | while read LINE
do  
mkdir derivatives/fmriprep/$i/rois
done

