% this script will convert r to fisher's z for first level contrast maps 

load('/projects/kg98/Josh/inputs_MR02_DCP_SMA_stim.mat') % load in .mat file with variable 'inputs' containing full path files to 1st level contrast maps

for z=1:length(inputs) %:length(inputs)

[path,id,ext] = fileparts(char(inputs(z,1))) ;   % separate file paths in to path, subject ID, and file extention

filename = [char(extractBetween(path,'data/','/derivatives')),'_',char(extractBetween(path,'prep/','/func')),'_DCP_seed_SMA_stim_',id,ext] ; % specify subject specific output file name

% matlab batch using imcalc to convert fishers z from r 
matlabbatch{1}.spm.util.imcalc.input = inputs(z);
matlabbatch{1}.spm.util.imcalc.output = filename;
matlabbatch{1}.spm.util.imcalc.outdir = {'/projects/kg98/Josh/BIDS_data/2nd_level_rs_fmri/fishers_z/DCP_seed_SMA_stim_MR02'};
matlabbatch{1}.spm.util.imcalc.expression = '0.5*log((1+i1)./(1-i1))';
matlabbatch{1}.spm.util.imcalc.options.dmtx = 0;
matlabbatch{1}.spm.util.imcalc.options.mask = 0;
matlabbatch{1}.spm.util.imcalc.options.interp = 1;
matlabbatch{1}.spm.util.imcalc.options.dtype = 4;

spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch) ;

end
