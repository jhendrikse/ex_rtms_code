

indir = '/Users/alexfornito/Desktop/16/epi/rest/';
mask = '/Users/alexfornito/Desktop/16/t1/wt1_brain.nii';
roi_def = '/Users/alexfornito/Desktop/prepro_scripts/rois/left/01_-13_15_9_roi_DC.nii';
outname = '/Users/alexfornito/Desktop/16/epi/rest_result.nii';

cov.polort = 1;
cov.ort_file = '/Users/alexfornito/Desktop/16/epi/otherseeds.txt';

fc(indir,mask,roi_def,outname,cov, 'Voxel')

rest_Corr2FisherZ(outname,'/Users/alexfornito/Desktop/16/epi/rest_resultZ.nii',mask);