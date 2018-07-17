function [] = segment_t1_invmat(t1file,spmdir)

% segment_t1_invmat(t1file,spmdir)
%
% This function will perform tissue segmentation of a t1 with SPM using 
% the SPM8 New Segment routine. It will also resample the segmented tissue
% masks to MNI dimensions.
%
% -------
% INPUTS:
% -------
%
% t1file   - a string containing the full path and filename of the T1. 
%            e.g., '/path/to/t1/t1.nii'
%
% spmdir    - string contating the path to where spm is installed; e.g.,
%           '/usr/local/spm8'.
%
% -------
% OUTPUTS:
% -------
%
% segmented images will be written with the prefix ‘c’. e.g., ‘c1’ refers to gm,
% ‘c2’ to wm, ‘c3’ to csf.
%
% normalised, unmodulated images will be written with the prefix ‘wc’; modulated 
% images with ‘mwc’.
%
% The normalised, unmodulated images will be resampled to MNI space. These will 
% be written with the prefix ‘crwc’.
%
% =========================================================================

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3944 $)
%-----------------------------------------------------------------------
spm_jobman('initcfg')

matlabbatch{1}.spm.spatial.preproc.data = {[t1file,',1']};
matlabbatch{1}.spm.spatial.preproc.output.GM = [0 1 1];
matlabbatch{1}.spm.spatial.preproc.output.WM = [0 1 1];
matlabbatch{1}.spm.spatial.preproc.output.CSF = [0 1 1];
matlabbatch{1}.spm.spatial.preproc.output.biascor = 1;
matlabbatch{1}.spm.spatial.preproc.output.cleanup = 0;
matlabbatch{1}.spm.spatial.preproc.opts.tpm = {
                                               [spmdir,'tpm/grey.nii']
                                               [spmdir,'tpm/white.nii']
                                               [spmdir,'tpm/csf.nii']
                                               };
matlabbatch{1}.spm.spatial.preproc.opts.ngaus = [2
                                                 2
                                                 2
                                                 4];
matlabbatch{1}.spm.spatial.preproc.opts.regtype = 'mni';
matlabbatch{1}.spm.spatial.preproc.opts.warpreg = 1;
matlabbatch{1}.spm.spatial.preproc.opts.warpco = 25;
matlabbatch{1}.spm.spatial.preproc.opts.biasreg = 0.0001;
matlabbatch{1}.spm.spatial.preproc.opts.biasfwhm = 60;
matlabbatch{1}.spm.spatial.preproc.opts.samp = 3;
matlabbatch{1}.spm.spatial.preproc.opts.msk = {''};


% breakdown filename
[t1dir t1name t1suff] = fileparts(t1file);

% resample to MNI dimensions
matlabbatch{2}.spm.spatial.coreg.write.ref = {[spmdir,'templates/T1.nii,1']};
matlabbatch{2}.spm.spatial.coreg.write.source = {
                                                 [t1dir,'/wc1',t1name,t1suff,',1']
                                                 [t1dir,'/wc2',t1name,t1suff,',1']
                                                 [t1dir,'/wc3',t1name,t1suff,',1']
                                                 };
matlabbatch{2}.spm.spatial.coreg.write.roptions.interp = 1;
matlabbatch{2}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{2}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{2}.spm.spatial.coreg.write.roptions.prefix = 'cr';

spm_jobman('run',matlabbatch);
