% This script returns the partial volume corrected GABA, Glx, and NAA concentrations for
% for left hippocampus, left parietal, and
% pre supplementary motor area voxels for pre and post timepoints. 

% To run:

% 1) Make sure importfile_partial_vol.m is visable on the MATLAB path.
% 2) Set paths to MRS_struct data and partial vol dataset 

% Joshua Hendrikse, joshua.hendrikse@monash.edu, 2019

%% Define paths & grouping variables

close all; clc; clear;

% add paths to data directories
addpath(genpath('/Volumes/LaCie/Ex_rTMS_study/ex_rtms_code/MRS/volume_correction/')) ;

addpath(genpath('/Volumes/LaCie_R/Ex_rTMS_study/Data/Analysis/Datasets/final_datasets/MRS/')) ;

addpath(genpath('/Volumes/LaCie_R/Ex_rTMS_study/Data/all_subjects/')) ;

pathIn = '/Volumes/LaCie_R/Ex_rTMS_study/Data/' ;

pathIn_specdata = [pathIn,'all_subjects/'];

ID = {'S3_DJ';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'} ; % all subjects


%% This cell to import partial volume corrected values from partial_vol_corr.txt 

filename_partial_vol = [pathIn,'Analysis','/','Datasets','/','final_datasets','/','MRS','/','Partial_vol_corr.csv'] ;

Data_vox_partial_vol = importfile_partial_vol(filename_partial_vol) ;


%% Extract GABA filepath & filenames

% Initialise variables
GABA_HP_pre_path = cell(length(ID),1) ;
GABA_PTL_pre_path = cell(length(ID),1) ;
GABA_SMA_pre_path = cell(length(ID),1) ;
GABA_HP_post_path = cell(length(ID),1) ;
GABA_PTL_post_path = cell(length(ID),1) ;
GABA_SMA_post_path = cell(length(ID),1) ;

for y = 1:length(ID) %for loop to extract GABA filepaths for each voxel at each timepoint
    
    %HP GABA pre timepoint file path
    GABA_HP_pre_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Pre/','GABA_only/','meas_*_hippocampus']) ; % generate absolute path to data dir
    
    if  isempty([GABA_HP_pre_dir.name]) == 0
        GABA_HP_pre_path{y,:} = [GABA_HP_pre_dir.folder,'/',GABA_HP_pre_dir.name] ; % if exists, save absolute path to cell array
    else
        GABA_HP_pre_path{y,:} = '<missing>' ; % else, leave empty
    end

    %PTL GABA pre timepoint file path    
    GABA_PTL_pre_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Pre/','GABA_only/','meas_*_parietal']) ;
    
    if  isempty([GABA_PTL_pre_dir.name]) == 0
        GABA_PTL_pre_path{y,:} = [GABA_PTL_pre_dir.folder,'/',GABA_PTL_pre_dir.name] ;
    else
        GABA_PTL_pre_path{y,:} = '<missing>' ;
    end
    
    %SMA GABA pre timepoint file path
    GABA_SMA_pre_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Pre/','GABA_only/','meas_*_sma']) ;
    
    if  isempty([GABA_SMA_pre_dir.name]) == 0
        GABA_SMA_pre_path{y,:} = [GABA_SMA_pre_dir.folder,'/',GABA_SMA_pre_dir.name] ;
    else
        GABA_SMA_pre_path{y,:} = '<missing>' ;
    end
    
    %HP GABA post timepoint file path
    GABA_HP_post_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Post/','GABA_only/','meas_*_hippocampus']) ;
    
    if  isempty([GABA_HP_post_dir.name]) == 0
        GABA_HP_post_path{y,:} = [GABA_HP_post_dir.folder,'/',GABA_HP_post_dir.name] ;
    else
        GABA_HP_post_path{y,:} = '<missing>' ;
    end
    
    %PTL GABA post timepoint file path
    GABA_PTL_post_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Post/','GABA_only/','meas_*_parietal']) ;
    
    if  isempty([GABA_PTL_post_dir.name]) == 0
        GABA_PTL_post_path{y,:} = [GABA_PTL_post_dir.folder,'/',GABA_PTL_post_dir.name] ;
    else
        GABA_PTL_post_path{y,:} = '<missing>' ;
    end
    
    %SMA GABA post timepoint file path
    GABA_SMA_post_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Post/','GABA_only/','meas_*_sma']) ;
    
    if  isempty([GABA_SMA_post_dir.name]) == 0
        GABA_SMA_post_path{y,:} = [GABA_SMA_post_dir.folder,'/',GABA_SMA_post_dir.name] ;
    else
        GABA_SMA_post_path{y,:} = '<missing>' ;
    end
end

% Save all file paths in cell 
%all_filepaths_GABA = [GABA_HP_pre_path, GABA_HP_post_path, GABA_PTL_pre_path, GABA_PTL_post_path, GABA_SMA_pre_path, GABA_SMA_post_path] ;


%% HIPPOCAMPUS GABA

% Hippocampus pre timepoint

% Initialise summary variables
HP_pre_water_area_summary = cell(length(ID),1) ;
HP_pre_water_FWHM_summary = cell(length(ID),1) ;
HP_pre_water_fit_err_summary = cell(length(ID),1) ;
HP_pre_GABA_water_fit_err_summary = cell(length(ID),1) ;   
HP_pre_NAA_area_summary = cell(length(ID),1) ;
HP_pre_NAA_fit_error_summary = cell(length(ID),1) ;
HP_pre_NAA_FWHM_summary = cell(length(ID),1) ;
% for loop across HP pre time point across subjects 

% Load MRS_struct.mat files containing metabolite estimates across subjects

for z = 1:length(GABA_HP_pre_path)
    
    if ismissing(GABA_HP_pre_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for HP pre path for each subject
        
        load([GABA_HP_pre_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            HP_pre_water_area = MRS_struct.out.vox1.water.Area ;
            HP_pre_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
            HP_pre_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            HP_pre_GABA_water_fit_error = MRS_struct.out.vox1.GABA.FitError_W ;
            HP_pre_NAA_area = MRS_struct.out.vox1.NAA.Area ;
            HP_pre_NAA_fit_error = MRS_struct.out.vox1.NAA.FitError ;
            HP_pre_NAA_FWHM = MRS_struct.out.vox1.NAA.FWHM ;
        else
            HP_pre_water_area = NaN ;
            HP_pre_water_FWHM = NaN ;
            HP_pre_water_fit_error = NaN ;
            HP_pre_GABA_water_fit_error = NaN ;
            HP_pre_NAA_area = MRS_struct.out.vox1.NAA.Area ;
            HP_pre_NAA_fit_error = MRS_struct.out.vox1.NAA.FitError ;
            HP_pre_NAA_FWHM = MRS_struct.out.vox1.NAA.FWHM ;
        end
        
               
    elseif ismissing(GABA_HP_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        HP_pre_water_area = NaN ;
        HP_pre_water_FWHM = NaN ;
        HP_pre_water_fit_error = NaN ;
        HP_pre_GABA_water_fit_error = NaN ;
        HP_pre_NAA_area = NaN ;
        HP_pre_NAA_fit_error = NaN ;
        HP_pre_NAA_FWHM = NaN ;
    end
    
    % Save output variables for HP pre timepoint
    HP_pre_water_area_summary{z,:} = HP_pre_water_area ;
    HP_pre_water_FWHM_summary{z,:} = HP_pre_water_FWHM ;
    HP_pre_water_fit_err_summary{z,:} = HP_pre_water_fit_error ;
    HP_pre_GABA_water_fit_err_summary{z,:} = HP_pre_GABA_water_fit_error ;
    HP_pre_NAA_area_summary{z,:} = HP_pre_NAA_area ;
    HP_pre_NAA_fit_error_summary{z,:} = HP_pre_NAA_fit_error ;
    HP_pre_NAA_FWHM_summary{z,:} = HP_pre_NAA_FWHM ;  
end

% Reformat output cell to numerical array
HP_pre_water_area_summary_array= cell2mat(HP_pre_water_area_summary) ; 
HP_pre_water_FWHM_summary_array = cell2mat(HP_pre_water_FWHM_summary) ;
HP_pre_water_fit_err_summary_array = cell2mat(HP_pre_water_fit_err_summary) ;
HP_pre_GABA_water_fit_err_summary_array = cell2mat(HP_pre_GABA_water_fit_err_summary) ;
HP_pre_NAA_area_summary_array = cell2mat(HP_pre_NAA_area_summary) ;
HP_pre_NAA_fit_error_summary_array = cell2mat(HP_pre_NAA_fit_error_summary);
HP_pre_NAA_FWHM_summary_array = cell2mat(HP_pre_NAA_FWHM_summary);

% Hippocampus post timepoint 

% Initialise summary variables
HP_post_water_area_summary = cell(length(ID),1) ;
HP_post_water_FWHM_summary = cell(length(ID),1) ;
HP_post_water_fit_err_summary = cell(length(ID),1) ;
HP_post_GABA_water_fit_err_summary = cell(length(ID),1) ;   
HP_post_NAA_area_summary = cell(length(ID),1) ;
HP_post_NAA_fit_error_summary = cell(length(ID),1) ;
HP_post_NAA_FWHM_summary = cell(length(ID),1) ;

% for loop across HP post time point across subjects  

for z = 1:length(GABA_HP_post_path)
    
    if ismissing(GABA_HP_post_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for HP post path for each subject
        
        load([GABA_HP_post_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            HP_post_water_area = MRS_struct.out.vox1.water.Area ;
            HP_post_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
            HP_post_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            HP_post_GABA_water_fit_error = MRS_struct.out.vox1.GABA.FitError_W ;
            HP_post_NAA_area = MRS_struct.out.vox1.NAA.Area ;
            HP_post_NAA_fit_error = MRS_struct.out.vox1.NAA.FitError ;
            HP_post_NAA_FWHM = MRS_struct.out.vox1.NAA.FWHM ;
        else
            HP_post_water_area = NaN ;
            HP_post_water_FWHM = NaN ;
            HP_post_water_fit_error = NaN ;
            HP_post_GABA_water_fit_error = NaN ;
            HP_post_NAA_area = MRS_struct.out.vox1.NAA.Area ;
            HP_post_NAA_fit_error = MRS_struct.out.vox1.NAA.FitError ;
            HP_post_NAA_FWHM = MRS_struct.out.vox1.NAA.FWHM ;
        end
              
    elseif ismissing(GABA_HP_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        HP_post_water_area = NaN ;
        HP_post_water_FWHM = NaN ;
        HP_post_water_fit_error = NaN ;
        HP_post_GABA_water_fit_error = NaN ;
        HP_post_NAA_area = NaN ;
        HP_post_NAA_fit_error = NaN ;
        HP_post_NAA_FWHM = NaN ;
    end
    
    % Save output variables for HP post timepoint
    HP_post_water_area_summary{z,:} = HP_post_water_area ;
    HP_post_water_FWHM_summary{z,:} = HP_post_water_FWHM ;
    HP_post_water_fit_err_summary{z,:} = HP_post_water_fit_error ;
    HP_post_GABA_water_fit_err_summary{z,:} = HP_post_GABA_water_fit_error ;
    HP_post_NAA_area_summary{z,:} = HP_post_NAA_area ;
    HP_post_NAA_fit_error_summary{z,:} = HP_post_NAA_fit_error ;
    HP_post_NAA_FWHM_summary{z,:} = HP_post_NAA_FWHM ;
    
end

% Reformat output cell to numerical array
HP_post_water_area_summary_array = cell2mat(HP_post_water_area_summary) ;
HP_post_water_FWHM_summary_array = cell2mat(HP_post_water_FWHM_summary) ;
HP_post_water_fit_err_summary_array = cell2mat(HP_post_water_fit_err_summary) ;
HP_post_GABA_water_fit_err_summary_array = cell2mat(HP_post_GABA_water_fit_err_summary) ;
HP_post_NAA_area_summary_array = cell2mat(HP_post_NAA_area_summary) ;
HP_post_NAA_fit_error_summary_array = cell2mat(HP_post_NAA_fit_error_summary) ; 
HP_post_NAA_FWHM_summary_array = cell2mat(HP_post_NAA_FWHM_summary) ;

%% LEFT PARIETAL CORTEX GABA

% Left parietal pre timepoint

% Initialise summary variables
PTL_pre_water_area_summary = cell(length(ID),1) ;
PTL_pre_water_FWHM_summary = cell(length(ID),1) ;
PTL_pre_water_fit_err_summary = cell(length(ID),1) ;
PTL_pre_GABA_water_fit_err_summary = cell(length(ID),1) ;   

% for loop across PTL pre time point across subjects   

for z = 1:length(GABA_PTL_pre_path)
    
    if ismissing(GABA_PTL_pre_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for PTL pre path for each subject
        
        load([GABA_PTL_pre_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            PTL_pre_water_area = MRS_struct.out.vox1.water.Area ;
            PTL_pre_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
            PTL_pre_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            PTL_pre_GABA_water_fit_error = MRS_struct.out.vox1.GABA.FitError_W ;
        else
            PTL_pre_water_area = NaN ;
            PTL_pre_water_FWHM = NaN ;
            PTL_pre_water_fit_error = NaN ;
            PTL_pre_GABA_water_fit_error = NaN ;
        end
        
                
    elseif ismissing(GABA_PTL_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        PTL_pre_water_area = NaN ;
        PTL_pre_water_FWHM = NaN ;
        PTL_pre_water_fit_error = NaN ;
        PTL_pre_GABA_water_fit_error = NaN ;
    end
    
    % Save output variables for PTL pre timepoint
    PTL_pre_water_area_summary{z,:} = PTL_pre_water_area ;
    PTL_pre_water_FWHM_summary{z,:} = PTL_pre_water_FWHM ;
    PTL_pre_water_fit_err_summary{z,:} = PTL_pre_water_fit_error ;
    PTL_pre_GABA_water_fit_err_summary{z,:} = PTL_pre_GABA_water_fit_error ;
    
end

% Reformat output cell to numerical array
PTL_pre_water_area_summary_array = cell2mat(PTL_pre_water_area_summary) ;
PTL_pre_water_FWHM_summary_array = cell2mat(PTL_pre_water_FWHM_summary) ;
PTL_pre_water_fit_err_summary_array = cell2mat(PTL_pre_water_fit_err_summary) ; 
PTL_pre_GABA_fit_err_summary_array = cell2mat(PTL_pre_GABA_water_fit_err_summary) ;    

% Left parietal cortex post timepoint 

% Initialise summary variables
PTL_post_water_area_summary = cell(length(ID),1) ;
PTL_post_water_FWHM_summary = cell(length(ID),1) ;
PTL_post_water_fit_err_summary = cell(length(ID),1) ;
PTL_post_GABA_water_fit_err_summary = cell(length(ID),1) ;   

% for loop across PTL post time point across subjects 

for z = 1:length(GABA_PTL_post_path)
    
    if ismissing(GABA_PTL_post_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for PTL post path for each subject
        
        load([GABA_PTL_post_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
       if isfield(MRS_struct.out.vox1,'water')
            
            PTL_post_water_area = MRS_struct.out.vox1.water.Area ;
            PTL_post_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
            PTL_post_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            PTL_post_GABA_water_fit_error = MRS_struct.out.vox1.GABA.FitError_W ;
        else
            PTL_post_water_area = NaN ;
            PTL_post_water_FWHM = NaN ;
            PTL_post_water_fit_error = NaN ;
            PTL_post_GABA_water_fit_error = NaN ;
        end
        
                
    elseif ismissing(GABA_PTL_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        PTL_post_water_area = NaN ;
        PTL_post_water_FWHM = NaN ;
        PTL_post_water_fit_error = NaN ;
        PTL_post_GABA_water_fit_error = NaN ;
    end
    
    % Save output variables for PTL post timepoint
    PTL_post_water_area_summary{z,:} = PTL_post_water_area ;
    PTL_post_water_FWHM_summary{z,:} = PTL_post_water_FWHM ;
    PTL_post_water_fit_err_summary{z,:} = PTL_post_water_fit_error ;
    PTL_post_GABA_water_fit_err_summary{z,:} = PTL_post_GABA_water_fit_error ;
    
end

% Reformat output cell to numerical array
PTL_post_water_area_summary_array = cell2mat(PTL_post_water_area_summary) ;
PTL_post_water_FWHM_summary_array = cell2mat(PTL_post_water_FWHM_summary) ;
PTL_post_water_fit_err_summary_array = cell2mat(PTL_post_water_fit_err_summary) ; 
PTL_post_GABA_fit_err_summary_array = cell2mat(PTL_post_GABA_water_fit_err_summary) ;
 
%% SUPPLEMENTARY MOTOR AREA GABA

% SMA pre timepoint

% Initialise summary variables
SMA_pre_water_area_summary = cell(length(ID),1) ;
SMA_pre_water_FWHM_summary = cell(length(ID),1) ;
SMA_pre_water_fit_err_summary = cell(length(ID),1) ;
SMA_pre_GABA_water_fit_err_summary = cell(length(ID),1) ;  

% for loop across SMA pre time point across subjects 

for z = 1:length(GABA_SMA_pre_path)
    
    if ismissing(GABA_SMA_pre_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for SMA pre path for each subject
        
        load([GABA_SMA_pre_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
         if isfield(MRS_struct.out.vox1,'water')
            
            SMA_pre_water_area = MRS_struct.out.vox1.water.Area ;
            SMA_pre_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
            SMA_pre_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            SMA_pre_GABA_water_fit_error = MRS_struct.out.vox1.GABA.FitError_W ;
        else
            SMA_pre_water_area = NaN ;
            SMA_pre_water_FWHM = NaN ;
            SMA_pre_water_fit_error = NaN ;
            SMA_pre_GABA_water_fit_error = NaN ;
        end
        
                
    elseif ismissing(GABA_SMA_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        SMA_pre_water_area = NaN ;
        SMA_pre_water_FWHM = NaN ;
        SMA_pre_water_fit_error = NaN ;
        SMA_pre_GABA_water_fit_error = NaN ;
    end
    
    % Save output variables for SMA pre timepoint
    SMA_pre_water_area_summary{z,:} = SMA_pre_water_area ;
    SMA_pre_water_FWHM_summary{z,:} = SMA_pre_water_FWHM ;
    SMA_pre_water_fit_err_summary{z,:} = SMA_pre_water_fit_error ;
    SMA_pre_GABA_water_fit_err_summary{z,:} = SMA_pre_GABA_water_fit_error ;
    
end

% Reformat output cell to numerical array
SMA_pre_water_area_summary_array = cell2mat(SMA_pre_water_area_summary) ;
SMA_pre_water_FWHM_summary_array = cell2mat(SMA_pre_water_FWHM_summary) ;
SMA_pre_water_fit_err_summary_array = cell2mat(SMA_pre_water_fit_err_summary) ; 
SMA_pre_GABA_fit_err_summary_array = cell2mat(SMA_pre_GABA_water_fit_err_summary) ;

% SMA post timepoint 

% Initialise summary variables
SMA_post_water_area_summary = cell(length(ID),1) ;
SMA_post_water_FWHM_summary = cell(length(ID),1) ;
SMA_post_water_fit_err_summary = cell(length(ID),1) ;
SMA_post_GABA_water_fit_err_summary = cell(length(ID),1) ;  

% for loop across SMA post time point across subjects 

for z = 1:length(GABA_SMA_post_path)
    
    if ismissing(GABA_SMA_post_path(z),'<missing>') == 0 % check that file path exists, if yes, load.
        
        % load Gannet output structure for SMA post path for each subject
        
        load([GABA_SMA_post_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            SMA_post_water_area = MRS_struct.out.vox1.water.Area ;
            SMA_post_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
            SMA_post_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            SMA_post_GABA_water_fit_error = MRS_struct.out.vox1.GABA.FitError_W ;
        else
            SMA_post_water_area = NaN ;
            SMA_post_water_FWHM = NaN ;
            SMA_post_water_fit_error = NaN ;
            SMA_post_GABA_water_fit_error = NaN ;
        end
        
                
    elseif ismissing(GABA_SMA_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        SMA_post_water_area = NaN ;
        SMA_post_water_FWHM = NaN ;
        SMA_post_water_fit_error = NaN ;
        SMA_post_GABA_water_fit_error = NaN ;
    end
    
    % Save output variables for SMA pre timepoint
    SMA_post_water_area_summary{z,:} = SMA_post_water_area ;
    SMA_post_water_FWHM_summary{z,:} = SMA_post_water_FWHM ;
    SMA_post_water_fit_err_summary{z,:} = SMA_post_water_fit_error ;
    SMA_post_GABA_water_fit_err_summary{z,:} = SMA_post_GABA_water_fit_error ;
    
end

% Reformat output cell to numerical array
SMA_post_water_area_summary_array = cell2mat(SMA_post_water_area_summary) ;
SMA_post_water_FWHM_summary_array = cell2mat(SMA_post_water_FWHM_summary) ;
SMA_post_water_fit_err_summary_array = cell2mat(SMA_post_water_fit_err_summary) ; 
SMA_post_GABA_fit_err_summary_array = cell2mat(SMA_post_GABA_water_fit_err_summary) ; 


%% Output tables - GABA uncorrected values & QC metrics  

% QC metrics
QC = table ; 
QC.ID = ID ;
QC.Stim_cond = Data_vox_partial_vol.Stim_cond ;
QC.Stim_cond_num = Data_vox_partial_vol.Stim_cond_num ;
QC.PA_group = Data_vox_partial_vol.PA_group ;
QC.PA_group_number = Data_vox_partial_vol.PA_group_num ;

QC.HP_pre_water_area = HP_pre_water_area_summary_array ; 
QC.HP_pre_water_FWHM = HP_pre_water_FWHM_summary_array ;
QC.HP_pre_water_fit_error = HP_pre_water_fit_err_summary_array ;
QC.HP_pre_GABA_water_fit_error = HP_pre_GABA_water_fit_err_summary_array ;
QC.HP_pre_NAA_area = HP_pre_NAA_area_summary_array ;
QC.HP_pre_NAA_fit_error = HP_pre_NAA_fit_error_summary_array ;
QC.HP_pre_NAA_FWHM = HP_pre_NAA_FWHM_summary_array ;

QC.HP_post_water_area = HP_post_water_area_summary_array ; 
QC.HP_post_water_FWHM = HP_post_water_FWHM_summary_array ;
QC.HP_post_water_fit_error = HP_post_water_fit_err_summary_array ;
QC.HP_post_GABA_water_fit_error = HP_post_GABA_water_fit_err_summary_array ;
QC.HP_post_NAA_area = HP_post_NAA_area_summary_array ;
QC.HP_post_NAA_fit_error = HP_post_NAA_fit_error_summary_array ;
QC.HP_post_NAA_FWHM = HP_post_NAA_FWHM_summary_array ;

QC.PTL_pre_water_area = PTL_pre_water_area_summary_array ;
QC.PTL_post_water_area = PTL_post_water_area_summary_array ;
QC.PTL_pre_water_FWHM = PTL_pre_water_FWHM_summary_array ;
QC.PTL_post_water_FWHM = PTL_post_water_FWHM_summary_array ;
QC.PTL_pre_water_fit_error = PTL_pre_water_fit_err_summary_array ;
QC.PTL_post_water_fit_error = PTL_post_water_fit_err_summary_array ;
QC.PTL_pre_GABA_water_fit_error = PTL_pre_GABA_water_fit_err_summary ;
QC.PTL_post_GABA_water_Fit_error = PTL_post_GABA_water_fit_err_summary ;

QC.SMA_pre_water_area = SMA_pre_water_area_summary_array ;
QC.SMA_post_water_area = SMA_post_water_area_summary_array ;
QC.SMA_pre_water_FWHM = SMA_pre_water_FWHM_summary_array ;
QC.SMA_post_water_FWHM = SMA_post_water_FWHM_summary_array ;
QC.SMA_pre_water_fit_error = SMA_pre_water_fit_err_summary_array ;
QC.SMA_post_water_fit_error = SMA_post_water_fit_err_summary_array ;
QC.SMA_pre_GABA_water_fit_error = SMA_pre_GABA_water_fit_err_summary ;
QC.SMA_post_GABA_Water_Fit_error = SMA_post_GABA_water_fit_err_summary ;
       
%% Save outputs - uncomment to save outputs

save('QC'); % save .mat file
writetable(QC,'QC.txt','Delimiter','\t','WriteRowNames',true) ; % save GABA QC metric table as .txt file
writetable(QC,'QC.xlsx','WriteRowNames',true); % save GABA QC metric table as .xlsx file
movefile('QC.txt',pathIn) ; 
movefile('QC.xlsx',pathIn) ;
