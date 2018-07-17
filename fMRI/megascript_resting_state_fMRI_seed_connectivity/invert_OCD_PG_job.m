%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3944 $)
%-----------------------------------------------------------------------
matlabbatch{1}.spm.spatial.normalise.write.subj.matname = {'/Users/orwa/Desktop/TMS_fMRI/workdir/subject/t1/t1_seg_inv_sn.mat'};
matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {'/Users/orwa/Desktop/TMS_fMRI/workdir/subject/epi/spm/stimclust.img,1'};
matlabbatch{1}.spm.spatial.normalise.write.roptions.preserve = 0;
matlabbatch{1}.spm.spatial.normalise.write.roptions.bb = [-90 -126 -72
                                                          90 90 108];
matlabbatch{1}.spm.spatial.normalise.write.roptions.vox = [2 2 2];
matlabbatch{1}.spm.spatial.normalise.write.roptions.interp = 1;
matlabbatch{1}.spm.spatial.normalise.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.normalise.write.roptions.prefix = 'winv';
matlabbatch{2}.spm.spatial.coreg.write.ref = {'/Users/orwa/Desktop/TMS_fMRI/workdir/subject/t1/t1.nii,1'};
matlabbatch{2}.spm.spatial.coreg.write.source(1) = cfg_dep;
matlabbatch{2}.spm.spatial.coreg.write.source(1).tname = 'Images to Reslice';
matlabbatch{2}.spm.spatial.coreg.write.source(1).tgt_spec = {};
matlabbatch{2}.spm.spatial.coreg.write.source(1).sname = 'Normalise: Write: Normalised Images (Subj 1)';
matlabbatch{2}.spm.spatial.coreg.write.source(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
matlabbatch{2}.spm.spatial.coreg.write.source(1).src_output = substruct('()',{1}, '.','files');
matlabbatch{2}.spm.spatial.coreg.write.roptions.interp = 1;
matlabbatch{2}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{2}.spm.spatial.coreg.write.roptions.prefix = 'r';
