% This script takes the GABA concentrations for the pre and post scans from the left hippocampus, left parietal, and SMA voxels and outputs them (& other data metrics) into a six column matrix 
% + subject structure (subject_data). 

close all; clc; clear;

%Define group level directory 

subject_group = input('Enter the subject group (Active or Inactive): ','s');

switch(subject_group) 
    case('Active')
        datapath = '/Volumes/Lacie/Ex_rTMS_study/Data/Active';
    case('Inactive') 
        datapath = '/Volumes/Lacie/Ex_rTMS_study/Data/Inactive';
end

cd (datapath);

% Select subjects to run analysis on
filter_str = ''; fileselect; pause(0.1); % calls fileselect.m located in Gannet3.0-master directory

%% Calculate GABA concentrations and data metrics from GANNET_V3 MRS_struct.mat files

for bigK=1:length(FILE)
    
    all_summary = [];
    OutName = FILE{bigK};
    if isdir([datapath,'/',FILE{bigK}])
        
        gopre = fullfile(datapath,'/',FILE{bigK},'/MRI/MRS/pre/Gannet3.0'); %Subject pre directory
     
        HP_pre = dir([gopre '/meas_*hippocampus']);
        PTL_pre = dir([gopre '/meas_*Parietal']);
        SMA_pre = dir([gopre '/meas_*SMA']);
        
        HP_pre = fullfile(gopre, cell({HP_pre.name}));
        PTL_pre = fullfile(gopre, cell({PTL_pre.name}));
        SMA_pre = fullfile(gopre, cell({SMA_pre.name}));
    end
    
    if isdir([datapath,'/',FILE{bigK}])
        
        gopost = fullfile(datapath,'/',FILE{bigK},'/MRI/MRS/post/Gannet3.0'); %Subject post directory
        
        HP_post = dir([gopost '/meas_*hippocampus']);
        PTL_post = dir([gopost '/meas_*Parietal']);
        SMA_post = dir([gopost '/meas_*SMA']);
        
        HP_post = fullfile(gopost, cell({HP_post.name}));
        PTL_post = fullfile(gopost, cell({PTL_post.name}));
        SMA_post = fullfile(gopost, cell({SMA_post.name}));
    end
    
  HP_all = [HP_pre, HP_post]; % Creates variables for each voxel filepath at each timepoint 
  PTL_all = [PTL_pre, PTL_post];
  SMA_all = [SMA_pre, SMA_post];
  
  all_all = [HP_pre, HP_post, PTL_pre, PTL_post, SMA_pre, SMA_post]; %Creates matrix which includes path to all three voxel files at both timepoints
  
  for x = 1:length(all_all)  % determine if water twix are present, returns missing data as 99999 if not found. 
  load ([all_all{x}, '/MRS_struct.mat']);
  
  if isfield(MRS_struct.out.vox1,'water')
      MRS_struct.out.vox1.water.Area = MRS_struct.out.vox1.water.Area;
      MRS_struct.out.vox1.Cr.Area = MRS_struct.out.vox1.Cr.Area;
      MRS_struct.out.vox1.GABA.ConcIU = MRS_struct.out.vox1.GABA.ConcIU;
      MRS_struct.out.vox1.GABA.ConcCr = MRS_struct.out.vox1.GABA.ConcCr;
      MRS_struct.out.vox1.Glx.ConIU = MRS_struct.out.vox1.Glx.ConcIU;
      MRS_struct.out.vox1.Glx.ConcCr = MRS_struct.out.vox1.Glx.ConcCr;
  else
      MRS_struct.out.vox1.water.Area = 99999;
      MRS_struct.out.vox1.Cr.Area = MRS_struct.out.vox1.Cr.Area;
      MRS_struct.out.vox1.GABA.ConcIU = 99999;
      MRS_struct.out.vox1.GABA.ConcCr = MRS_struct.out.vox1.GABA.ConcCr;
      MRS_struct.out.vox1.Glx.ConIU = 99999;
      MRS_struct.out.vox1.Glx.ConcCr = MRS_struct.out.vox1.Glx.ConcCr;
  end
  
  GABA_output = [MRS_struct.out.vox1.water.Area MRS_struct.out.vox1.Cr.Area MRS_struct.out.vox1.GABA.ConcIU MRS_struct.out.vox1.GABA.ConcCr MRS_struct.out.vox1.Glx.ConIU MRS_struct.out.vox1.Glx.ConcCr];
  GABA_output = GABA_output';
  
  all_summary = ([all_summary, GABA_output]);
  end

%%  Save output from individual subject as a structure (could create structure for all subjects)

subject_data(bigK).subject_ID = OutName;
subject_data(bigK).all_summary = all_summary;
  
%summary(bigK).HP = hippocampus;
%summary(bigK).Parietal = Parietal;
%summary(bigK).sma = sma;
  
end