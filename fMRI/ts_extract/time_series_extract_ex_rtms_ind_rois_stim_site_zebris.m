function [] = time_series_extract_ex_rtms_ind_rois_stim_site_zebris

% This script will perform ROI time series extraction looping over ex_rtms BIDS formatted subjects.
%
% Only some basic inputs need to be defined at the beginning of the script.

% NB: Requires version of FSL that allows '-w' option in fslmeants

% Extract ROI time series (uses fslmeants). Time series will be
% weighted by GM probability. Outputs .mat files which can be interpreted
% through spm.

% Modified by Chao Suo, Josh Hendrikse & James Coxon, Monash University, 2018/9.

%% Define software paths and subject IDs

%subject = {,'sub-CR38',
%subject = {'sub-017','sub-018','sub-019','sub-020','sub-021','sub-022','sub-023','sub-024','sub-026','sub-027','sub-028','sub-029','sub-030','sub-031','sub-PKA30','sub-AR31','sub-CD32','sub-DJG33','sub-ST34','sub-TG35','sub-AY36','sub-JT37','sub-EH39','sub-NU40','sub-JC41','sub-SA42','sub-PL43','sub-ID44'};
subject = {'sub-DJ03','sub-006','sub-007','sub-008','sub-009','sub-010','sub-011','sub-012','sub-015'} ; 
cnt=1;

% spm dir 
system('module load spm8/matlab2015b.r6685');
%system('module load spm12/matlab2018a.r7487');
spmdir ='/usr/local/spm8/matlab2015b.r6685';
%spmdir ='/usr/local/spm12/matlab2018a.r7487';
addpath(genpath(spmdir));

% add path to spm first_level_ex_rtms script 
addpath(genpath('/projects/kg98/Josh/code/')) ;

% set FSL environments
system('module load fsl/5.0.9');
fsldir ='/usr/local/fsl/5.0.9/fsl/bin/'; % directory where fsl is
setenv('FSLDIR',fsldir(1:end-4));
setenv('FSLOUTPUTTYPE','NIFTI');

% directory where marsbar is. Path will be added and removed as required in
% script below to avoid conflict with spm routines
%marsbar_dir = '/Applications/MATLAB_toolboxes/spm8/marsbar/';

%% Define paths containing t1 and epi data

for z = 1:length(subject) %loop over subjects
    
% subject directory containing BIDS formatted fmriprep output    
% subject_dir = ['/projects/kg98/Josh/BIDS_data/MR01/derivatives/fmriprep/',subject{1,z}] ;

% Define the path to the ROIs
rois_dir = ['/projects/kg98/Josh/BIDS_data/MR01/derivatives/fmriprep/',subject{1,z},'/rois/stim_site_zebris/'];

% generate list of roi file names
roifiles = dir(fullfile(rois_dir,'*.nii'));
  
% directory containing smoothed epi files 
epidir = ['/projects/kg98/Josh/BIDS_data/MR01/derivatives/fmriprep/',subject{1,z},'/func/'] ; % directory containing epi 4d files smoothed by fmriprep

% read in .tsv file containing nuisance regressors produced by fmriprep 
nr = tdfread([epidir,char(subject{1,z}),'_task-rest_bold_confounds.tsv']);

% select x,y,z,pitch,roll,yaw,white matter,csf columns and save as R 
n_reg = [nr.X nr.Y nr.Z nr.RotX nr.RotY nr.RotZ nr.WhiteMatter nr.CSF];

% smoothed epi 4d filename
epifile = dir([epidir,subject{1,z},'_task-rest_bold_space-MNI152NLin2009cAsym_variant-smoothAROMAnonaggr_preproc.nii.gz']) ;
epi4d = epifile.name ; % smoothed epi file 

% length of time series (no. vols)
N = 179;

% Repetition time of acquistion in secs - changed from 1 which was listed
% on previous versions of code. 
TR = 2.46;

% t1 directory 
t1dir = ['/projects/kg98/Josh/BIDS_data/MR01/derivatives/fmriprep/',subject{1,z},'/anat/'];

% t1 name
t1name = [subject{1,z},'_T1w_space-MNI152NLin2009cAsym_preproc.nii.gz'];

% the path and filename of the template in MNI space to which everything will be normalized
% mni_template = [spmdir,'templates/T1.nii'];

% mni_template = [fsldir(1:end-4),'/data/standard/MNI152_T1_2mm.nii'];

% roi directory - use for subject specific roi locations
%roidir = ['/projects/kg98/Josh/BIDS_data/MR01/derivatives/fmriprep/',subject{1,z},'/rois'];

% generate list of roi file names
%roifiles_subject = dir(fullfile(roidir,'*.nii'));

%% Extract ROI time series
tic;

% full path to grey matter probability mask file
gm_prob_mask = [t1dir,subject{1,z},'_T1w_space-MNI152NLin2009cAsym_class-GM_probtissue.nii.gz'] ; 

% GM masks need to be resampled to 2mm - for ex_rtms data this has already
% been completed during previous 1st level analysis using time_series_extract_ex_rtms_MR01.m. 

% resample grey matter prob mask to 2mm to align with epi
% xfm_transform_gm_prob = [fsldir,'flirt -in ' gm_prob_mask ' -ref ' [epidir,epi4d] ...
%     ' -out ' [epidir,'gm2mm'] ' -applyisoxfm 2 -interp trilinear'];

% run 2mm resample of gm probability image      
% system(xfm_transform_gm_prob);  

% cd to directory containing epi images
cd(epidir) 

% Make directory for individualised ROI analysis
system(['mkdir stim_site_zebris_3mm']) ;

%generate list of rois
for i = 1:length(roifiles)
  
tic;

% Weight roi images by GM probability
system([fsldir,'fslmaths ',[rois_dir,roifiles(i).name],' -mul ',[epidir,'gm2mm.nii'],' roi_gs']);  
    
% extract weighted time series and save to temp.txt
system([fsldir,'fslmeants -i ',epi4d,' -o temp.txt -m roi_gs -w']); 
    
% read temp.txt and save to roi_ts with different column for each roi (i.e. one for left hippocampus and another for left dcp)
%roi_ts(:,i) = dlmread([epidir,'temp.txt']); 
roi_ts = dlmread([epidir,'temp.txt']);
    
fprintf('Time series extracted for ROI %d of %d \n',i,length(roifiles)); toc;

system(['rm ',epidir,'temp.txt']); % remove temporary variables containing individual time series
system(['rm ',epidir,'roi_gs*']); % remove roi images weighted by GM probability signal 

fprintf('roi time series extracted \n'); 

times(cnt)=toc;

cnt=cnt+1;

%% Save relevant variables
tic;
 
savefile = (['roi_ts_stim_site_zebris','_',roifiles(i).name(1:end-4)]) ;
save (savefile,'roi_ts') ;
system(['mv ',savefile,'.mat',' stim_site_zebris_3mm']) ;

% concatenate roi time series and nuisance regressors
R = [roi_ts n_reg] ; 

savefile = (['spm_regs_stim_site_zebris','_',roifiles(i).name(1:end-4)]) ; % create variable savefile containing roi time series columns & 8 nuisance regressors columns

save(savefile, 'R') % save file as R.mat for spm compatibility 
system(['mv ',savefile,'.mat',' stim_site_zebris_3mm']) ;

%% Run first level specification and estimation

% Define name for output directory where con images will be stored
thespmdir = ([epidir,'stim_site_zebris_3mm/','spm_zebris_','_',roifiles(i).name(1:end-4)]) ;

% Define input directory for time series and regressor file
roi_ts_regs_dir = ([epidir,'stim_site_zebris_3mm/']) ;

% Make spm output directory
system(['mkdir ',thespmdir]) ;

% Separate epi image file into path, filename, and '.gz' suffix 
[aa,bb,cc]= fileparts([epidir epi4d]) ;
     
% If unzipped file does not exist, unzip it
if exist([aa filesep bb]) == 0 
   gunzip ([epidir,epi4d]) ;
end

% Define epi input as epi unzipped file
input_epi_file= [aa filesep bb]; 

% Call first_level_ex_rtms function to run SPM first level analysis.
% Function runs twice, once for each roi timeseries
first_level_ex_rtms(thespmdir,'scans',TR,input_epi_file,N,[roi_ts_regs_dir,savefile,'.mat'],[t1dir,t1name]) ; % run first level analysis
 
fprintf('First level analysis done \n') ; toc;

times(cnt)=toc ;

cnt=cnt+1 ;
     
end

% Save time stamps
% save times_brain_site_roi times
% movefile times_brain_site_roi.mat stim_site_brain_site ;

end