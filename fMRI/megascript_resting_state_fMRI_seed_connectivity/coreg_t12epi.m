function [] = coreg_t12epi(meanepi, t1, brain, gm, wm, csf)

%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 3944 $)
%-----------------------------------------------------------------------

spm_jobman('initcfg')

matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {[meanepi,',1']};
matlabbatch{1}.spm.spatial.coreg.estwrite.source = {[t1,',1']};
matlabbatch{1}.spm.spatial.coreg.estwrite.other = {
                                                   [brain,',1']
                                                   [gm,',1']
                                                   [wm,',1']
                                                   [csf,',1']
                                                   };
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 1;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'epi_';

spm_jobman('run',matlabbatch);
