% this script will convert r to fisher's z for first level contrast maps 

load('/projects/kg98/Josh/BIDS_data/2nd_level_rs_fmri/fishers_z/con_paths_fishers_z_sma_stim_site.mat') % load array containing filepaths to fisher z con maps for hp seed individual coordinates

% create two column array of pre and post con images 
 
MR01 = inputs(1:2:end,1) ; 
MR02 = inputs(2:2:end,1) ;

con_filenames = [MR01,MR02] ;

for z=1:length(con_filenames)    

filename_pre = con_filenames(z,1) ; % extract each subject pre 1st level con map
filename_post = con_filenames(z,2) ; % extract each subject post 1st level con map 

[path,id,ext] = fileparts(char(con_filenames(z,1))) ; % separate out path, id, extension components of full file path for new file name

output_name = [char(extractBetween(id,'MR01_','_con')),'_post-pre.img'] ; % generate new subject specific filename

%spm_imcalc_ui([filename_pre; filename_post], output_name, 'i2-i1') % use imcalc to subtract post - pre con image
spm_imcalc_ui([filename_pre; filename_post],['/projects/kg98/Josh/BIDS_data/2nd_level_rs_fmri/fishers_z/stim_site_sma/pre_post_difference/',output_name], 'i2-i1') % use imcalc to subtract post - pre con image

end
