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
addpath(genpath('Volumes/LaCie/Ex_rTMS_study/ex_rtms_code/MRS/volume_correction')) ;

addpath(genpath('Volumes/LaCie_R/Ex_rTMS_study/Data/all_subjects/')) ;

pathIn = '/Volumes/LaCie_R/Ex_rTMS_study/Data/' ;

pathIn_specdata = [pathIn,'all_subjects/'];

ID = {'S3_DJ';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'} ; % all subjects

% ID = {'S44_ID'} % 'S3_DJ';} ; 

% Optional variables for sub-group analysis 

% Denotes subjects who are in active group and inactive group 

% ActiveID = {'S3_DJ';'S5_RD';'S6_KV';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S16_YS';'S17_JTR';'S19_JA';'S20_WO';'S22_NS';'S25_SC';'S27_ANW';'S33_DJG';'S34_ST';'S35_TG';'S36_AY'} ; % subjects from physically active group 

% InactiveID = {'S7_PK';'S13_MD';'S15_AZ';'S18_KF';'S21_KC';'S24_AU';'S26_KW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'} ; % subjects from inactive active group

% Denotes subjects who received rTMS to llpc target or sma target in wk1

% llpcID = {'DJ_03';'RD_05';'SF_09';'JT_10';'MD_13';'AZ_15';'YS_16';'JTR_17';'KF_18';'WO_20';'KC_21';'XK_28';'AR_31';'ST_34';'TG_35';'CR_38';'JC_41';'SA_42';'PL_43'} ; % subjects who received LLPC rTMS
 
% smaID = {'KV_06';'PK_07';'AW_08';'RB_11';'JA_19';'NS_22';'AU_24';'SC_25';'KW_26';'ANW_27';'HZ_29';'PKA_30';'CD_32';'DJG_33';'AY_36';'JT_37';'EH_39';'NU_40';'ID_44'} ; % subjects who received SMA rTMS
 
% PA_group = {'Active';'Inactive'} ; 
 
% timePoint = {'pre';'post'} ; 
 
% voxel = {'hippocampus','parietal','sma'} ; 

%% This cell to import partial volume corrected values from partial_vol_corr.txt 

filename_partial_vol = [pathIn,'Analysis','/','Datasets','/','Partial_vol_corr.csv'] ;

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
HP_pre_GABA_water_summary = cell(length(ID),1) ;
HP_pre_GABA_cr_summary = cell(length(ID),1) ;
HP_pre_GABA_NAA_summary = cell(length(ID),1) ;   
HP_pre_GABA_fit_err_summary = cell(length(ID),1) ;
HP_pre_GABA_SNR_summary = cell(length(ID),1) ;
HP_pre_GABA_FWHM_summary = cell(length(ID),1) ;

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
            
            HP_pre_GABA_water = MRS_struct.out.vox1.GABA.ConcIU ;
            HP_pre_water_area = MRS_struct.out.vox1.water.Area ;
            HP_pre_water_SNR  = MRS_struct.out.vox1.water.SNR ;
            HP_pre_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            HP_pre_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
        else
            HP_pre_GABA_water = NaN ;
            HP_pre_water_area = NaN ;
            HP_pre_water_SNR  = NaN ;
            HP_pre_water_fit_error = NaN ;
            HP_pre_water_FWHM = NaN ;
        end
        
        % save concentration estimates 
        HP_pre_GABA_Cr = MRS_struct.out.vox1.GABA.ConcCr ;
        HP_pre_GABA_NAA = MRS_struct.out.vox1.GABA.ConcNAA ;
        
        % save data QC estimates 
        HP_pre_GABA_fit_err = MRS_struct.out.vox1.GABA.FitError ; 
        HP_pre_GABA_SNR = MRS_struct.out.vox1.GABA.SNR ;
        HP_pre_GABA_FWHM = MRS_struct.out.vox1.GABA.FWHM ;
        
    elseif ismissing(GABA_HP_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        HP_pre_GABA_water = NaN ;
        HP_pre_GABA_Cr = NaN ; 
        HP_pre_GABA_NAA = NaN ; 
        
        HP_pre_water_area = NaN ;
        HP_pre_water_SNR  = NaN ;
        HP_pre_water_fit_error = NaN ;
        HP_pre_water_FWHM = NaN ;
        
        HP_pre_GABA_fit_err = NaN ;
        HP_pre_GABA_SNR = NaN ;
        HP_pre_GABA_FWHM = NaN ;
    end
    
    % Save output variables for HP pre timepoint
    
    % Save GABA concentrations referenced to water, Cr, and NAA as cell &
    % array 
    HP_pre_GABA_water_summary{z,:} = HP_pre_GABA_water ;
    HP_pre_GABA_cr_summary{z,:} =  HP_pre_GABA_Cr ;
    HP_pre_GABA_NAA_summary{z,:} = HP_pre_GABA_NAA ;
  
    % Save data quality metrics for HP pre GABA as cell & array
    HP_pre_GABA_fit_err_summary{z,:} = HP_pre_GABA_fit_err ; 
    HP_pre_GABA_SNR_summary{z,:} = HP_pre_GABA_SNR ;
    HP_pre_GABA_FWHM_summary{z,:} = HP_pre_GABA_FWHM ;
    
end

% Reformat output cell to numerical array
HP_pre_GABA_water_summary_array = cell2mat(HP_pre_GABA_water_summary) ;
HP_pre_GABA_cr_summary_array = cell2mat(HP_pre_GABA_cr_summary) ;
HP_pre_GABA_NAA_summary_array = cell2mat(HP_pre_GABA_NAA_summary) ; 
HP_pre_GABA_fit_err_summary_array = cell2mat(HP_pre_GABA_fit_err_summary) ;    
HP_pre_GABA_SNR_summary_array = cell2mat(HP_pre_GABA_SNR_summary) ; 
HP_pre_GABA_FWHM_summary_array = cell2mat(HP_pre_GABA_FWHM_summary) ; 

% % Output HP pre concentrations & data quality metrics 
% HP_pre_GABA_conc = [HP_pre_GABA_water_summary_array, HP_pre_GABA_cr_summary_array, HP_pre_GABA_NAA_summary_array] ;
% HP_pre_GABA_data_QC = [HP_pre_GABA_fit_err_summary_array, HP_pre_GABA_SNR_summary_array, HP_pre_GABA_FWHM_summary_array] ; 

% Hippocampus post timepoint 

% Initialise summary variables
HP_post_GABA_water_summary = cell(length(ID),1) ;
HP_post_GABA_cr_summary = cell(length(ID),1) ;
HP_post_GABA_NAA_summary = cell(length(ID),1) ;   
HP_post_GABA_fit_err_summary = cell(length(ID),1) ;
HP_post_GABA_SNR_summary = cell(length(ID),1) ;
HP_post_GABA_FWHM_summary = cell(length(ID),1) ;

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
            
            HP_post_GABA_water = MRS_struct.out.vox1.GABA.ConcIU ;
            HP_post_water_area = MRS_struct.out.vox1.water.Area ;
            HP_post_water_SNR  = MRS_struct.out.vox1.water.SNR ;
            HP_post_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            HP_post_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
        else
            HP_post_GABA_water = NaN ;
            HP_post_water_area = NaN ;
            HP_post_water_SNR  = NaN ;
            HP_post_water_fit_error = NaN ;
            HP_post_water_FWHM = NaN ;
        end
        
        % save concentration estimates 
        HP_post_GABA_Cr = MRS_struct.out.vox1.GABA.ConcCr ;
        HP_post_GABA_NAA = MRS_struct.out.vox1.GABA.ConcNAA ;
        
        % save data QC estimates 
        HP_post_GABA_fit_err = MRS_struct.out.vox1.GABA.FitError ; 
        HP_post_GABA_SNR = MRS_struct.out.vox1.GABA.SNR ;
        HP_post_GABA_FWHM = MRS_struct.out.vox1.GABA.FWHM ;
        
    elseif ismissing(GABA_HP_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        HP_post_GABA_water = NaN ;
        HP_post_GABA_Cr = NaN ; 
        HP_post_GABA_NAA = NaN ; 
        
        HP_post_water_area = NaN ;
        HP_post_water_SNR  = NaN ;
        HP_post_water_fit_error = NaN ;
        HP_post_water_FWHM = NaN ;
        
        HP_post_GABA_fit_err = NaN ;
        HP_post_GABA_SNR = NaN ;
        HP_post_GABA_FWHM = NaN ;
    end
    
    % Save output variables for HP post timepoint
    
    % Save GABA concentrations referenced to water, Cr, and NAA as cell &
    % array 
    HP_post_GABA_water_summary{z,:} = HP_post_GABA_water ;
    HP_post_GABA_cr_summary{z,:} =  HP_post_GABA_Cr ;
    HP_post_GABA_NAA_summary{z,:} = HP_post_GABA_NAA ;
  
    % Save data quality metrics for HP post GABA as cell & array
    HP_post_GABA_fit_err_summary{z,:} = HP_post_GABA_fit_err ; 
    HP_post_GABA_SNR_summary{z,:} = HP_post_GABA_SNR ;
    HP_post_GABA_FWHM_summary{z,:} = HP_post_GABA_FWHM ;
    
end

% Reformat output cell to numerical array
HP_post_GABA_water_summary_array = cell2mat(HP_post_GABA_water_summary) ;
HP_post_GABA_cr_summary_array = cell2mat(HP_post_GABA_cr_summary) ;
HP_post_GABA_NAA_summary_array = cell2mat(HP_post_GABA_NAA_summary) ; 
HP_post_GABA_fit_err_summary_array = cell2mat(HP_post_GABA_fit_err_summary) ;    
HP_post_GABA_SNR_summary_array = cell2mat(HP_post_GABA_SNR_summary) ; 
HP_post_GABA_FWHM_summary_array = cell2mat(HP_post_GABA_FWHM_summary) ; 

% Output HP post concentrations & data quality metrics 

% HP_post_GABA_conc = [HP_post_GABA_water_summary_array, HP_post_GABA_cr_summary_array, HP_post_GABA_NAA_summary_array] ;
% HP_post_GABA_data_QC = [HP_post_GABA_fit_err_summary_array, HP_post_GABA_SNR_summary_array, HP_post_GABA_FWHM_summary_array] ; 

%===================== HP pre & post summary =================%

HP_pre_post_GABA_water = [HP_pre_GABA_water_summary_array,HP_post_GABA_water_summary_array] ;
HP_pre_post_GABA_cr = [HP_pre_GABA_cr_summary_array,HP_post_GABA_cr_summary_array] ; 
HP_pre_post_GABA_NAA = [HP_pre_GABA_NAA_summary_array,HP_post_GABA_NAA_summary_array] ;


%% LEFT PARIETAL CORTEX GABA

% Left parietal pre timepoint

% Initialise summary variables
PTL_pre_GABA_water_summary = cell(length(ID),1) ;
PTL_pre_GABA_cr_summary = cell(length(ID),1) ;
PTL_pre_GABA_NAA_summary = cell(length(ID),1) ;   
PTL_pre_GABA_fit_err_summary = cell(length(ID),1) ;
PTL_pre_GABA_SNR_summary = cell(length(ID),1) ;
PTL_pre_GABA_FWHM_summary = cell(length(ID),1) ;

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
            
            PTL_pre_GABA_water = MRS_struct.out.vox1.GABA.ConcIU ;
            PTL_pre_water_area = MRS_struct.out.vox1.water.Area ;
            PTL_pre_water_SNR  = MRS_struct.out.vox1.water.SNR ;
            PTL_pre_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            PTL_pre_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
        else
            PTL_pre_GABA_water = NaN ;
            PTL_pre_water_area = NaN ;
            PTL_pre_water_SNR  = NaN ;
            PTL_pre_water_fit_error = NaN ;
            PTL_pre_water_FWHM = NaN ;
        end
        
        % save concentration estimates 
        PTL_pre_GABA_Cr = MRS_struct.out.vox1.GABA.ConcCr ;
        PTL_pre_GABA_NAA = MRS_struct.out.vox1.GABA.ConcNAA ;
        
        % save data QC estimates 
        PTL_pre_GABA_fit_err = MRS_struct.out.vox1.GABA.FitError ; 
        PTL_pre_GABA_SNR = MRS_struct.out.vox1.GABA.SNR ;
        PTL_pre_GABA_FWHM = MRS_struct.out.vox1.GABA.FWHM ;
        
    elseif ismissing(GABA_PTL_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        PTL_pre_GABA_water = NaN ;
        PTL_pre_GABA_Cr = NaN ; 
        PTL_pre_GABA_NAA = NaN ; 
        
        PTL_pre_water_area = NaN ;
        PTL_pre_water_SNR  = NaN ;
        PTL_pre_water_fit_error = NaN ;
        PTL_pre_water_FWHM = NaN ;
        
        PTL_pre_GABA_fit_err = NaN ;
        PTL_pre_GABA_SNR = NaN ;
        PTL_pre_GABA_FWHM = NaN ;
    end
    
    % Save output variables for PTL pre timepoint
    
    % Save GABA concentrations referenced to water, Cr, and NAA as cell &
    % array 
    PTL_pre_GABA_water_summary{z,:} = PTL_pre_GABA_water ;
    PTL_pre_GABA_cr_summary{z,:} =  PTL_pre_GABA_Cr ;
    PTL_pre_GABA_NAA_summary{z,:} = PTL_pre_GABA_NAA ;
  
    % Save data quality metrics for PTL pre GABA as cell & array
    PTL_pre_GABA_fit_err_summary{z,:} = PTL_pre_GABA_fit_err ; 
    PTL_pre_GABA_SNR_summary{z,:} = PTL_pre_GABA_SNR ;
    PTL_pre_GABA_FWHM_summary{z,:} = PTL_pre_GABA_FWHM ; 
    
end

% Reformat output cell to numerical array
PTL_pre_GABA_water_summary_array = cell2mat(PTL_pre_GABA_water_summary) ;
PTL_pre_GABA_cr_summary_array = cell2mat(PTL_pre_GABA_cr_summary) ;
PTL_pre_GABA_NAA_summary_array = cell2mat(PTL_pre_GABA_NAA_summary) ; 
PTL_pre_GABA_fit_err_summary_array = cell2mat(PTL_pre_GABA_fit_err_summary) ;    
PTL_pre_GABA_SNR_summary_array = cell2mat(PTL_pre_GABA_SNR_summary) ; 
PTL_pre_GABA_FWHM_summary_array = cell2mat(PTL_pre_GABA_FWHM_summary) ; 

% % Output PTL pre concentrations & data quality metrics 
% PTL_pre_GABA_conc = [PTL_pre_GABA_water_summary_array, PTL_pre_GABA_cr_summary_array, PTL_pre_GABA_NAA_summary_array] ;
% PTL_pre_GABA_data_QC = [PTL_pre_GABA_fit_err_summary_array, PTL_pre_GABA_SNR_summary_array, PTL_pre_GABA_FWHM_summary_array] ; 

% Left parietal cortex post timepoint 

% Initialise summary variables
PTL_post_GABA_water_summary = cell(length(ID),1) ;
PTL_post_GABA_cr_summary = cell(length(ID),1) ;
PTL_post_GABA_NAA_summary = cell(length(ID),1) ;   
PTL_post_GABA_fit_err_summary = cell(length(ID),1) ;
PTL_post_GABA_SNR_summary = cell(length(ID),1) ;
PTL_post_GABA_FWHM_summary = cell(length(ID),1) ;

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
            
            PTL_post_GABA_water = MRS_struct.out.vox1.GABA.ConcIU ;
            PTL_post_water_area = MRS_struct.out.vox1.water.Area ;
            PTL_post_water_SNR  = MRS_struct.out.vox1.water.SNR ;
            PTL_post_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            PTL_post_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
        else
            PTL_post_GABA_water = NaN ;
            PTL_post_water_area = NaN ;
            PTL_post_water_SNR  = NaN ;
            PTL_post_water_fit_error = NaN ;
            PTL_post_water_FWHM = NaN ;
        end
        
        % save concentration estimates 
        PTL_post_GABA_Cr = MRS_struct.out.vox1.GABA.ConcCr ;
        PTL_post_GABA_NAA = MRS_struct.out.vox1.GABA.ConcNAA ;
        
        % save data QC estimates 
        PTL_post_GABA_fit_err = MRS_struct.out.vox1.GABA.FitError ; 
        PTL_post_GABA_SNR = MRS_struct.out.vox1.GABA.SNR ;
        PTL_post_GABA_FWHM = MRS_struct.out.vox1.GABA.FWHM ;
        
    elseif ismissing(GABA_PTL_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        PTL_post_GABA_water = NaN ;
        PTL_post_GABA_Cr = NaN ; 
        PTL_post_GABA_NAA = NaN ; 
        
        PTL_post_water_area = NaN ;
        PTL_post_water_SNR  = NaN ;
        PTL_post_water_fit_error = NaN ;
        PTL_post_water_FWHM = NaN ;
        
        PTL_post_GABA_fit_err = NaN ;
        PTL_post_GABA_SNR = NaN ;
        PTL_post_GABA_FWHM = NaN ;
    end
    
    % Save output variables for PTL post timepoint
    
    % Save GABA concentrations referenced to water, Cr, and NAA as cell &
    % array 
    PTL_post_GABA_water_summary{z,:} = PTL_post_GABA_water ;
    PTL_post_GABA_cr_summary{z,:} =  PTL_post_GABA_Cr ;
    PTL_post_GABA_NAA_summary{z,:} = PTL_post_GABA_NAA ;
  
    % Save data quality metrics for PTL post GABA as cell & array
    PTL_post_GABA_fit_err_summary{z,:} = PTL_post_GABA_fit_err ; 
    PTL_post_GABA_SNR_summary{z,:} = PTL_post_GABA_SNR ;
    PTL_post_GABA_FWHM_summary{z,:} = PTL_post_GABA_FWHM ; 
end

% Reformat output cell to numerical array
PTL_post_GABA_water_summary_array = cell2mat(PTL_post_GABA_water_summary) ;
PTL_post_GABA_cr_summary_array = cell2mat(PTL_post_GABA_cr_summary) ;
PTL_post_GABA_NAA_summary_array = cell2mat(PTL_post_GABA_NAA_summary) ; 
PTL_post_GABA_fit_err_summary_array = cell2mat(PTL_post_GABA_fit_err_summary) ;    
PTL_post_GABA_SNR_summary_array = cell2mat(PTL_post_GABA_SNR_summary) ; 
PTL_post_GABA_FWHM_summary_array = cell2mat(PTL_post_GABA_FWHM_summary) ; 

% Output PTL post concentrations & data quality metrics 

% PTL_post_GABA_conc = [PTL_post_GABA_water_summary_array, PTL_post_GABA_cr_summary_array, PTL_post_GABA_NAA_summary_array] ;
% PTL_post_GABA_data_QC = [PTL_post_GABA_fit_err_summary_array, PTL_post_GABA_SNR_summary_array, PTL_post_GABA_FWHM_summary_array] ; 
 
% %===================== PTL pre & post summary =================%

PTL_pre_post_GABA_water = [PTL_pre_GABA_water_summary_array,PTL_post_GABA_water_summary_array] ;
PTL_pre_post_GABA_cr = [PTL_pre_GABA_cr_summary_array,PTL_post_GABA_cr_summary_array] ; 
PTL_pre_post_GABA_NAA = [PTL_pre_GABA_NAA_summary_array,PTL_post_GABA_NAA_summary_array] ;

%% SUPPLEMENTARY MOTOR AREA GABA

% SMA pre timepoint

% Initialise summary variables
SMA_pre_GABA_water_summary = cell(length(ID),1) ;
SMA_pre_GABA_cr_summary = cell(length(ID),1) ;
SMA_pre_GABA_NAA_summary = cell(length(ID),1) ;   
SMA_pre_GABA_fit_err_summary = cell(length(ID),1) ;
SMA_pre_GABA_SNR_summary = cell(length(ID),1) ;
SMA_pre_GABA_FWHM_summary = cell(length(ID),1) ;

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
            
            SMA_pre_GABA_water = MRS_struct.out.vox1.GABA.ConcIU ;
            SMA_pre_water_area = MRS_struct.out.vox1.water.Area ;
            SMA_pre_water_SNR  = MRS_struct.out.vox1.water.SNR ;
            SMA_pre_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            SMA_pre_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
        else
            SMA_pre_GABA_water = NaN ;
            SMA_pre_water_area = NaN ;
            SMA_pre_water_SNR  = NaN ;
            SMA_pre_water_fit_error = NaN ;
            SMA_pre_water_FWHM = NaN ;
        end
        
        % save concentration estimates 
        SMA_pre_GABA_Cr = MRS_struct.out.vox1.GABA.ConcCr ;
        SMA_pre_GABA_NAA = MRS_struct.out.vox1.GABA.ConcNAA ;
        
        % save data QC estimates 
        SMA_pre_GABA_fit_err = MRS_struct.out.vox1.GABA.FitError ; 
        SMA_pre_GABA_SNR = MRS_struct.out.vox1.GABA.SNR ;
        SMA_pre_GABA_FWHM = MRS_struct.out.vox1.GABA.FWHM ;
        
    elseif ismissing(GABA_SMA_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        SMA_pre_GABA_water = NaN ;
        SMA_pre_GABA_Cr = NaN ; 
        SMA_pre_GABA_NAA = NaN ; 
        
        SMA_pre_water_area = NaN ;
        SMA_pre_water_SNR  = NaN ;
        SMA_pre_water_fit_error = NaN ;
        SMA_pre_water_FWHM = NaN ;
        
        SMA_pre_GABA_fit_err = NaN ;
        SMA_pre_GABA_SNR = NaN ;
        SMA_pre_GABA_FWHM = NaN ;
    end
    
    % Save output variables for SMA pre timepoint
    
    % Save GABA concentrations referenced to water, Cr, and NAA as cell &
    % array 
    SMA_pre_GABA_water_summary{z,:} = SMA_pre_GABA_water ;
    SMA_pre_GABA_cr_summary{z,:} =  SMA_pre_GABA_Cr ;
    SMA_pre_GABA_NAA_summary{z,:} = SMA_pre_GABA_NAA ;
  
    % Save data quality metrics for SMA pre GABA as cell & array
    SMA_pre_GABA_fit_err_summary{z,:} = SMA_pre_GABA_fit_err ; 
    SMA_pre_GABA_SNR_summary{z,:} = SMA_pre_GABA_SNR ;
    SMA_pre_GABA_FWHM_summary{z,:} = SMA_pre_GABA_FWHM ; 
    
end

% Reformat output cell to numerical array
SMA_pre_GABA_water_summary_array = cell2mat(SMA_pre_GABA_water_summary) ;
SMA_pre_GABA_cr_summary_array = cell2mat(SMA_pre_GABA_cr_summary) ;
SMA_pre_GABA_NAA_summary_array = cell2mat(SMA_pre_GABA_NAA_summary) ; 
SMA_pre_GABA_fit_err_summary_array = cell2mat(SMA_pre_GABA_fit_err_summary) ;    
SMA_pre_GABA_SNR_summary_array = cell2mat(SMA_pre_GABA_SNR_summary) ; 
SMA_pre_GABA_FWHM_summary_array = cell2mat(SMA_pre_GABA_FWHM_summary) ; 

% % Output SMA pre concentrations & data quality metrics 
% SMA_pre_GABA_conc = [SMA_pre_GABA_water_summary_array, SMA_pre_GABA_cr_summary_array, SMA_pre_GABA_NAA_summary_array] ;
% SMA_pre_GABA_data_QC = [SMA_pre_GABA_fit_err_summary_array, SMA_pre_GABA_SNR_summary_array, SMA_pre_GABA_FWHM_summary_array] ; 

% SMA post timepoint 

% Initialise summary variables
SMA_post_GABA_water_summary = cell(length(ID),1) ;
SMA_post_GABA_cr_summary = cell(length(ID),1) ;
SMA_post_GABA_NAA_summary = cell(length(ID),1) ;   
SMA_post_GABA_fit_err_summary = cell(length(ID),1) ;
SMA_post_GABA_SNR_summary = cell(length(ID),1) ;
SMA_post_GABA_FWHM_summary = cell(length(ID),1) ;

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
            
            SMA_post_GABA_water = MRS_struct.out.vox1.GABA.ConcIU ;
            SMA_post_water_area = MRS_struct.out.vox1.water.Area ;
            SMA_post_water_SNR  = MRS_struct.out.vox1.water.SNR ;
            SMA_post_water_fit_error = MRS_struct.out.vox1.water.FitError ;
            SMA_post_water_FWHM = MRS_struct.out.vox1.water.FWHM ;
        else
            SMA_post_GABA_water = NaN ;
            SMA_post_water_area = NaN ;
            SMA_post_water_SNR  = NaN ;
            SMA_post_water_fit_error = NaN ;
            SMA_post_water_FWHM = NaN ;
        end
        
        % save concentration estimates
        SMA_post_GABA_Cr = MRS_struct.out.vox1.GABA.ConcCr ;
        SMA_post_GABA_NAA = MRS_struct.out.vox1.GABA.ConcNAA ;
        
        % save data QC estimates
        SMA_post_GABA_fit_err = MRS_struct.out.vox1.GABA.FitError ;
        SMA_post_GABA_SNR = MRS_struct.out.vox1.GABA.SNR ;
        SMA_post_GABA_FWHM = MRS_struct.out.vox1.GABA.FWHM ;
        
    elseif ismissing(GABA_SMA_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        SMA_post_GABA_water = NaN ;
        SMA_post_GABA_Cr = NaN ;
        SMA_post_GABA_NAA = NaN ;
        
        SMA_post_water_area = NaN ;
        SMA_post_water_SNR  = NaN ;
        SMA_post_water_fit_error = NaN ;
        SMA_post_water_FWHM = NaN ;
        
        SMA_post_GABA_fit_err = NaN ;
        SMA_post_GABA_SNR = NaN ;
        SMA_post_GABA_FWHM = NaN ;
    end
    
    % Save output variables for SMA post timepoint
    
    % Save GABA concentrations referenced to water, Cr, and NAA as cell &
    % array
    SMA_post_GABA_water_summary{z,:} = SMA_post_GABA_water ;
    SMA_post_GABA_cr_summary{z,:} =  SMA_post_GABA_Cr ;
    SMA_post_GABA_NAA_summary{z,:} = SMA_post_GABA_NAA ;
    
    % Save data quality metrics for SMA post GABA as cell & array
    SMA_post_GABA_fit_err_summary{z,:} = SMA_post_GABA_fit_err ;
    SMA_post_GABA_SNR_summary{z,:} = SMA_post_GABA_SNR ;
    SMA_post_GABA_FWHM_summary{z,:} = SMA_post_GABA_FWHM ;
    
end

% Reformat output cell to numerical array
SMA_post_GABA_water_summary_array = cell2mat(SMA_post_GABA_water_summary) ;
SMA_post_GABA_cr_summary_array = cell2mat(SMA_post_GABA_cr_summary) ;
SMA_post_GABA_NAA_summary_array = cell2mat(SMA_post_GABA_NAA_summary) ; 
SMA_post_GABA_fit_err_summary_array = cell2mat(SMA_post_GABA_fit_err_summary) ;    
SMA_post_GABA_SNR_summary_array = cell2mat(SMA_post_GABA_SNR_summary) ; 
SMA_post_GABA_FWHM_summary_array = cell2mat(SMA_post_GABA_FWHM_summary) ;

% Output SMA post concentrations & data quality metrics 

% SMA_post_GABA_conc = [SMA_post_GABA_water_summary_array, SMA_post_GABA_cr_summary_array, SMA_post_GABA_NAA_summary_array] ;
% SMA_post_GABA_data_QC = [SMA_post_GABA_fit_err_summary_array, SMA_post_GABA_SNR_summary_array, SMA_post_GABA_FWHM_summary_array] ; 

%===================== SMA pre & post summary =================%

SMA_pre_post_GABA_water = [SMA_pre_GABA_water_summary_array,SMA_post_GABA_water_summary_array] ;
SMA_pre_post_GABA_cr = [SMA_pre_GABA_cr_summary_array,SMA_post_GABA_cr_summary_array] ; 
SMA_pre_post_GABA_NAA = [SMA_pre_GABA_NAA_summary_array,SMA_post_GABA_NAA_summary_array] ;

%% Output tables - GABA uncorrected values & QC metrics  

% Output table containing pre, post
% uncorr values for each subject for each voxel location. Ind. columns for
% water referenced, cr referenced, and NAA referenced metab conc. 

%Uncorrected concentration values
uncorr_output_GABA = table ; 
uncorr_output_GABA.ID = ID ;
uncorr_output_GABA.Stim_cond = Data_vox_partial_vol.Stim_cond ;
uncorr_output_GABA.Stim_cond_num = Data_vox_partial_vol.Stim_cond_num ;
uncorr_output_GABA.PA_group = Data_vox_partial_vol.PA_group ;
uncorr_output_GABA.PA_group_number = Data_vox_partial_vol.PA_group_num ;

uncorr_output_GABA.HP_pre_GABA_water = HP_pre_GABA_water_summary_array ; 
uncorr_output_GABA.HP_post_GABA_water = HP_post_GABA_water_summary_array ; 
uncorr_output_GABA.HP_pre_GABA_cr = HP_pre_GABA_cr_summary_array ;
uncorr_output_GABA.HP_post_GABA_cr = HP_post_GABA_cr_summary_array ; 
uncorr_output_GABA.HP_pre_GABA_NAA = HP_pre_GABA_NAA_summary_array ; 
uncorr_output_GABA.HP_post_GABA_NAA = HP_post_GABA_NAA_summary_array ;

uncorr_output_GABA.PTL_pre_GABA_water = PTL_pre_GABA_water_summary_array ; 
uncorr_output_GABA.PTL_post_GABA_water = PTL_post_GABA_water_summary_array ; 
uncorr_output_GABA.PTL_pre_GABA_cr = PTL_pre_GABA_cr_summary_array ;
uncorr_output_GABA.PTL_post_GABA_cr = PTL_post_GABA_cr_summary_array ; 
uncorr_output_GABA.PTL_pre_GABA_NAA = PTL_pre_GABA_NAA_summary_array ; 
uncorr_output_GABA.PTL_post_GABA_NAA = PTL_post_GABA_NAA_summary_array ;

uncorr_output_GABA.SMA_pre_GABA_water = SMA_pre_GABA_water_summary_array ; 
uncorr_output_GABA.SMA_post_GABA_water = SMA_post_GABA_water_summary_array ; 
uncorr_output_GABA.SMA_pre_GABA_cr = SMA_pre_GABA_cr_summary_array ;
uncorr_output_GABA.SMA_post_GABA_cr = SMA_post_GABA_cr_summary_array ; 
uncorr_output_GABA.SMA_pre_GABA_NAA = SMA_pre_GABA_NAA_summary_array ; 
uncorr_output_GABA.SMA_post_GABA_NAA = SMA_post_GABA_NAA_summary_array ;

% QC metrics
GABA_QC = table ; 
GABA_QC.ID = ID ;
GABA_QC.Stim_cond = Data_vox_partial_vol.Stim_cond ;
GABA_QC.Stim_cond_num = Data_vox_partial_vol.Stim_cond_num ;
GABA_QC.PA_group = Data_vox_partial_vol.PA_group ;
GABA_QC.PA_group_number = Data_vox_partial_vol.PA_group_num ;

GABA_QC.HP_pre_fit_err = HP_pre_GABA_fit_err_summary_array ; 
GABA_QC.HP_post_fit_err = HP_post_GABA_fit_err_summary_array ;
GABA_QC.HP_pre_SNR = HP_pre_GABA_SNR_summary_array ;
GABA_QC.HP_post_SNR = HP_post_GABA_SNR_summary_array ; 
GABA_QC.HP_pre_FWHM = HP_pre_GABA_FWHM_summary_array ;
GABA_QC.HP_post_FWHM = HP_post_GABA_FWHM_summary_array ;

GABA_QC.PTL_pre_fit_err = PTL_pre_GABA_fit_err_summary_array ; 
GABA_QC.PTL_post_fit_err = PTL_post_GABA_fit_err_summary_array ;
GABA_QC.PTL_pre_SNR = PTL_pre_GABA_SNR_summary_array ;
GABA_QC.PTL_post_SNR = PTL_post_GABA_SNR_summary_array ; 
GABA_QC.PTL_pre_FWHM = PTL_pre_GABA_FWHM_summary_array ;
GABA_QC.PTL_post_FWHM = PTL_post_GABA_FWHM_summary_array ;

GABA_QC.SMA_pre_fit_err = SMA_pre_GABA_fit_err_summary_array ; 
GABA_QC.SMA_post_fit_err = SMA_post_GABA_fit_err_summary_array ;
GABA_QC.SMA_pre_SNR = SMA_pre_GABA_SNR_summary_array ;
GABA_QC.SMA_post_SNR = SMA_post_GABA_SNR_summary_array ; 
GABA_QC.SMA_pre_FWHM = SMA_pre_GABA_FWHM_summary_array ;
GABA_QC.SMA_post_FWHM = SMA_post_GABA_FWHM_summary_array ;

% save QC table 

%% Input estimated GABA/water (uncorrected) values for subjects w.o water twix file

% These values were generated by calculating TARQUIN water estimates using
% rda2 (off file) and then calculated relative to known GANNET values. 
% i.e. 1. (GannetPreWater_missing / TarquinPreWater) = GannetPostWater_known /
% TarquinPostWater); 2. GABAabsoluteConc / estimated_water * K constant

% Insert into uncorrected output tables 

%S3_DJ missing pre water TWIX 
S3_DJ_HP_GABA_water_pre = 3.8689 ;
uncorr_output_GABA.HP_pre_GABA_water(1,1) = S3_DJ_HP_GABA_water_pre ; 

S3_DJ_PTL_GABA_water_pre = 3.2630 ;
uncorr_output_GABA.PTL_pre_GABA_water(1,1) = S3_DJ_PTL_GABA_water_pre ;

S3_DJ_SMA_GABA_water_pre = 2.6750 ;
uncorr_output_GABA.SMA_pre_GABA_water(1,1) = S3_DJ_SMA_GABA_water_pre ;

%S5_DJ missing pre water TWIX 
S5_RD_HP_GABA_water_pre = 2.2600 ;
uncorr_output_GABA.HP_pre_GABA_water(2,1) = S5_RD_HP_GABA_water_pre ;

S5_RD_PTL_GABA_water_pre = 1.7181 ;
uncorr_output_GABA.PTL_pre_GABA_water(2,1) = S5_RD_PTL_GABA_water_pre ;

S5_RD_SMA_GABA_water_pre = 2.3534 ;
uncorr_output_GABA.SMA_pre_GABA_water(2,1) = S5_RD_SMA_GABA_water_pre ;

%S31_AR missing all post TWIX
S31_AR_HP_GABA_water_post = 0.9788 ; 
uncorr_output_GABA.HP_post_GABA_water(25,1) = S31_AR_HP_GABA_water_post ;

S31_AR_PTL_GABA_water_post = 3.1040 ;
uncorr_output_GABA.PTL_post_GABA_water(25,1) = S31_AR_PTL_GABA_water_post ;

S31_AR_SMA_GABA_water_post = 9.7554 ;
uncorr_output_GABA.SMA_post_GABA_water(25,1) = S31_AR_SMA_GABA_water_post ; 

S31_AR_HP_GABA_cr_post = 0.0258 ;
uncorr_output_GABA.HP_post_GABA_cr(25,1) = S31_AR_HP_GABA_cr_post ; 

S31_AR_PTL_GABA_cr_post =  0.0910 ;
uncorr_output_GABA.PTL_post_GABA_cr(25,1) = S31_AR_PTL_GABA_cr_post ;

S31_AR_SMA_GABA_cr_post = 0.3677 ;
uncorr_output_GABA.SMA_post_GABA_cr(25,1) = S31_AR_SMA_GABA_cr_post ;

%% Partial volume corrected GABA (metabolite / (1 - CSF proportion) 

% Partial volume corrected GABA concentration values
corr_output_GABA = table ; 
corr_output_GABA.ID = ID ;
corr_output_GABA.Stim_cond = Data_vox_partial_vol.Stim_cond ;
corr_output_GABA.Stim_cond_num = Data_vox_partial_vol.Stim_cond_num ;
corr_output_GABA.PA_group = Data_vox_partial_vol.PA_group ;
corr_output_GABA.PA_group_number = Data_vox_partial_vol.PA_group_num ;

corr_output_GABA.HP_pre_GABA_water = uncorr_output_GABA.HP_pre_GABA_water ./ (1 - Data_vox_partial_vol.HP_pre_CSF_prop) ;
corr_output_GABA.HP_post_GABA_water = uncorr_output_GABA.HP_post_GABA_water ./ (1 - Data_vox_partial_vol.HP_post_CSF_prop) ; 
corr_output_GABA.HP_pre_GABA_cr = uncorr_output_GABA.HP_pre_GABA_cr ./ (1 - Data_vox_partial_vol.HP_pre_CSF_prop) ;
corr_output_GABA.HP_post_GABA_cr = uncorr_output_GABA.HP_post_GABA_cr ./ (1 - Data_vox_partial_vol.HP_post_CSF_prop) ; 
corr_output_GABA.HP_pre_GABA_NAA = uncorr_output_GABA.HP_pre_GABA_NAA ./ (1 - Data_vox_partial_vol.HP_pre_CSF_prop) ;
corr_output_GABA.HP_post_GABA_NAA = uncorr_output_GABA.HP_post_GABA_NAA ./ (1 - Data_vox_partial_vol.HP_post_CSF_prop) ; 

corr_output_GABA.PTL_pre_GABA_water = uncorr_output_GABA.PTL_pre_GABA_water ./ (1 - Data_vox_partial_vol.PTL_pre_CSF_prop) ; 
corr_output_GABA.PTL_post_GABA_water = uncorr_output_GABA.PTL_post_GABA_water ./ (1 - Data_vox_partial_vol.PTL_post_CSF_prop) ; 
corr_output_GABA.PTL_pre_GABA_cr = uncorr_output_GABA.PTL_pre_GABA_cr ./ (1 - Data_vox_partial_vol.PTL_pre_CSF_prop) ; 
corr_output_GABA.PTL_post_GABA_cr = uncorr_output_GABA.PTL_post_GABA_cr ./ (1 - Data_vox_partial_vol.PTL_post_CSF_prop) ; 
corr_output_GABA.PTL_pre_GABA_NAA = uncorr_output_GABA.PTL_pre_GABA_NAA ./ (1 - Data_vox_partial_vol.PTL_pre_CSF_prop) ; 
corr_output_GABA.PTL_post_GABA_NAA = uncorr_output_GABA.PTL_post_GABA_NAA ./ (1 - Data_vox_partial_vol.PTL_post_CSF_prop) ;

corr_output_GABA.SMA_pre_GABA_water = uncorr_output_GABA.SMA_pre_GABA_water ./ (1 - Data_vox_partial_vol.SMA_pre_CSF_prop) ; 
corr_output_GABA.SMA_post_GABA_water = uncorr_output_GABA.SMA_post_GABA_water ./ (1 - Data_vox_partial_vol.SMA_post_CSF_prop) ; 
corr_output_GABA.SMA_pre_GABA_cr = uncorr_output_GABA.SMA_pre_GABA_cr ./ (1 - Data_vox_partial_vol.SMA_pre_CSF_prop) ; 
corr_output_GABA.SMA_post_GABA_cr = uncorr_output_GABA.SMA_pre_GABA_cr ./ (1 - Data_vox_partial_vol.SMA_post_CSF_prop) ;
corr_output_GABA.SMA_pre_GABA_NAA = uncorr_output_GABA.SMA_pre_GABA_NAA ./ (1 - Data_vox_partial_vol.SMA_pre_CSF_prop) ; 
corr_output_GABA.SMA_post_GABA_NAA = uncorr_output_GABA.SMA_post_GABA_NAA ./ (1 - Data_vox_partial_vol.SMA_post_CSF_prop) ;

%% Plot partial volume corrected GABA/water values - raw data, no outliers removed

%%%%%%% Baseline b/w PA groups %%%%%%
figure('color','w') ;
xaxis_group = [1,2] ;
idx_active = corr_output_GABA.PA_group_number == 1 ; 
idx_inactive = corr_output_GABA.PA_group_number == 2;

baseline_HP_GABA_water_active = corr_output_GABA.HP_pre_GABA_water(idx_active) ;
baseline_HP_GABA_water_inactive = corr_output_GABA.HP_pre_GABA_water(idx_inactive) ; 

%PA groups N is not equal - pad length N of PA active group with NaNs 
baseline_HP_GABA_water_active(19:20,1) = NaN ;
baseline_HP_GABA_water_PA_group = [baseline_HP_GABA_water_active,baseline_HP_GABA_water_inactive] ;

for x = 1:size(baseline_HP_GABA_water_active,1)
plot(xaxis_group,baseline_HP_GABA_water_PA_group(x,:),'*k') ; 
hold on;
end

title('Baseline GABA/water concentration between high/low PA groups')
xlabel('PA group')
ylabel('Baseline HP GABA/water')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;


% ALL WRONG - need to take partial volume corrected values 

%%%%%%% GABA/WATER %%%%%%%%%%
xaxis_time = [1,2] ; 
figure('color','w') ;

%PTL group - participants who received PTL rTMS

idx_ptl = corr_output_GABA.Stim_cond_num == 1 ;

% PTL pre and post GABA/water
subplot(2,3,1)

PTL_GABA_water_PTL_idx = PTL_pre_post_GABA_water(idx_ptl,:) ; 

for x = 1:size(PTL_GABA_water_PTL_idx,1)
    plot(xaxis_time,PTL_GABA_water_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('PTL GABA/H2O following PTL rTMS')
xlabel('Time') ;
ylabel('PTL GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/water 
subplot(2,3,2)

SMA_GABA_water_PTL_idx = SMA_pre_post_GABA_water(idx_ptl,:) ;

for x = 1:size(SMA_GABA_water_PTL_idx,1)
    plot(xaxis_time,SMA_GABA_water_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/H2O following PTL rTMS')
xlabel('Time') ;
ylabel('SMA GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/water
subplot(2,3,3)

HP_GABA_water_PTL_idx = HP_pre_post_GABA_water(idx_ptl,:) ; 

for x = 1:size(HP_GABA_water_PTL_idx,1)
    plot(xaxis_time,HP_GABA_water_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('HP GABA/H2O following PTL rTMS')
xlabel('Time') ; 
ylabel('HP GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%SMA group - participants who received SMA rTMS

idx_sma = corr_output_GABA.Stim_cond_num == 2 ; % Logical index for SMA subjects

% PTL pre and post GABA/water
subplot(2,3,4)

PTL_GABA_water_SMA_idx = PTL_pre_post_GABA_water(idx_sma,:) ; 

for x = 1:size(PTL_GABA_water_SMA_idx,1)
    plot(xaxis_time,PTL_GABA_water_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/H2O following SMA rTMS')
xlabel('Time') ;
ylabel('PTL GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/water 
subplot(2,3,5)

SMA_GABA_water_SMA_idx = SMA_pre_post_GABA_water(idx_sma,:) ;

for x = 1:size(SMA_GABA_water_SMA_idx,1)
    plot(xaxis_time,SMA_GABA_water_SMA_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/H2O following SMA rTMS')
xlabel('Time') ;
ylabel('SMA GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/water
subplot(2,3,6)

HP_GABA_water_SMA_idx = HP_pre_post_GABA_water(idx_sma,:) ; 

for x = 1:size(HP_GABA_water_SMA_idx,1)
    plot(xaxis_time,HP_GABA_water_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/H2O following SMA rTMS')
xlabel('Time') ;
ylabel('HP GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;


%%%%%%% GABA/cr %%%%%%%%%%

figure('color','w');

%PTL group - participants who received PTL rTMS

idx_ptl = corr_output_GABA.Stim_cond_num == 1 ;

% PTL pre and post GABA/cr
subplot(2,3,1)

PTL_GABA_cr_PTL_idx = PTL_pre_post_GABA_cr(idx_ptl,:) ; 

for x = 1:size(PTL_GABA_cr_PTL_idx,1)
    plot(xaxis_time,PTL_GABA_cr_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/cr following PTL rTMS')
xlabel('Time')
ylabel('PTL GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/cr 
subplot(2,3,2)

SMA_GABA_cr_PTL_idx = SMA_pre_post_GABA_cr(idx_ptl,:) ;

for x = 1:size(SMA_GABA_cr_PTL_idx,1)
    plot(xaxis_time,SMA_GABA_cr_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/cr following PTL rTMS')
xlabel('Time')
ylabel('SMA GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/cr
subplot(2,3,3)

HP_GABA_cr_PTL_idx = HP_pre_post_GABA_cr(idx_ptl,:) ; 

for x = 1:size(HP_GABA_cr_PTL_idx,1)
    plot(xaxis_time,HP_GABA_cr_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/cr following PTL rTMS')
xlabel('Time')
ylabel('HP GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%SMA group - participants who received SMA rTMS

% PTL pre and post GABA/cr
subplot(2,3,4)

PTL_GABA_cr_SMA_idx = PTL_pre_post_GABA_cr(idx_sma,:) ; 

for x = 1:size(PTL_GABA_cr_SMA_idx,1)
    plot(xaxis_time,PTL_GABA_cr_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/cr following SMA rTMS')
xlabel('Time')
ylabel('PTL GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/cr
subplot(2,3,5)

SMA_GABA_cr_SMA_idx = SMA_pre_post_GABA_cr(idx_sma,:) ;

for x = 1:size(SMA_GABA_cr_SMA_idx,1)
    plot(xaxis_time,SMA_GABA_cr_SMA_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/cr following SMA rTMS')
xlabel('Time')
ylabel('SMA GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/cr
subplot(2,3,6)

HP_GABA_cr_SMA_idx = HP_pre_post_GABA_cr(idx_sma,:) ; 

for x = 1:size(HP_GABA_cr_SMA_idx,1)
    plot(xaxis_time,HP_GABA_cr_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/cr following SMA rTMS')
xlabel('Time')
ylabel('HP GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%%%%% GABA/NAA %%%%%%%% 

figure('color','w');

%PTL group - participants who received PTL rTMS

idx_ptl = corr_output_GABA.Stim_cond_num == 1 ;

% PTL pre and post GABA/NAA
subplot(2,3,1)

PTL_GABA_NAA_PTL_idx = PTL_pre_post_GABA_NAA(idx_ptl,:) ; 

for x = 1:size(PTL_GABA_NAA_PTL_idx,1)
    plot(xaxis_time,PTL_GABA_NAA_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/NAA following PTL rTMS')
xlabel('Time')
ylabel('PTL GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/NAA 
subplot(2,3,2)

SMA_GABA_NAA_PTL_idx = SMA_pre_post_GABA_NAA(idx_ptl,:) ;

for x = 1:size(SMA_GABA_NAA_PTL_idx,1)
    plot(xaxis_time,SMA_GABA_NAA_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/NAA following PTL rTMS')
xlabel('Time')
ylabel('SMA GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/NAA
subplot(2,3,3)

HP_GABA_NAA_PTL_idx = HP_pre_post_GABA_NAA(idx_ptl,:) ; 

for x = 1:size(HP_GABA_NAA_PTL_idx,1)
    plot(xaxis_time,HP_GABA_NAA_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/NAA following PTL rTMS')
xlabel('Time')
ylabel('HP GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%SMA group - participants who received SMA rTMS

% PTL pre and post GABA/cr
subplot(2,3,4)

PTL_GABA_NAA_SMA_idx = PTL_pre_post_GABA_NAA(idx_sma,:) ;

for x = 1:size(PTL_GABA_NAA_SMA_idx,1)
    plot(xaxis_time,PTL_GABA_NAA_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/NAA following SMA rTMS')
xlabel('Time')
ylabel('PTL GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/NAA
subplot(2,3,5)

SMA_GABA_NAA_SMA_idx = SMA_pre_post_GABA_NAA(idx_sma,:) ;

for x = 1:size(SMA_GABA_NAA_SMA_idx,1)
    plot(xaxis_time,SMA_GABA_NAA_SMA_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/NAA following SMA rTMS')
xlabel('Time')
ylabel('SMA GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/cr
subplot(2,3,6)

HP_GABA_NAA_SMA_idx = HP_pre_post_GABA_NAA(idx_sma,:) ; 

for x = 1:size(HP_GABA_NAA_SMA_idx,1)
    plot(xaxis_time,HP_GABA_NAA_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/NAA following SMA rTMS')
xlabel('Time')
ylabel('HP GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%% Plot data outliers removed 

%%%%%%% Baseline b/w PA groups %%%%%%

% Baseline HP concentration 

figure('color','w') ;

outlier_baseline_HP_GABA_water_active = nanmean(baseline_HP_GABA_water_active) + (2*nanstd(baseline_HP_GABA_water_active)) ; % Identify values mean +2 stdev from baseline HP GABA/water mean active group
outlier_baseline_HP_GABA_water_inactive = nanmean(baseline_HP_GABA_water_inactive) + (2*nanstd(baseline_HP_GABA_water_inactive)) ; % Identify values mean +2 stdev from baseline HP GABA/water mean inactive group

baseline_HP_GABA_water_active_outlier_log = baseline_HP_GABA_water_active < outlier_baseline_HP_GABA_water_active ; % log index of outlier values active group
baseline_HP_GABA_water_inactive_outlier_log = baseline_HP_GABA_water_inactive < outlier_baseline_HP_GABA_water_inactive ; % log index of outlier values inactive group 

baseline_HP_GABA_water_active_outlier_corr = baseline_HP_GABA_water_active(baseline_HP_GABA_water_active_outlier_log) ; % baseline HP GABA/water active group, outliers removed
baseline_HP_GABA_water_inactive_outlier_corr = baseline_HP_GABA_water_inactive(baseline_HP_GABA_water_inactive_outlier_log) ; % baseline HP GABA/water inactive group, outliers removed

baseline_HP_GABA_water_PA_group_outlier_corr = [baseline_HP_GABA_water_active_outlier_corr,baseline_HP_GABA_water_inactive_outlier_corr] ;

mean_HP_GABA_water_active_outlier_corr = mean(baseline_HP_GABA_water_active_outlier_corr) ; % calculate mean and std active group for errorbar 
std_HP_GABA_water_active_outlier_corr = std(baseline_HP_GABA_water_active_outlier_corr) ;  

mean_HP_GABA_water_inactive_outlier_corr = mean(baseline_HP_GABA_water_inactive_outlier_corr) ; % calculate mean and std inactive group for errorbar 
std_HP_GABA_water_inactive_outlier_corr = std(baseline_HP_GABA_water_inactive_outlier_corr) ; 

errorbar_length_HP_GABA_water_BL_PA_group = [std_HP_GABA_water_active_outlier_corr, std_HP_GABA_water_inactive_outlier_corr] ; % std parameter for errorbar length 

for x = 1:size(baseline_HP_GABA_water_PA_group_outlier_corr,1)
plot(xaxis_group,baseline_HP_GABA_water_PA_group_outlier_corr(x,:),'*k') ; 
hold on;
end

title('Baseline HP GABA/water concentration between high/low PA groups, outliers removed')
xlabel('PA group')
ylabel('Baseline HP GABA/water')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;
ebar_HP_PA = errorbar(xaxis_group,[mean_HP_GABA_water_active_outlier_corr,mean_HP_GABA_water_inactive_outlier_corr],errorbar_length_HP_GABA_water_BL_PA_group) ;
set(ebar_HP_PA,'Marker','s','LineWidth',1,'MarkerSize',15,'Color','k')

% Baseline PTL concentration

% Baseline SMA concentration


%%%%%%% GABA/WATER %%%%%%%%%%
figure('color','w') ;

%PTL group - participants who received PTL rTMS

% PTL pre and post GABA/water
subplot(2,3,1)

PTL_pre_GABA_water_PTL_idx = corr_output_GABA.PTL_pre_GABA_water(idx_ptl) ; 
PTL_post_GABA_water_PTL_idx = corr_output_GABA.PTL_post_GABA_water(idx_ptl) ; 

outlier_high_cutoff_PTL_pre_GABA_water = nanmean(PTL_pre_GABA_water_PTL_idx) + (2.5*nanstd(PTL_pre_GABA_water_PTL_idx)) ;
outlier_low_cutoff_PTL_pre_GABA_water = nanmean(PTL_pre_GABA_water_PTL_idx) - (2.5*nanstd(PTL_pre_GABA_water_PTL_idx)) ;

outlier_high_cutoff_PTL_post_GABA_water = nanmean(PTL_post_GABA_water_PTL_idx) + (2.5*nanstd(PTL_post_GABA_water_PTL_idx)) ;
outlier_low_cutoff_PTL_post_GABA_water = nanmean(PTL_post_GABA_water_PTL_idx) - (2.5*nanstd(PTL_post_GABA_water_PTL_idx)) ;

PTL_pre_GABA_water_outlier_log = (PTL_pre_GABA_water_PTL_idx < outlier_low_cutoff_PTL_pre_GABA_water) | (PTL_pre_GABA_water_PTL_idx > outlier_high_cutoff_PTL_pre_GABA_water) ; % log index of outlier values
PTL_post_GABA_water_outlier_log = (PTL_post_GABA_water_PTL_idx < outlier_low_cutoff_PTL_post_GABA_water) | (PTL_post_GABA_water_PTL_idx > outlier_high_cutoff_PTL_post_GABA_water) ;

% PTL_pre_GABA_water_outlier_corr = PTL_pre_GABA_water_PTL_idx(PTL_pre_GABA_water_outlier_log == 0) ; 
PTL_pre_GABA_water_PTL_idx(PTL_pre_GABA_water_outlier_log == 1) = NaN; 

PTL_post_GABA_water_outlier_corr = PTL_post_GABA_water_PTL_idx(PTL_post_GABA_water_outlier_log == 0) ; 
PTL_post_GABA_water_outlier_corr(20,1) = nan

PTL_pre_post_GABA_water_outlier_corr = [PTL_pre_GABA_water_outlier_corr,PTL_post_GABA_water_outlier_corr] ;


for x = 1:size(pre_post_GABA_water_outlier_corr,1)
    plot(xaxis_time,PTL_GABA_water_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('PTL GABA/H2O following PTL rTMS')
xlabel('Time') ;
ylabel('PTL GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;


%% Save outputs

save('GABA_MRS_output.mat','uncorr_output_GABA','corr_output_GABA','GABA_QC','Data_vox_partial_vol') ; % save .mat file
writetable(corr_output_GABA,'GABA_vol_corrected_values_output.txt','Delimiter','\t','WriteRowNames',true) ; % save GABA volume corrected table as .txt file
writetable(corr_output_GABA,'GABA_vol_corrected_values_output.xlsx','WriteRowNames',true) ; % save GABA volume corrected table as .xlsx file
writetable(GABA_QC,'GABA_QC.txt','Delimiter','\t','WriteRowNames',true) ; % save GABA QC metric table as .txt file
writetable(GABA_QC,'GABA_QC.xlsx','WriteRowNames',true); % save GABA QC metric table as .xlsx file
movefile('GABA_MRS_output.mat',pathIn)
movefile('GABA_vol_corrected_values_output.txt',pathIn) ;
movefile('GABA_vol_corrected_values_output.xlsx',pathIn) ;
movefile('GABA_QC.txt',pathIn) ; 
movefile('GABA_QC.xlsx',pathIn) ;
