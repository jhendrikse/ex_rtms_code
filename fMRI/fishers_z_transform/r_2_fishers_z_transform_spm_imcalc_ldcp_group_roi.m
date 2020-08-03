% this script will convert r to fisher's z for first level contrast maps 

%load('/projects/kg98/Josh/BIDS_data/inputs_1st_level_dcp_group_seed.mat') % load in .mat file with variable 'inputs' containing full path files to 1st level contrast maps
inputs = {'/projects/kg98/Josh/BIDS_data/MR01/derivatives/fmriprep/sub-CR38/func/spm_sphere_3_-28_1_3/con_0001.img'}

for z=1:length(inputs) %:length(inputs)

[path,id,ext] = fileparts(char(inputs(z,1))) ;   % separate file paths in to path, subject ID, and file extention

filename = [char(extractBetween(path,'data/','/derivatives')),'_',char(extractBetween(path,'prep/','/func')),'_',char(extractAfter(path,'/func/')),'_',id,ext] ; % specify subject specific output file name

% matlab batch using imcalc to convert fishers z from r 
matlabbatch{1}.spm.util.imcalc.input = inputs(z);
matlabbatch{1}.spm.util.imcalc.output = filename;
matlabbatch{1}.spm.util.imcalc.outdir = {'/projects/kg98/Josh/BIDS_data/2nd_level_rs_fmri/fishers_z/DCP_seed_group_1st_level_con/'};
matlabbatch{1}.spm.util.imcalc.expression = '0.5*log((1+i1)./(1-i1))';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

%spm_jobman('initcfg');
spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch) ;

end
