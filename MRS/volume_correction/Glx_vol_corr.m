% This script returns the partial volume corrected Glx concentrations
% for left hippocampus, left parietal, and
% pre supplementary motor area voxels for pre and post timepoints. 

% To run:

% 1) Make sure importfile_partial_vol.m is visable on the MATLAB path.
% 2) Set paths to MRS_struct data and partial vol dataset 

% Joshua Hendrikse, Jan 2019, joshua.hendrikse@monash.edu

%% Define paths & grouping variables

close all; clc; clear;

% add paths to data directories
addpath(genpath('/Volumes/LaCie/Ex_rTMS_study/ex_rtms_code/MRS/volume_correction/')) ;

addpath(genpath('/Volumes/LaCie_R/Ex_rTMS_study/Data/Analysis/Datasets/')) ;

addpath(genpath('/Volumes/LaCie_R/Ex_rTMS_study/Data/all_subjects/')) ;

pathIn = '/Volumes/LaCie_R/Ex_rTMS_study/Data/' ;

pathIn_specdata = [pathIn,'all_subjects/'];

ID = {'S3_DJ';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'} ; % all subjects

% ID = {'S44_ID'} % 'S3_DJ';} ; 

% Optional looping variables for sub-group analysis 

% Denotes subjects who are in active group and inactive group 

% ActiveID = {'S3_DJ';'S5_RD';'S6_KV';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S16_YS';'S17_JTR';'S19_JA';'S20_WO';'S22_NS';'S25_SC';'S27_ANW';'S33_DJG';'S34_ST';'S35_TG';'S36_AY'} ; % subjects from physically active group 

% InactiveID = {'S7_PK';'S13_MD';'S15_AZ';'S18_KF';'S21_KC';'S24_AU';'S26_KW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'} ; % subjects from inactive active group

% Denotes subjects who received rTMS to llpc target or sma target in wk1

% llpcID = {'DJ_03';'RD_05';'SF_09';'JT_10';'MD_13';'AZ_15';'YS_16';'JTR_17';'KF_18';'WO_20';'KC_21';'XK_28';'AR_31';'ST_34';'TG_35';'CR_38';'JC_41';'SA_42';'PL_43'} ; % subjects who received LLPC rTMS
 
% smaID = {'KV_06';'PK_07';'AW_08';'RB_11';'JA_19';'NS_22';'AU_24';'SC_25';'KW_26';'ANW_27';'HZ_29';'PKA_30';'CD_32';'DJG_33';'AY_36';'JT_37';'EH_39';'NU_40';'ID_44'} ; % subjects who received SMA rTMS
 
% PA_group = {'Active';'Inactive'} ; 
 
% timePoint = {'pre';'post'} ; 
 
% voxel = {'hippocampus','parietal','sma'} ; 

%% Extract Glx filepath & filenames

% Initialise variables
Glx_HP_pre_path = cell(length(ID),1) ;
Glx_PTL_pre_path = cell(length(ID),1) ;
Glx_SMA_pre_path = cell(length(ID),1) ;
Glx_HP_post_path = cell(length(ID),1) ;
Glx_PTL_post_path = cell(length(ID),1) ;
Glx_SMA_post_path = cell(length(ID),1) ;

for y = 1:length(ID) %for loop to extract Glx filepaths for each voxel at each timepoint
    
    %HP Glx pre timepoint file path
    Glx_HP_pre_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Pre/','Glx_only/','meas_*_hippocampus']) ; % generate absolute path to data dir
    
    if  isempty([Glx_HP_pre_dir.name]) == 0
        Glx_HP_pre_path{y,:} = [Glx_HP_pre_dir.folder,'/',Glx_HP_pre_dir.name] ; % if exists, save absolute path to cell array
    else
        Glx_HP_pre_path{y,:} = '<missing>' ; % else, leave empty
    end

    %PTL Glx pre timepoint file path    
    Glx_PTL_pre_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Pre/','Glx_only/','meas_*_parietal']) ;
    
    if  isempty([Glx_PTL_pre_dir.name]) == 0
        Glx_PTL_pre_path{y,:} = [Glx_PTL_pre_dir.folder,'/',Glx_PTL_pre_dir.name] ;
    else
        Glx_PTL_pre_path{y,:} = '<missing>' ;
    end
    
    %SMA Glx pre timepoint file path
    Glx_SMA_pre_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Pre/','Glx_only/','meas_*_sma']) ;
    
    if  isempty([Glx_SMA_pre_dir.name]) == 0
        Glx_SMA_pre_path{y,:} = [Glx_SMA_pre_dir.folder,'/',Glx_SMA_pre_dir.name] ;
    else
        Glx_SMA_pre_path{y,:} = '<missing>' ;
    end
    
    %HP Glx post timepoint file path
    Glx_HP_post_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Post/','Glx_only/','meas_*_hippocampus']) ;
    
    if  isempty([Glx_HP_post_dir.name]) == 0
        Glx_HP_post_path{y,:} = [Glx_HP_post_dir.folder,'/',Glx_HP_post_dir.name] ;
    else
        Glx_HP_post_path{y,:} = '<missing>' ;
    end
    
    %PTL Glx post timepoint file path
    Glx_PTL_post_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Post/','Glx_only/','meas_*_parietal']) ;
    
    if  isempty([Glx_PTL_post_dir.name]) == 0
        Glx_PTL_post_path{y,:} = [Glx_PTL_post_dir.folder,'/',Glx_PTL_post_dir.name] ;
    else
        Glx_PTL_post_path{y,:} = '<missing>' ;
    end
    
    %SMA Glx post timepoint file path
    Glx_SMA_post_dir = dir([char(pathIn_specdata),char(ID{y,1}),'/MRI/','MRS/','Post/','Glx_only/','meas_*_sma']) ;
    
    if  isempty([Glx_SMA_post_dir.name]) == 0
        Glx_SMA_post_path{y,:} = [Glx_SMA_post_dir.folder,'/',Glx_SMA_post_dir.name] ;
    else
        Glx_SMA_post_path{y,:} = '<missing>' ;
    end
end

% Save all file paths in cell 
% all_filepaths_Glx = [Glx_HP_pre_path, Glx_HP_post_path, Glx_PTL_pre_path, Glx_PTL_post_path, Glx_SMA_pre_path, Glx_SMA_post_path] ;


%% This cell to import partial volume corrected values from partial_vol_corr.txt 

filename_partial_vol = [pathIn,'Analysis','/','Datasets','/','Partial_vol_corr.csv'] ;

Data_vox_partial_vol = importfile_partial_vol(filename_partial_vol) ;

%% HIPPOCAMPUS Glx 

% Hippocampus pre timepoint

% Initialise summary variables
HP_pre_Glx_water_summary = cell(length(ID),1) ;
HP_pre_Glx_cr_summary = cell(length(ID),1) ;
HP_pre_Glx_NAA_summary = cell(length(ID),1) ;   
HP_pre_Glx_fit_err_summary = cell(length(ID),1) ;
HP_pre_Glx_SNR_summary = cell(length(ID),1) ;
HP_pre_Glx_FWHM_summary = cell(length(ID),1) ;

% for loop across HP pre time point across subjects 

% Load MRS_struct.mat files containing metabolite estimates across subjects

for z = 1:length(Glx_HP_pre_path)
    
    if ismissing(Glx_HP_pre_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for HP pre path for each subject
        
        load([Glx_HP_pre_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            HP_pre_Glx_water = MRS_struct.out.vox1.Glx.ConcIU ;
        else
            HP_pre_Glx_water = NaN ;
        end
        
        % save concentration estimates 
        HP_pre_Glx_Cr = MRS_struct.out.vox1.Glx.ConcCr ;
        HP_pre_Glx_NAA = MRS_struct.out.vox1.Glx.ConcNAA ;
        
        % save data QC estimates 
        HP_pre_Glx_fit_err = MRS_struct.out.vox1.Glx.FitError ; 
        HP_pre_Glx_SNR = MRS_struct.out.vox1.Glx.SNR ;
        HP_pre_Glx_FWHM = MRS_struct.out.vox1.Glx.FWHM ;
        
    elseif ismissing(Glx_HP_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        HP_pre_Glx_water = NaN ;
        HP_pre_Glx_Cr = NaN ; 
        HP_pre_Glx_NAA = NaN ; 
        
        HP_pre_Glx_fit_err = NaN ;
        HP_pre_Glx_SNR = NaN ;
        HP_pre_Glx_FWHM = NaN ;
    end
    
    % Save output variables for HP pre timepoint
    
    % Save Glx concentrations referenced to water, Cr, and NAA as cell &
    % array 
    HP_pre_Glx_water_summary{z,:} = HP_pre_Glx_water ;
    HP_pre_Glx_cr_summary{z,:} =  HP_pre_Glx_Cr ;
    HP_pre_Glx_NAA_summary{z,:} = HP_pre_Glx_NAA ;
  
    % Save data quality metrics for HP pre Glx as cell & array
    HP_pre_Glx_fit_err_summary{z,:} = HP_pre_Glx_fit_err ; 
    HP_pre_Glx_SNR_summary{z,:} = HP_pre_Glx_SNR ;
    HP_pre_Glx_FWHM_summary{z,:} = HP_pre_Glx_FWHM ;
    
end

% Reformat output cell to numerical array
HP_pre_Glx_water_summary_array = cell2mat(HP_pre_Glx_water_summary) ;
HP_pre_Glx_cr_summary_array = cell2mat(HP_pre_Glx_cr_summary) ;
HP_pre_Glx_NAA_summary_array = cell2mat(HP_pre_Glx_NAA_summary) ; 
HP_pre_Glx_fit_err_summary_array = cell2mat(HP_pre_Glx_fit_err_summary) ;    
HP_pre_Glx_SNR_summary_array = cell2mat(HP_pre_Glx_SNR_summary) ; 
HP_pre_Glx_FWHM_summary_array = cell2mat(HP_pre_Glx_FWHM_summary) ; 

% % Output HP pre concentrations & data quality metrics 
% HP_pre_Glx_conc = [HP_pre_Glx_water_summary_array, HP_pre_Glx_cr_summary_array, HP_pre_Glx_NAA_summary_array] ;
% HP_pre_Glx_data_QC = [HP_pre_Glx_fit_err_summary_array, HP_pre_Glx_SNR_summary_array, HP_pre_Glx_FWHM_summary_array] ; 

% Hippocampus post timepoint 

% Initialise summary variables
HP_post_Glx_water_summary = cell(length(ID),1) ;
HP_post_Glx_cr_summary = cell(length(ID),1) ;
HP_post_Glx_NAA_summary = cell(length(ID),1) ;   
HP_post_Glx_fit_err_summary = cell(length(ID),1) ;
HP_post_Glx_SNR_summary = cell(length(ID),1) ;
HP_post_Glx_FWHM_summary = cell(length(ID),1) ;

% for loop across HP post time point across subjects  

for z = 1:length(Glx_HP_post_path)
    
    if ismissing(Glx_HP_post_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for HP post path for each subject
        
        load([Glx_HP_post_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            HP_post_Glx_water = MRS_struct.out.vox1.Glx.ConcIU ;
        else
            HP_post_Glx_water = NaN ;
        end
        
        % save concentration estimates 
        HP_post_Glx_Cr = MRS_struct.out.vox1.Glx.ConcCr ;
        HP_post_Glx_NAA = MRS_struct.out.vox1.Glx.ConcNAA ;
        
        % save data QC estimates 
        HP_post_Glx_fit_err = MRS_struct.out.vox1.Glx.FitError ; 
        HP_post_Glx_SNR = MRS_struct.out.vox1.Glx.SNR ;
        HP_post_Glx_FWHM = MRS_struct.out.vox1.Glx.FWHM ;
        
    elseif ismissing(Glx_HP_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        HP_post_Glx_water = NaN ;
        HP_post_Glx_Cr = NaN ; 
        HP_post_Glx_NAA = NaN ; 
        
        HP_post_Glx_fit_err = NaN ;
        HP_post_Glx_SNR = NaN ;
        HP_post_Glx_FWHM = NaN ;
    end
    
    % Save output variables for HP post timepoint
    
    % Save Glx concentrations referenced to water, Cr, and NAA as cell &
    % array 
    HP_post_Glx_water_summary{z,:} = HP_post_Glx_water ;
    HP_post_Glx_cr_summary{z,:} =  HP_post_Glx_Cr ;
    HP_post_Glx_NAA_summary{z,:} = HP_post_Glx_NAA ;
  
    % Save data quality metrics for HP post Glx as cell & array
    HP_post_Glx_fit_err_summary{z,:} = HP_post_Glx_fit_err ; 
    HP_post_Glx_SNR_summary{z,:} = HP_post_Glx_SNR ;
    HP_post_Glx_FWHM_summary{z,:} = HP_post_Glx_FWHM ;
    
end

% Reformat output cell to numerical array
HP_post_Glx_water_summary_array = cell2mat(HP_post_Glx_water_summary) ;
HP_post_Glx_cr_summary_array = cell2mat(HP_post_Glx_cr_summary) ;
HP_post_Glx_NAA_summary_array = cell2mat(HP_post_Glx_NAA_summary) ; 
HP_post_Glx_fit_err_summary_array = cell2mat(HP_post_Glx_fit_err_summary) ;    
HP_post_Glx_SNR_summary_array = cell2mat(HP_post_Glx_SNR_summary) ; 
HP_post_Glx_FWHM_summary_array = cell2mat(HP_post_Glx_FWHM_summary) ; 

% Output HP post concentrations & data quality metrics 

% HP_post_Glx_conc = [HP_post_Glx_water_summary_array, HP_post_Glx_cr_summary_array, HP_post_Glx_NAA_summary_array] ;
% HP_post_Glx_data_QC = [HP_post_Glx_fit_err_summary_array, HP_post_Glx_SNR_summary_array, HP_post_Glx_FWHM_summary_array] ; 

% %===================== HP pre & post summary =================%

% HP_pre_post_Glx_water = [HP_pre_Glx_water_summary_array,HP_post_Glx_water_summary_array] ;
% HP_pre_post_Glx_cr = [HP_pre_Glx_cr_summary_array,HP_post_Glx_cr_summary_array] ; 
% HP_pre_post_Glx_NAA = [HP_pre_Glx_NAA_summary_array,HP_post_Glx_NAA_summary_array] ;

%% LEFT PARIETAL CORTEX Glx

% Left parietal pre timepoint

% Initialise summary variables
PTL_pre_Glx_water_summary = cell(length(ID),1) ;
PTL_pre_Glx_cr_summary = cell(length(ID),1) ;
PTL_pre_Glx_NAA_summary = cell(length(ID),1) ;   
PTL_pre_Glx_fit_err_summary = cell(length(ID),1) ;
PTL_pre_Glx_SNR_summary = cell(length(ID),1) ;
PTL_pre_Glx_FWHM_summary = cell(length(ID),1) ;

% for loop across PTL pre time point across subjects   

for z = 1:length(Glx_PTL_pre_path)
    
    if ismissing(Glx_PTL_pre_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for PTL pre path for each subject
        
        load([Glx_PTL_pre_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            PTL_pre_Glx_water = MRS_struct.out.vox1.Glx.ConcIU ;
        else
            PTL_pre_Glx_water = NaN ;
        end
        
        % save concentration estimates 
        PTL_pre_Glx_Cr = MRS_struct.out.vox1.Glx.ConcCr ;
        PTL_pre_Glx_NAA = MRS_struct.out.vox1.Glx.ConcNAA ;
        
        % save data QC estimates 
        PTL_pre_Glx_fit_err = MRS_struct.out.vox1.Glx.FitError ; 
        PTL_pre_Glx_SNR = MRS_struct.out.vox1.Glx.SNR ;
        PTL_pre_Glx_FWHM = MRS_struct.out.vox1.Glx.FWHM ;
        
    elseif ismissing(Glx_PTL_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        PTL_pre_Glx_water = NaN ;
        PTL_pre_Glx_Cr = NaN ; 
        PTL_pre_Glx_NAA = NaN ; 
        
        PTL_pre_Glx_fit_err = NaN ;
        PTL_pre_Glx_SNR = NaN ;
        PTL_pre_Glx_FWHM = NaN ;
    end
    
    % Save output variables for PTL pre timepoint
    
    % Save Glx concentrations referenced to water, Cr, and NAA as cell &
    % array 
    PTL_pre_Glx_water_summary{z,:} = PTL_pre_Glx_water ;
    PTL_pre_Glx_cr_summary{z,:} =  PTL_pre_Glx_Cr ;
    PTL_pre_Glx_NAA_summary{z,:} = PTL_pre_Glx_NAA ;
  
    % Save data quality metrics for PTL pre Glx as cell & array
    PTL_pre_Glx_fit_err_summary{z,:} = PTL_pre_Glx_fit_err ; 
    PTL_pre_Glx_SNR_summary{z,:} = PTL_pre_Glx_SNR ;
    PTL_pre_Glx_FWHM_summary{z,:} = PTL_pre_Glx_FWHM ; 

end

% Reformat output cell to numerical array
PTL_pre_Glx_water_summary_array = cell2mat(PTL_pre_Glx_water_summary) ;
PTL_pre_Glx_cr_summary_array = cell2mat(PTL_pre_Glx_cr_summary) ;
PTL_pre_Glx_NAA_summary_array = cell2mat(PTL_pre_Glx_NAA_summary) ; 
PTL_pre_Glx_fit_err_summary_array = cell2mat(PTL_pre_Glx_fit_err_summary) ;    
PTL_pre_Glx_SNR_summary_array = cell2mat(PTL_pre_Glx_SNR_summary) ; 
PTL_pre_Glx_FWHM_summary_array = cell2mat(PTL_pre_Glx_FWHM_summary) ; 

% Output PTL pre concentrations & data quality metrics 
% PTL_pre_Glx_conc = [PTL_pre_Glx_water_summary_array, PTL_pre_Glx_cr_summary_array, PTL_pre_Glx_NAA_summary_array] ;
% PTL_pre_Glx_data_QC = [PTL_pre_Glx_fit_err_summary_array, PTL_pre_Glx_SNR_summary_array, PTL_pre_Glx_FWHM_summary_array] ; 

% Left parietal cortex post timepoint 

% Initialise summary variables
PTL_post_Glx_water_summary = cell(length(ID),1) ;
PTL_post_Glx_cr_summary = cell(length(ID),1) ;
PTL_post_Glx_NAA_summary = cell(length(ID),1) ;   
PTL_post_Glx_fit_err_summary = cell(length(ID),1) ;
PTL_post_Glx_SNR_summary = cell(length(ID),1) ;
PTL_post_Glx_FWHM_summary = cell(length(ID),1) ;

% for loop across PTL post time point across subjects 

for z = 1:length(Glx_PTL_post_path)
    
    if ismissing(Glx_PTL_post_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for PTL post path for each subject
        
        load([Glx_PTL_post_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            PTL_post_Glx_water = MRS_struct.out.vox1.Glx.ConcIU ;
        else
            PTL_post_Glx_water = NaN ;
        end
        
        % save concentration estimates 
        PTL_post_Glx_Cr = MRS_struct.out.vox1.Glx.ConcCr ;
        PTL_post_Glx_NAA = MRS_struct.out.vox1.Glx.ConcNAA ;
        
        % save data QC estimates 
        PTL_post_Glx_fit_err = MRS_struct.out.vox1.Glx.FitError ; 
        PTL_post_Glx_SNR = MRS_struct.out.vox1.Glx.SNR ;
        PTL_post_Glx_FWHM = MRS_struct.out.vox1.Glx.FWHM ;
        
    elseif ismissing(Glx_PTL_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        PTL_post_Glx_water = NaN ;
        PTL_post_Glx_Cr = NaN ; 
        PTL_post_Glx_NAA = NaN ; 
        
        PTL_post_Glx_fit_err = NaN ;
        PTL_post_Glx_SNR = NaN ;
        PTL_post_Glx_FWHM = NaN ;
    end
    
    % Save output variables for PTL post timepoint
    
    % Save Glx concentrations referenced to water, Cr, and NAA as cell &
    % array 
    PTL_post_Glx_water_summary{z,:} = PTL_post_Glx_water ;
    PTL_post_Glx_cr_summary{z,:} =  PTL_post_Glx_Cr ;
    PTL_post_Glx_NAA_summary{z,:} = PTL_post_Glx_NAA ;
  
    % Save data quality metrics for PTL post Glx as cell & array
    PTL_post_Glx_fit_err_summary{z,:} = PTL_post_Glx_fit_err ; 
    PTL_post_Glx_SNR_summary{z,:} = PTL_post_Glx_SNR ;
    PTL_post_Glx_FWHM_summary{z,:} = PTL_post_Glx_FWHM ; 
end

% Reformat output cell to numerical array
PTL_post_Glx_water_summary_array = cell2mat(PTL_post_Glx_water_summary) ;
PTL_post_Glx_cr_summary_array = cell2mat(PTL_post_Glx_cr_summary) ;
PTL_post_Glx_NAA_summary_array = cell2mat(PTL_post_Glx_NAA_summary) ; 
PTL_post_Glx_fit_err_summary_array = cell2mat(PTL_post_Glx_fit_err_summary) ;    
PTL_post_Glx_SNR_summary_array = cell2mat(PTL_post_Glx_SNR_summary) ; 
PTL_post_Glx_FWHM_summary_array = cell2mat(PTL_post_Glx_FWHM_summary) ; 

% Output PTL post concentrations & data quality metrics 

% PTL_post_Glx_conc = [PTL_post_Glx_water_summary_array, PTL_post_Glx_cr_summary_array, PTL_post_Glx_NAA_summary_array] ;
% PTL_post_Glx_data_QC = [PTL_post_Glx_fit_err_summary_array, PTL_post_Glx_SNR_summary_array, PTL_post_Glx_FWHM_summary_array] ; 
% 
% %===================== PTL pre & post summary =================%
% 
% PTL_pre_post_Glx_water = [PTL_pre_Glx_water_summary_array,PTL_post_Glx_water_summary_array] ;
% PTL_pre_post_Glx_cr = [PTL_pre_Glx_cr_summary_array,PTL_post_Glx_cr_summary_array] ; 
% PTL_pre_post_Glx_NAA = [PTL_pre_Glx_NAA_summary_array,PTL_post_Glx_NAA_summary_array] ;


%% SUPPLEMENTARY MOTOR AREA Glx

% SMA pre timepoint

% Initialise summary variables
SMA_pre_Glx_water_summary = cell(length(ID),1) ;
SMA_pre_Glx_cr_summary = cell(length(ID),1) ;
SMA_pre_Glx_NAA_summary = cell(length(ID),1) ;   
SMA_pre_Glx_fit_err_summary = cell(length(ID),1) ;
SMA_pre_Glx_SNR_summary = cell(length(ID),1) ;
SMA_pre_Glx_FWHM_summary = cell(length(ID),1) ;

% for loop across SMA pre time point across subjects 

for z = 1:length(Glx_SMA_pre_path)
    
    if ismissing(Glx_SMA_pre_path(z),'<missing>') == 0 % check that file path exists, if yes, load. 
        
        % load Gannet output structure for SMA pre path for each subject
        
        load([Glx_SMA_pre_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            SMA_pre_Glx_water = MRS_struct.out.vox1.Glx.ConcIU ;
        else
            SMA_pre_Glx_water = NaN ;
        end
        
        % save concentration estimates 
        SMA_pre_Glx_Cr = MRS_struct.out.vox1.Glx.ConcCr ;
        SMA_pre_Glx_NAA = MRS_struct.out.vox1.Glx.ConcNAA ;
        
        % save data QC estimates 
        SMA_pre_Glx_fit_err = MRS_struct.out.vox1.Glx.FitError ; 
        SMA_pre_Glx_SNR = MRS_struct.out.vox1.Glx.SNR ;
        SMA_pre_Glx_FWHM = MRS_struct.out.vox1.Glx.FWHM ;
        
    elseif ismissing(Glx_SMA_pre_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        SMA_pre_Glx_water = NaN ;
        SMA_pre_Glx_Cr = NaN ; 
        SMA_pre_Glx_NAA = NaN ; 
        
        SMA_pre_Glx_fit_err = NaN ;
        SMA_pre_Glx_SNR = NaN ;
        SMA_pre_Glx_FWHM = NaN ;
    end
    
    % Save output variables for SMA pre timepoint
    
    % Save Glx concentrations referenced to water, Cr, and NAA as cell &
    % array 
    SMA_pre_Glx_water_summary{z,:} = SMA_pre_Glx_water ;
    SMA_pre_Glx_cr_summary{z,:} =  SMA_pre_Glx_Cr ;
    SMA_pre_Glx_NAA_summary{z,:} = SMA_pre_Glx_NAA ;
  
    % Save data quality metrics for SMA pre Glx as cell & array
    SMA_pre_Glx_fit_err_summary{z,:} = SMA_pre_Glx_fit_err ; 
    SMA_pre_Glx_SNR_summary{z,:} = SMA_pre_Glx_SNR ;
    SMA_pre_Glx_FWHM_summary{z,:} = SMA_pre_Glx_FWHM ; 
    
end

% Reformat output cell to numerical array
SMA_pre_Glx_water_summary_array = cell2mat(SMA_pre_Glx_water_summary) ;
SMA_pre_Glx_cr_summary_array = cell2mat(SMA_pre_Glx_cr_summary) ;
SMA_pre_Glx_NAA_summary_array = cell2mat(SMA_pre_Glx_NAA_summary) ; 
SMA_pre_Glx_fit_err_summary_array = cell2mat(SMA_pre_Glx_fit_err_summary) ;    
SMA_pre_Glx_SNR_summary_array = cell2mat(SMA_pre_Glx_SNR_summary) ; 
SMA_pre_Glx_FWHM_summary_array = cell2mat(SMA_pre_Glx_FWHM_summary) ; 

% Output SMA pre concentrations & data quality metrics

% SMA_pre_Glx_conc = [SMA_pre_Glx_water_summary_array, SMA_pre_Glx_cr_summary_array, SMA_pre_Glx_NAA_summary_array] ;
% SMA_pre_Glx_data_QC = [SMA_pre_Glx_fit_err_summary_array, SMA_pre_Glx_SNR_summary_array, SMA_pre_Glx_FWHM_summary_array] ; 

% SMA post timepoint 

% Initialise summary variables
SMA_post_Glx_water_summary = cell(length(ID),1) ;
SMA_post_Glx_cr_summary = cell(length(ID),1) ;
SMA_post_Glx_NAA_summary = cell(length(ID),1) ;   
SMA_post_Glx_fit_err_summary = cell(length(ID),1) ;
SMA_post_Glx_SNR_summary = cell(length(ID),1) ;
SMA_post_Glx_FWHM_summary = cell(length(ID),1) ;

% for loop across SMA post time point across subjects 

for z = 1:length(Glx_SMA_post_path)
    
    if ismissing(Glx_SMA_post_path(z),'<missing>') == 0 % check that file path exists, if yes, load.
        
        % load Gannet output structure for SMA post path for each subject
        
        load([Glx_SMA_post_path{z},'/','MRS_struct.mat'],'-mat','MRS_struct')
        
        % check that output structure contains water reference, else return
        % NaNs for water fields - could change this to input estimated values
        % For two subjects without water estimates will need to import ratio
        % values (could save as .csv or .txt file)
        
        if isfield(MRS_struct.out.vox1,'water')
            
            SMA_post_Glx_water = MRS_struct.out.vox1.Glx.ConcIU ;
        else
            SMA_post_Glx_water = NaN ;
        end
        
        % save concentration estimates
        SMA_post_Glx_Cr = MRS_struct.out.vox1.Glx.ConcCr ;
        SMA_post_Glx_NAA = MRS_struct.out.vox1.Glx.ConcNAA ;
        
        % save data QC estimates
        SMA_post_Glx_fit_err = MRS_struct.out.vox1.Glx.FitError ;
        SMA_post_Glx_SNR = MRS_struct.out.vox1.Glx.SNR ;
        SMA_post_Glx_FWHM = MRS_struct.out.vox1.Glx.FWHM ;
        
    elseif ismissing(Glx_SMA_post_path(z),'<missing>') == 1 % otherwise, if file path is missing, return NaN's for all fields.
        
        SMA_post_Glx_water = NaN ;
        SMA_post_Glx_Cr = NaN ;
        SMA_post_Glx_NAA = NaN ;
        
        SMA_post_Glx_fit_err = NaN ;
        SMA_post_Glx_SNR = NaN ;
        SMA_post_Glx_FWHM = NaN ;
    end
    
    % Save output variables for SMA post timepoint
    
    % Save Glx concentrations referenced to water, Cr, and NAA as cell &
    % array
    SMA_post_Glx_water_summary{z,:} = SMA_post_Glx_water ;
    SMA_post_Glx_cr_summary{z,:} =  SMA_post_Glx_Cr ;
    SMA_post_Glx_NAA_summary{z,:} = SMA_post_Glx_NAA ;
    
    % Save data quality metrics for SMA post Glx as cell & array
    SMA_post_Glx_fit_err_summary{z,:} = SMA_post_Glx_fit_err ;
    SMA_post_Glx_SNR_summary{z,:} = SMA_post_Glx_SNR ;
    SMA_post_Glx_FWHM_summary{z,:} = SMA_post_Glx_FWHM ;
    
end

% Reformat output cell to numerical array
SMA_post_Glx_water_summary_array = cell2mat(SMA_post_Glx_water_summary) ;
SMA_post_Glx_cr_summary_array = cell2mat(SMA_post_Glx_cr_summary) ;
SMA_post_Glx_NAA_summary_array = cell2mat(SMA_post_Glx_NAA_summary) ; 
SMA_post_Glx_fit_err_summary_array = cell2mat(SMA_post_Glx_fit_err_summary) ;    
SMA_post_Glx_SNR_summary_array = cell2mat(SMA_post_Glx_SNR_summary) ; 
SMA_post_Glx_FWHM_summary_array = cell2mat(SMA_post_Glx_FWHM_summary) ;

% Output SMA post concentrations & data quality metrics 

% SMA_post_Glx_conc = [SMA_post_Glx_water_summary_array, SMA_post_Glx_cr_summary_array, SMA_post_Glx_NAA_summary_array] ;
% SMA_post_Glx_data_QC = [SMA_post_Glx_fit_err_summary_array, SMA_post_Glx_SNR_summary_array, SMA_post_Glx_FWHM_summary_array] ; 

%===================== SMA pre & post summary =================%

% SMA_pre_post_water = [SMA_pre_Glx_water_summary_array,SMA_post_Glx_water_summary_array] ;
% SMA_pre_post_cr = [SMA_pre_Glx_cr_summary_array,SMA_post_Glx_cr_summary_array] ; 
% SMA_pre_post_NAA = [SMA_pre_Glx_NAA_summary_array,SMA_post_Glx_NAA_summary_array] ;

%% Output tables - Glx uncorrected values & QC metrics  

% Output table containing pre, post
% uncorr values for each subject for each voxel location. Ind. columns for
% water referenced, cr referenced, and NAA referenced metab conc. 

%Uncorrected concentration values
uncorr_output_Glx = table ; 
uncorr_output_Glx.ID = ID ;
uncorr_output_Glx.Stim_cond = Data_vox_partial_vol.Stim_cond ;
uncorr_output_Glx.Stim_cond_num = Data_vox_partial_vol.Stim_cond_num ;
uncorr_output_Glx.PA_group = Data_vox_partial_vol.PA_group ;
uncorr_output_Glx.PA_group_number = Data_vox_partial_vol.PA_group_num ;

uncorr_output_Glx.HP_pre_Glx_water = HP_pre_Glx_water_summary_array ; 
uncorr_output_Glx.HP_post_Glx_water = HP_post_Glx_water_summary_array ; 
uncorr_output_Glx.HP_pre_Glx_cr = HP_pre_Glx_cr_summary_array ;
uncorr_output_Glx.HP_post_Glx_cr = HP_post_Glx_cr_summary_array ; 
uncorr_output_Glx.HP_pre_Glx_NAA = HP_pre_Glx_NAA_summary_array ; 
uncorr_output_Glx.HP_post_Glx_NAA = HP_post_Glx_NAA_summary_array ;

uncorr_output_Glx.PTL_pre_Glx_water = PTL_pre_Glx_water_summary_array ; 
uncorr_output_Glx.PTL_post_Glx_water = PTL_post_Glx_water_summary_array ; 
uncorr_output_Glx.PTL_pre_Glx_cr = PTL_pre_Glx_cr_summary_array ;
uncorr_output_Glx.PTL_post_Glx_cr = PTL_post_Glx_cr_summary_array ; 
uncorr_output_Glx.PTL_pre_Glx_NAA = PTL_pre_Glx_NAA_summary_array ; 
uncorr_output_Glx.PTL_post_Glx_NAA = PTL_post_Glx_NAA_summary_array ;

uncorr_output_Glx.SMA_pre_Glx_water = SMA_pre_Glx_water_summary_array ; 
uncorr_output_Glx.SMA_post_Glx_water = SMA_post_Glx_water_summary_array ; 
uncorr_output_Glx.SMA_pre_Glx_cr = SMA_pre_Glx_cr_summary_array ;
uncorr_output_Glx.SMA_post_Glx_cr = SMA_post_Glx_cr_summary_array ; 
uncorr_output_Glx.SMA_pre_Glx_NAA = SMA_pre_Glx_NAA_summary_array ; 
uncorr_output_Glx.SMA_post_Glx_NAA = SMA_post_Glx_NAA_summary_array ;

% QC metrics
Glx_QC = table ; 
Glx_QC.ID = ID ;
Glx_QC.Stim_cond = Data_vox_partial_vol.Stim_cond ;
Glx_QC.Stim_cond_num = Data_vox_partial_vol.Stim_cond_num ;
Glx_QC.PA_group = Data_vox_partial_vol.PA_group ;
Glx_QC.PA_group_number = Data_vox_partial_vol.PA_group_num ;

Glx_QC.HP_pre_fit_err = HP_pre_Glx_fit_err_summary_array ; 
Glx_QC.HP_post_fit_err = HP_post_Glx_fit_err_summary_array ;
Glx_QC.HP_pre_SNR = HP_pre_Glx_SNR_summary_array ;
Glx_QC.HP_post_SNR = HP_post_Glx_SNR_summary_array ; 
Glx_QC.HP_pre_FWHM = HP_pre_Glx_FWHM_summary_array ;
Glx_QC.HP_post_FWHM = HP_post_Glx_FWHM_summary_array ;

Glx_QC.PTL_pre_fit_err = PTL_pre_Glx_fit_err_summary_array ; 
Glx_QC.PTL_post_fit_err = PTL_post_Glx_fit_err_summary_array ;
Glx_QC.PTL_pre_SNR = PTL_pre_Glx_SNR_summary_array ;
Glx_QC.PTL_post_SNR = PTL_post_Glx_SNR_summary_array ; 
Glx_QC.PTL_pre_FWHM = PTL_pre_Glx_FWHM_summary_array ;
Glx_QC.PTL_post_FWHM = PTL_post_Glx_FWHM_summary_array ;

Glx_QC.SMA_pre_fit_err = SMA_pre_Glx_fit_err_summary_array ; 
Glx_QC.SMA_post_fit_err = SMA_post_Glx_fit_err_summary_array ;
Glx_QC.SMA_pre_SNR = SMA_pre_Glx_SNR_summary_array ;
Glx_QC.SMA_post_SNR = SMA_post_Glx_SNR_summary_array ; 
Glx_QC.SMA_pre_FWHM = SMA_pre_Glx_FWHM_summary_array ;
Glx_QC.SMA_post_FWHM = SMA_post_Glx_FWHM_summary_array ;

% save QC table 

%% Input estimated Glx/water (uncorrected) values for subjects w.o water twix file

% These values were generated by calculating TARQUIN water estimates using
% rda2 (off file) and then calculated relative to known GANNET values. 
% i.e. 1. (GannetPreWater_missing / TarquinPreWater) = GannetPostWater_known /
% TarquinPostWater); 2. GlxabsoluteConc / estimated_water * K constant

% Insert into uncorrected output tables 

S3_DJ_HP_Glx_water_pre = 12.9931 ;
uncorr_output_Glx.HP_pre_Glx_water(1,1) = S3_DJ_HP_Glx_water_pre ;

S3_DJ_PTL_Glx_water_pre = 11.1368 ;
uncorr_output_Glx.PTL_pre_Glx_water(1,1) = S3_DJ_PTL_Glx_water_pre ;

S3_DJ_SMA_Glx_water_pre = 9.0336 ; 
uncorr_output_Glx.SMA_pre_Glx_water(1,1) = S3_DJ_SMA_Glx_water_pre ; 

S5_RD_PTL_Glx_water_pre = 3.6704 ;
uncorr_output_Glx.PTL_pre_Glx_water(2,1) = S5_RD_PTL_Glx_water_pre ;

S5_RD_SMA_Glx_water_pre = 2.3969 ;
uncorr_output_Glx.SMA_pre_Glx_water(2,1) = S5_RD_SMA_Glx_water_pre ; 

S31_AR_PTL_Glx_water_post = NaN ; % need to ask Chao about Tarquin Glx
uncorr_output_Glx.PTL_post_Glx_water(25,1) = S31_AR_PTL_Glx_water_post ;

S31_AR_PTL_Glx_cr_post =  NaN ;
uncorr_output_Glx.PTL_post_Glx_cr(25,1) = S31_AR_PTL_Glx_cr_post ;


%% Partial volume corrected Glx (metabolite / (1 - CSF proportion) 

% Partial volume corrected Glx concentration values
corr_output_Glx = table ; 
corr_output_Glx.ID = ID ;
corr_output_Glx.Stim_cond = Data_vox_partial_vol.Stim_cond ;
corr_output_Glx.Stim_cond_num = Data_vox_partial_vol.Stim_cond_num ;
corr_output_Glx.PA_group = Data_vox_partial_vol.PA_group ;
corr_output_Glx.PA_group_number = Data_vox_partial_vol.PA_group_num ;


corr_output_Glx.HP_pre_Glx_water = uncorr_output_Glx.HP_pre_Glx_water ./ (1 - Data_vox_partial_vol.HP_pre_CSF_prop) ;
corr_output_Glx.HP_post_Glx_water = uncorr_output_Glx.HP_post_Glx_water ./ (1 - Data_vox_partial_vol.HP_post_CSF_prop) ; 
corr_output_Glx.HP_pre_Glx_cr = uncorr_output_Glx.HP_pre_Glx_cr ./ (1 - Data_vox_partial_vol.HP_pre_CSF_prop) ;
corr_output_Glx.HP_post_Glx_cr = uncorr_output_Glx.HP_post_Glx_cr ./ (1 - Data_vox_partial_vol.HP_post_CSF_prop) ; 
corr_output_Glx.HP_pre_Glx_NAA = uncorr_output_Glx.HP_pre_Glx_NAA ./ (1 - Data_vox_partial_vol.HP_pre_CSF_prop) ;
corr_output_Glx.HP_post_Glx_NAA = uncorr_output_Glx.HP_post_Glx_NAA ./ (1 - Data_vox_partial_vol.HP_post_CSF_prop) ; 

corr_output_Glx.PTL_pre_Glx_water = uncorr_output_Glx.PTL_pre_Glx_water ./ (1 - Data_vox_partial_vol.PTL_pre_CSF_prop) ; 
corr_output_Glx.PTL_post_Glx_water = uncorr_output_Glx.PTL_post_Glx_water ./ (1 - Data_vox_partial_vol.PTL_post_CSF_prop) ; 
corr_output_Glx.PTL_pre_Glx_cr = uncorr_output_Glx.PTL_pre_Glx_cr ./ (1 - Data_vox_partial_vol.PTL_pre_CSF_prop) ; 
corr_output_Glx.PTL_post_Glx_cr = uncorr_output_Glx.PTL_post_Glx_cr ./ (1 - Data_vox_partial_vol.PTL_post_CSF_prop) ; 
corr_output_Glx.PTL_pre_Glx_NAA = uncorr_output_Glx.PTL_pre_Glx_NAA ./ (1 - Data_vox_partial_vol.PTL_pre_CSF_prop) ; 
corr_output_Glx.PTL_post_Glx_NAA = uncorr_output_Glx.PTL_post_Glx_NAA ./ (1 - Data_vox_partial_vol.PTL_post_CSF_prop) ;

corr_output_Glx.SMA_pre_Glx_water = uncorr_output_Glx.SMA_pre_Glx_water ./ (1 - Data_vox_partial_vol.SMA_pre_CSF_prop) ; 
corr_output_Glx.SMA_post_Glx_water = uncorr_output_Glx.SMA_post_Glx_water ./ (1 - Data_vox_partial_vol.SMA_post_CSF_prop) ; 
corr_output_Glx.SMA_pre_Glx_cr = uncorr_output_Glx.SMA_pre_Glx_cr ./ (1 - Data_vox_partial_vol.SMA_pre_CSF_prop) ; 
corr_output_Glx.SMA_post_Glx_cr = uncorr_output_Glx.SMA_post_Glx_cr ./ (1 - Data_vox_partial_vol.SMA_post_CSF_prop) ;
corr_output_Glx.SMA_pre_Glx_NAA = uncorr_output_Glx.SMA_pre_Glx_NAA ./ (1 - Data_vox_partial_vol.SMA_pre_CSF_prop) ; 
corr_output_Glx.SMA_post_Glx_NAA = uncorr_output_Glx.SMA_post_Glx_NAA ./ (1 - Data_vox_partial_vol.SMA_post_CSF_prop) ;

%% Plot baseline b/w PA groups, outliers removed

xaxis_group = [1,2] ;
idx_active = corr_output_Glx.PA_group_number == 1 ; 
idx_inactive = corr_output_Glx.PA_group_number == 2;

% Baseline HP concentration 

figure('color','w') ;

subplot(1,3,1)

baseline_HP_Glx_water_active = corr_output_Glx.HP_pre_Glx_water(idx_active) ; 
baseline_HP_Glx_water_inactive = corr_output_Glx.HP_pre_Glx_water(idx_inactive) ;

outlier_high_cutoff_baseline_HP_Glx_water_active = nanmean(baseline_HP_Glx_water_active) + (2.5*nanstd(baseline_HP_Glx_water_active)) ; % Identify values mean +-2.5 stdev from baseline HP Glx/water mean active group
outlier_low_cutoff_baseline_HP_Glx_water_active = nanmean(baseline_HP_Glx_water_active) - (2.5*nanstd(baseline_HP_Glx_water_active)) ;

outlier_high_cutoff_baseline_HP_Glx_water_inactive = nanmean(baseline_HP_Glx_water_inactive) + (2*nanstd(baseline_HP_Glx_water_inactive)) ; % Identify values mean +-2.5 stdev from baseline HP Glx/water mean inactive group
outlier_low_cutoff_baseline_HP_Glx_water_inactive = nanmean(baseline_HP_Glx_water_inactive) - (2*nanstd(baseline_HP_Glx_water_inactive)) ;

baseline_HP_Glx_water_active_outlier_log = (baseline_HP_Glx_water_active < outlier_low_cutoff_baseline_HP_Glx_water_active) | (baseline_HP_Glx_water_active > outlier_high_cutoff_baseline_HP_Glx_water_active) ; % log index of outlier values % log index of outlier values active group
baseline_HP_Glx_water_inactive_outlier_log = (baseline_HP_Glx_water_inactive < outlier_low_cutoff_baseline_HP_Glx_water_inactive) | (baseline_HP_Glx_water_inactive > outlier_high_cutoff_baseline_HP_Glx_water_inactive) ; % log index of outlier values inactive group

baseline_HP_Glx_water_active_outlier_corr = corr_output_Glx.HP_pre_Glx_water(idx_active) ;
baseline_HP_Glx_water_inactive_outlier_corr = corr_output_Glx.HP_pre_Glx_water(idx_inactive) ; 

baseline_HP_Glx_water_active_outlier_corr(baseline_HP_Glx_water_active_outlier_log == 1) = NaN ;  
baseline_HP_Glx_water_inactive_outlier_corr(baseline_HP_Glx_water_inactive_outlier_log == 1) = NaN ;  

baseline_HP_Glx_water_active_outlier_corr(19:20,1) = NaN ; % Pad with NaNs to give equal length with post timepoint

baseline_HP_Glx_water_PA_group_outlier_corr = [baseline_HP_Glx_water_active_outlier_corr,baseline_HP_Glx_water_inactive_outlier_corr] ;

mean_HP_Glx_water_active_outlier_corr = nanmean(baseline_HP_Glx_water_active_outlier_corr) ; % calculate mean and std active group for errorbar 
std_HP_Glx_water_active_outlier_corr = nanstd(baseline_HP_Glx_water_active_outlier_corr) ;  

mean_HP_Glx_water_inactive_outlier_corr = nanmean(baseline_HP_Glx_water_inactive_outlier_corr) ; % calculate mean and std inactive group for errorbar 
std_HP_Glx_water_inactive_outlier_corr = nanstd(baseline_HP_Glx_water_inactive_outlier_corr) ; 

errorbar_length_HP_Glx_water_BL_PA_group = [std_HP_Glx_water_active_outlier_corr, std_HP_Glx_water_inactive_outlier_corr] ; % std parameter for errorbar length 

for x = 1:size(baseline_HP_Glx_water_PA_group_outlier_corr,1)
plot(xaxis_group,baseline_HP_Glx_water_PA_group_outlier_corr(x,:),'*k') ; 
hold on;
end

title('Baseline HP Glx/water concentration between high/low PA groups, outliers removed')
xlabel('PA group')
ylabel('Baseline HP Glx/water')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;
ebar_HP_PA = errorbar(xaxis_group,[mean_HP_Glx_water_active_outlier_corr,mean_HP_Glx_water_inactive_outlier_corr],errorbar_length_HP_Glx_water_BL_PA_group) ;
set(ebar_HP_PA,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% Baseline PTL concentration
subplot(1,3,2)

baseline_PTL_Glx_water_active = corr_output_Glx.PTL_pre_Glx_water(idx_active) ; 
baseline_PTL_Glx_water_inactive = corr_output_Glx.PTL_pre_Glx_water(idx_inactive) ;

outlier_high_cutoff_baseline_PTL_Glx_water_active = nanmean(baseline_PTL_Glx_water_active) + (2.5*nanstd(baseline_PTL_Glx_water_active)) ; % Identify values mean +-2.5 stdev from baseline PTL Glx/water mean active group
outlier_low_cutoff_baseline_PTL_Glx_water_active = nanmean(baseline_PTL_Glx_water_active) - (2.5*nanstd(baseline_PTL_Glx_water_active)) ;

outlier_high_cutoff_baseline_PTL_Glx_water_inactive = nanmean(baseline_PTL_Glx_water_inactive) + (2*nanstd(baseline_PTL_Glx_water_inactive)) ; % Identify values mean +-2.5 stdev from baseline PTL Glx/water mean inactive group
outlier_low_cutoff_baseline_PTL_Glx_water_inactive = nanmean(baseline_PTL_Glx_water_inactive) - (2*nanstd(baseline_PTL_Glx_water_inactive)) ;

baseline_PTL_Glx_water_active_outlier_log = (baseline_PTL_Glx_water_active < outlier_low_cutoff_baseline_PTL_Glx_water_active) | (baseline_PTL_Glx_water_active > outlier_high_cutoff_baseline_PTL_Glx_water_active) ; % log index of outlier values % log index of outlier values active group
baseline_PTL_Glx_water_inactive_outlier_log = (baseline_PTL_Glx_water_inactive < outlier_low_cutoff_baseline_PTL_Glx_water_inactive) | (baseline_PTL_Glx_water_inactive > outlier_high_cutoff_baseline_PTL_Glx_water_inactive) ; % log index of outlier values inactive group

baseline_PTL_Glx_water_active_outlier_corr = corr_output_Glx.PTL_pre_Glx_water(idx_active) ;
baseline_PTL_Glx_water_inactive_outlier_corr = corr_output_Glx.PTL_pre_Glx_water(idx_inactive) ; 

baseline_PTL_Glx_water_active_outlier_corr(baseline_PTL_Glx_water_active_outlier_log == 1) = NaN ;  
baseline_PTL_Glx_water_inactive_outlier_corr(baseline_PTL_Glx_water_inactive_outlier_log == 1) = NaN ; 

baseline_PTL_Glx_water_active_outlier_corr(19:20,1) = NaN ; % Pad with NaNs to give equal length with post timepoint

baseline_PTL_Glx_water_PA_group_outlier_corr = [baseline_PTL_Glx_water_active_outlier_corr,baseline_PTL_Glx_water_inactive_outlier_corr] ;

mean_PTL_Glx_water_active_outlier_corr = nanmean(baseline_PTL_Glx_water_active_outlier_corr) ; % calculate mean and std active group for errorbar 
std_PTL_Glx_water_active_outlier_corr = nanstd(baseline_PTL_Glx_water_active_outlier_corr) ;  

mean_PTL_Glx_water_inactive_outlier_corr = nanmean(baseline_PTL_Glx_water_inactive_outlier_corr) ; % calculate mean and std inactive group for errorbar 
std_PTL_Glx_water_inactive_outlier_corr = nanstd(baseline_PTL_Glx_water_inactive_outlier_corr) ; 

errorbar_length_PTL_Glx_water_BL_PA_group = [std_PTL_Glx_water_active_outlier_corr, std_PTL_Glx_water_inactive_outlier_corr] ; % std parameter for errorbar length 

for x = 1:size(baseline_PTL_Glx_water_PA_group_outlier_corr,1)
plot(xaxis_group,baseline_PTL_Glx_water_PA_group_outlier_corr(x,:),'*k') ; 
hold on;
end

title('Baseline PTL Glx/water concentration between high/low PA groups, outliers removed') ;
xlabel('PA group') ;
ylabel('Baseline PTL Glx/water') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;
ebar_PTL_PA = errorbar(xaxis_group,[mean_PTL_Glx_water_active_outlier_corr,mean_PTL_Glx_water_inactive_outlier_corr],errorbar_length_PTL_Glx_water_BL_PA_group) ;
set(ebar_PTL_PA,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k') ;

% Baseline SMA concentration
subplot(1,3,3)

baseline_SMA_Glx_water_active = corr_output_Glx.SMA_pre_Glx_water(idx_active) ; 
baseline_SMA_Glx_water_inactive = corr_output_Glx.SMA_pre_Glx_water(idx_inactive) ;

outlier_high_cutoff_baseline_SMA_Glx_water_active = nanmean(baseline_SMA_Glx_water_active) + (2.5*nanstd(baseline_SMA_Glx_water_active)) ; % Identify values mean +-2.5 stdev from baseline SMA Glx/water mean active group
outlier_low_cutoff_baseline_SMA_Glx_water_active = nanmean(baseline_SMA_Glx_water_active) - (2.5*nanstd(baseline_SMA_Glx_water_active)) ;

outlier_high_cutoff_baseline_SMA_Glx_water_inactive = nanmean(baseline_SMA_Glx_water_inactive) + (2*nanstd(baseline_SMA_Glx_water_inactive)) ; % Identify values mean +-2.5 stdev from baseline SMA Glx/water mean inactive group
outlier_low_cutoff_baseline_SMA_Glx_water_inactive = nanmean(baseline_SMA_Glx_water_inactive) - (2*nanstd(baseline_SMA_Glx_water_inactive)) ;

baseline_SMA_Glx_water_active_outlier_log = (baseline_SMA_Glx_water_active < outlier_low_cutoff_baseline_SMA_Glx_water_active) | (baseline_SMA_Glx_water_active > outlier_high_cutoff_baseline_SMA_Glx_water_active) ; % log index of outlier values % log index of outlier values active group
baseline_SMA_Glx_water_inactive_outlier_log = (baseline_SMA_Glx_water_inactive < outlier_low_cutoff_baseline_SMA_Glx_water_inactive) | (baseline_SMA_Glx_water_inactive > outlier_high_cutoff_baseline_SMA_Glx_water_inactive) ; % log index of outlier values inactive group

baseline_SMA_Glx_water_active_outlier_corr = corr_output_Glx.SMA_pre_Glx_water(idx_active) ;
baseline_SMA_Glx_water_inactive_outlier_corr = corr_output_Glx.SMA_pre_Glx_water(idx_inactive) ; 

baseline_SMA_Glx_water_active_outlier_corr(baseline_SMA_Glx_water_active_outlier_log == 1) = NaN ;  
baseline_SMA_Glx_water_inactive_outlier_corr(baseline_SMA_Glx_water_inactive_outlier_log == 1) = NaN ; 

baseline_SMA_Glx_water_active_outlier_corr(19:20,1) = NaN ; % Pad with NaNs to give equal length with post timepoint

baseline_SMA_Glx_water_PA_group_outlier_corr = [baseline_SMA_Glx_water_active_outlier_corr,baseline_SMA_Glx_water_inactive_outlier_corr] ;

mean_SMA_Glx_water_active_outlier_corr = nanmean(baseline_SMA_Glx_water_active_outlier_corr) ; % calculate mean and std active group for errorbar 
std_SMA_Glx_water_active_outlier_corr = nanstd(baseline_SMA_Glx_water_active_outlier_corr) ;  

mean_SMA_Glx_water_inactive_outlier_corr = nanmean(baseline_SMA_Glx_water_inactive_outlier_corr) ; % calculate mean and std inactive group for errorbar 
std_SMA_Glx_water_inactive_outlier_corr = nanstd(baseline_SMA_Glx_water_inactive_outlier_corr) ; 

errorbar_length_SMA_Glx_water_BL_PA_group = [std_SMA_Glx_water_active_outlier_corr, std_SMA_Glx_water_inactive_outlier_corr] ; % std parameter for errorbar length 

for x = 1:size(baseline_SMA_Glx_water_PA_group_outlier_corr,1)
plot(xaxis_group,baseline_SMA_Glx_water_PA_group_outlier_corr(x,:),'*k') ; 
hold on;
end

title('Baseline SMA Glx/water concentration between high/low PA groups, outliers removed') ;
xlabel('PA group') ;
ylabel('Baseline SMA Glx/water') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;
ebar_SMA_PA = errorbar(xaxis_group,[mean_SMA_Glx_water_active_outlier_corr,mean_SMA_Glx_water_inactive_outlier_corr],errorbar_length_SMA_Glx_water_BL_PA_group) ;
set(ebar_SMA_PA,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k') ;

%% Pre - post comparisons, outliers removed

idx_ptl = corr_output_Glx.Stim_cond_num == 1 ; % Logical index for PTL subjects
idx_sma = corr_output_Glx.Stim_cond_num == 2 ; % Logical index for SMA subjects

xaxis_time = [1,2] ; % Set pre, post colums in plots

%%%%%%% Glx/WATER %%%%%%%%%%

figure('color','w') ;

%PTL group - participants who received PTL rTMS

% PTL pre and post Glx/water
subplot(2,3,1)

PTL_pre_Glx_water_PTL_idx = corr_output_Glx.PTL_pre_Glx_water(idx_ptl) ; 
PTL_post_Glx_water_PTL_idx = corr_output_Glx.PTL_post_Glx_water(idx_ptl) ; 

outlier_high_cutoff_PTL_pre_Glx_water_PTL_idx = nanmean(PTL_pre_Glx_water_PTL_idx) + (2.5*nanstd(PTL_pre_Glx_water_PTL_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_PTL_pre_Glx_water_PTL_idx = nanmean(PTL_pre_Glx_water_PTL_idx) - (2.5*nanstd(PTL_pre_Glx_water_PTL_idx)) ;

outlier_high_cutoff_PTL_post_Glx_water_PTL_idx = nanmean(PTL_post_Glx_water_PTL_idx) + (2.5*nanstd(PTL_post_Glx_water_PTL_idx)) ;
outlier_low_cutoff_PTL_post_Glx_water_PTL_idx = nanmean(PTL_post_Glx_water_PTL_idx) - (2.5*nanstd(PTL_post_Glx_water_PTL_idx)) ;

PTL_pre_Glx_water_outlier_log_PTL_idx = (PTL_pre_Glx_water_PTL_idx < outlier_low_cutoff_PTL_pre_Glx_water_PTL_idx) | (PTL_pre_Glx_water_PTL_idx > outlier_high_cutoff_PTL_pre_Glx_water_PTL_idx) ; % log index of outlier values
PTL_post_Glx_water_outlier_log_PTL_idx = (PTL_post_Glx_water_PTL_idx < outlier_low_cutoff_PTL_post_Glx_water_PTL_idx) | (PTL_post_Glx_water_PTL_idx > outlier_high_cutoff_PTL_post_Glx_water_PTL_idx) ;

PTL_pre_Glx_water_PTL_idx(PTL_pre_Glx_water_outlier_log_PTL_idx == 1) = NaN; % replace outliers with NaNs 
PTL_post_Glx_water_PTL_idx(PTL_post_Glx_water_outlier_log_PTL_idx == 1) = NaN; 

PTL_pre_post_Glx_water_outlier_corr_PTL_idx = [PTL_pre_Glx_water_PTL_idx,PTL_post_Glx_water_PTL_idx] ; 

% errorbar variables
mean_PTL_pre_Glx_water_PTL_idx_outlier_corr = nanmean(PTL_pre_Glx_water_PTL_idx) ; % calculate mean and std
std_PTL_pre_Glx_water_PTL_idx_outlier_corr = nanstd(PTL_pre_Glx_water_PTL_idx) ;  

mean_PTL_post_Glx_water_PTL_idx_outlier_corr = nanmean(PTL_post_Glx_water_PTL_idx) ; % calculate mean and std 
std_PTL_post_Glx_water_PTL_idx_outlier_corr = nanstd(PTL_post_Glx_water_PTL_idx) ;

for x = 1:size(PTL_pre_post_Glx_water_outlier_corr_PTL_idx,1)
    plot(xaxis_time,PTL_pre_post_Glx_water_outlier_corr_PTL_idx(x,:),'*-k') ;
    hold on;
end

title('PTL Glx/H2O following PTL rTMS, outliers removed')
xlabel('Time') ;
ylabel('PTL Glx/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_PTL_Glx_water_ptl_idx = errorbar(xaxis_group,[mean_PTL_pre_Glx_water_PTL_idx_outlier_corr,mean_PTL_post_Glx_water_PTL_idx_outlier_corr,],[std_PTL_pre_Glx_water_PTL_idx_outlier_corr,std_PTL_post_Glx_water_PTL_idx_outlier_corr]) ;
set(ebar_PTL_Glx_water_ptl_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% SMA pre and post Glx/water
subplot(2,3,2)

SMA_pre_Glx_water_PTL_idx = corr_output_Glx.SMA_pre_Glx_water(idx_ptl) ; 
SMA_post_Glx_water_PTL_idx = corr_output_Glx.SMA_post_Glx_water(idx_ptl) ; 

outlier_high_cutoff_SMA_pre_Glx_water_PTL_idx = nanmean(SMA_pre_Glx_water_PTL_idx) + (2.5*nanstd(SMA_pre_Glx_water_PTL_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_SMA_pre_Glx_water_PTL_idx = nanmean(SMA_pre_Glx_water_PTL_idx) - (2.5*nanstd(SMA_pre_Glx_water_PTL_idx)) ;

outlier_high_cutoff_SMA_post_Glx_water_PTL_idx = nanmean(SMA_post_Glx_water_PTL_idx) + (2.5*nanstd(SMA_post_Glx_water_PTL_idx)) ;
outlier_low_cutoff_SMA_post_Glx_water_PTL_idx = nanmean(SMA_post_Glx_water_PTL_idx) - (2.5*nanstd(SMA_post_Glx_water_PTL_idx)) ;

SMA_pre_Glx_water_outlier_log_PTL_idx = (SMA_pre_Glx_water_PTL_idx < outlier_low_cutoff_SMA_pre_Glx_water_PTL_idx) | (SMA_pre_Glx_water_PTL_idx > outlier_high_cutoff_SMA_pre_Glx_water_PTL_idx) ; % log index of outlier values
SMA_post_Glx_water_outlier_log_PTL_idx = (SMA_post_Glx_water_PTL_idx < outlier_low_cutoff_SMA_post_Glx_water_PTL_idx) | (SMA_post_Glx_water_PTL_idx > outlier_high_cutoff_SMA_post_Glx_water_PTL_idx) ;

SMA_pre_Glx_water_PTL_idx(SMA_pre_Glx_water_outlier_log_PTL_idx == 1) = NaN; % replace outliers with NaNs 
SMA_post_Glx_water_PTL_idx(SMA_post_Glx_water_outlier_log_PTL_idx == 1) = NaN; 

SMA_pre_post_Glx_water_outlier_corr_PTL_idx = [SMA_pre_Glx_water_PTL_idx,SMA_post_Glx_water_PTL_idx] ; 

% errorbar variables
mean_SMA_pre_Glx_water_PTL_idx_outlier_corr = nanmean(SMA_pre_Glx_water_PTL_idx) ; % calculate mean and std
std_SMA_pre_Glx_water_PTL_idx_outlier_corr = nanstd(SMA_pre_Glx_water_PTL_idx) ;  

mean_SMA_post_Glx_water_PTL_idx_outlier_corr = nanmean(SMA_post_Glx_water_PTL_idx) ; % calculate mean and std 
std_SMA_post_Glx_water_PTL_idx_outlier_corr = nanstd(SMA_post_Glx_water_PTL_idx) ;

for x = 1:size(SMA_pre_post_Glx_water_outlier_corr_PTL_idx,1)
    plot(xaxis_time,SMA_pre_post_Glx_water_outlier_corr_PTL_idx(x,:),'*-k') ;
    hold on;
end

title('SMA Glx/H2O following PTL rTMS, outliers removed')
xlabel('Time') ;
ylabel('SMA Glx/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_SMA_Glx_water_ptl_idx = errorbar(xaxis_group,[mean_SMA_pre_Glx_water_PTL_idx_outlier_corr,mean_SMA_post_Glx_water_PTL_idx_outlier_corr,],[std_SMA_pre_Glx_water_PTL_idx_outlier_corr,std_SMA_post_Glx_water_PTL_idx_outlier_corr]) ;
set(ebar_SMA_Glx_water_ptl_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% HP pre and post Glx/water
subplot(2,3,3)

HP_pre_Glx_water_PTL_idx = corr_output_Glx.HP_pre_Glx_water(idx_ptl) ; 
HP_post_Glx_water_PTL_idx = corr_output_Glx.HP_post_Glx_water(idx_ptl) ; 

outlier_high_cutoff_HP_pre_Glx_water_PTL_idx = nanmean(HP_pre_Glx_water_PTL_idx) + (2.5*nanstd(HP_pre_Glx_water_PTL_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_HP_pre_Glx_water_PTL_idx = nanmean(HP_pre_Glx_water_PTL_idx) - (2.5*nanstd(HP_pre_Glx_water_PTL_idx)) ;

outlier_high_cutoff_HP_post_Glx_water_PTL_idx = nanmean(HP_post_Glx_water_PTL_idx) + (2.5*nanstd(HP_post_Glx_water_PTL_idx)) ;
outlier_low_cutoff_HP_post_Glx_water_PTL_idx = nanmean(HP_post_Glx_water_PTL_idx) - (2.5*nanstd(HP_post_Glx_water_PTL_idx)) ;

HP_pre_Glx_water_outlier_log_PTL_idx = (HP_pre_Glx_water_PTL_idx < outlier_low_cutoff_HP_pre_Glx_water_PTL_idx) | (HP_pre_Glx_water_PTL_idx > outlier_high_cutoff_HP_pre_Glx_water_PTL_idx) ; % log index of outlier values
HP_post_Glx_water_outlier_log_PTL_idx = (HP_post_Glx_water_PTL_idx < outlier_low_cutoff_HP_post_Glx_water_PTL_idx) | (HP_post_Glx_water_PTL_idx > outlier_high_cutoff_HP_post_Glx_water_PTL_idx) ;

HP_pre_Glx_water_PTL_idx(HP_pre_Glx_water_outlier_log_PTL_idx == 1) = NaN; % replace outliers with NaNs 
HP_post_Glx_water_PTL_idx(HP_post_Glx_water_outlier_log_PTL_idx == 1) = NaN; 

HP_pre_post_Glx_water_outlier_corr_PTL_idx = [HP_pre_Glx_water_PTL_idx,HP_post_Glx_water_PTL_idx] ; 

% errorbar variables
mean_HP_pre_Glx_water_PTL_idx_outlier_corr = nanmean(HP_pre_Glx_water_PTL_idx) ; % calculate mean and std
std_HP_pre_Glx_water_PTL_idx_outlier_corr = nanstd(HP_pre_Glx_water_PTL_idx) ;  

mean_HP_post_Glx_water_PTL_idx_outlier_corr = nanmean(HP_post_Glx_water_PTL_idx) ; % calculate mean and std 
std_HP_post_Glx_water_PTL_idx_outlier_corr = nanstd(HP_post_Glx_water_PTL_idx) ;

for x = 1:size(HP_pre_post_Glx_water_outlier_corr_PTL_idx,1)
    plot(xaxis_time,HP_pre_post_Glx_water_outlier_corr_PTL_idx(x,:),'*-k') ;
    hold on;
end

title('HP Glx/H2O following PTL rTMS, outliers removed')
xlabel('Time') ;
ylabel('HP Glx/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_HP_Glx_water_ptl_idx = errorbar(xaxis_group,[mean_HP_pre_Glx_water_PTL_idx_outlier_corr,mean_HP_post_Glx_water_PTL_idx_outlier_corr,],[std_HP_pre_Glx_water_PTL_idx_outlier_corr,std_HP_post_Glx_water_PTL_idx_outlier_corr]) ;
set(ebar_HP_Glx_water_ptl_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

%SMA group - participants who received PTL rTMS

% PTL pre and post Glx/water
subplot(2,3,4)

PTL_pre_Glx_water_SMA_idx = corr_output_Glx.PTL_pre_Glx_water(idx_sma) ; 
PTL_post_Glx_water_SMA_idx = corr_output_Glx.PTL_post_Glx_water(idx_sma) ; 

outlier_high_cutoff_PTL_pre_Glx_water_SMA_idx = nanmean(PTL_pre_Glx_water_SMA_idx) + (2.5*nanstd(PTL_pre_Glx_water_SMA_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_PTL_pre_Glx_water_SMA_idx = nanmean(PTL_pre_Glx_water_SMA_idx) - (2.5*nanstd(PTL_pre_Glx_water_SMA_idx)) ;

outlier_high_cutoff_PTL_post_Glx_water_SMA_idx = nanmean(PTL_post_Glx_water_SMA_idx) + (2.5*nanstd(PTL_post_Glx_water_SMA_idx)) ;
outlier_low_cutoff_PTL_post_Glx_water_SMA_idx = nanmean(PTL_post_Glx_water_SMA_idx) - (2.5*nanstd(PTL_post_Glx_water_SMA_idx)) ;

PTL_pre_Glx_water_outlier_log_SMA_idx = (PTL_pre_Glx_water_SMA_idx < outlier_low_cutoff_PTL_pre_Glx_water_SMA_idx) | (PTL_pre_Glx_water_SMA_idx > outlier_high_cutoff_PTL_pre_Glx_water_SMA_idx) ; % log index of outlier values
PTL_post_Glx_water_outlier_log_SMA_idx = (PTL_post_Glx_water_SMA_idx < outlier_low_cutoff_PTL_post_Glx_water_SMA_idx) | (PTL_post_Glx_water_SMA_idx > outlier_high_cutoff_PTL_post_Glx_water_SMA_idx) ;

PTL_pre_Glx_water_SMA_idx(PTL_pre_Glx_water_outlier_log_SMA_idx == 1) = NaN; % replace outliers with NaNs 
PTL_post_Glx_water_SMA_idx(PTL_post_Glx_water_outlier_log_SMA_idx == 1) = NaN; 

PTL_pre_post_Glx_water_outlier_corr_SMA_idx = [PTL_pre_Glx_water_SMA_idx,PTL_post_Glx_water_SMA_idx] ; 

% errorbar variables
mean_PTL_pre_Glx_water_SMA_idx_outlier_corr = nanmean(PTL_pre_Glx_water_SMA_idx) ; % calculate mean and std
std_PTL_pre_Glx_water_SMA_idx_outlier_corr = nanstd(PTL_pre_Glx_water_SMA_idx) ;  

mean_PTL_post_Glx_water_SMA_idx_outlier_corr = nanmean(PTL_post_Glx_water_SMA_idx) ; % calculate mean and std 
std_PTL_post_Glx_water_SMA_idx_outlier_corr = nanstd(PTL_post_Glx_water_SMA_idx) ;

for x = 1:size(PTL_pre_post_Glx_water_outlier_corr_SMA_idx,1)
    plot(xaxis_time,PTL_pre_post_Glx_water_outlier_corr_SMA_idx(x,:),'*-k') ;
    hold on;
end

title('PTL Glx/H2O following SMA rTMS, outliers removed')
xlabel('Time') ;
ylabel('PTL Glx/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_PTL_Glx_water_sma_idx = errorbar(xaxis_group,[mean_PTL_pre_Glx_water_SMA_idx_outlier_corr,mean_PTL_post_Glx_water_SMA_idx_outlier_corr,],[std_PTL_pre_Glx_water_SMA_idx_outlier_corr,std_PTL_post_Glx_water_SMA_idx_outlier_corr]) ;
set(ebar_PTL_Glx_water_sma_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% SMA pre and post Glx/water
subplot(2,3,5)

SMA_pre_Glx_water_SMA_idx = corr_output_Glx.SMA_pre_Glx_water(idx_sma) ; 
SMA_post_Glx_water_SMA_idx = corr_output_Glx.SMA_post_Glx_water(idx_sma) ; 

outlier_high_cutoff_SMA_pre_Glx_water_SMA_idx = nanmean(SMA_pre_Glx_water_SMA_idx) + (2.5*nanstd(SMA_pre_Glx_water_SMA_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_SMA_pre_Glx_water_SMA_idx = nanmean(SMA_pre_Glx_water_SMA_idx) - (2.5*nanstd(SMA_pre_Glx_water_SMA_idx)) ;

outlier_high_cutoff_SMA_post_Glx_water_SMA_idx = nanmean(SMA_post_Glx_water_SMA_idx) + (2.5*nanstd(SMA_post_Glx_water_SMA_idx)) ;
outlier_low_cutoff_SMA_post_Glx_water_SMA_idx = nanmean(SMA_post_Glx_water_SMA_idx) - (2.5*nanstd(SMA_post_Glx_water_SMA_idx)) ;

SMA_pre_Glx_water_outlier_log_SMA_idx = (SMA_pre_Glx_water_SMA_idx < outlier_low_cutoff_SMA_pre_Glx_water_SMA_idx) | (SMA_pre_Glx_water_SMA_idx > outlier_high_cutoff_SMA_pre_Glx_water_SMA_idx) ; % log index of outlier values
SMA_post_Glx_water_outlier_log_SMA_idx = (SMA_post_Glx_water_SMA_idx < outlier_low_cutoff_SMA_post_Glx_water_SMA_idx) | (SMA_post_Glx_water_SMA_idx > outlier_high_cutoff_SMA_post_Glx_water_SMA_idx) ;

SMA_pre_Glx_water_SMA_idx(SMA_pre_Glx_water_outlier_log_SMA_idx == 1) = NaN; % replace outliers with NaNs 
SMA_post_Glx_water_SMA_idx(SMA_post_Glx_water_outlier_log_SMA_idx == 1) = NaN; 

SMA_pre_post_Glx_water_outlier_corr_SMA_idx = [SMA_pre_Glx_water_SMA_idx,SMA_post_Glx_water_SMA_idx] ; 

% errorbar variables
mean_SMA_pre_Glx_water_SMA_idx_outlier_corr = nanmean(SMA_pre_Glx_water_SMA_idx) ; % calculate mean and std
std_SMA_pre_Glx_water_SMA_idx_outlier_corr = nanstd(SMA_pre_Glx_water_SMA_idx) ;  

mean_SMA_post_Glx_water_SMA_idx_outlier_corr = nanmean(SMA_post_Glx_water_SMA_idx) ; % calculate mean and std 
std_SMA_post_Glx_water_SMA_idx_outlier_corr = nanstd(SMA_post_Glx_water_SMA_idx) ;

for x = 1:size(SMA_pre_post_Glx_water_outlier_corr_SMA_idx,1)
    plot(xaxis_time,SMA_pre_post_Glx_water_outlier_corr_SMA_idx(x,:),'*-k') ;
    hold on;
end

title('SMA Glx/H2O following SMA rTMS, outliers removed')
xlabel('Time') ;
ylabel('SMA Glx/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_SMA_Glx_water_sma_idx = errorbar(xaxis_group,[mean_SMA_pre_Glx_water_SMA_idx_outlier_corr,mean_SMA_post_Glx_water_SMA_idx_outlier_corr,],[std_SMA_pre_Glx_water_SMA_idx_outlier_corr,std_SMA_post_Glx_water_SMA_idx_outlier_corr]) ;
set(ebar_SMA_Glx_water_sma_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% HP pre and post Glx/water
subplot(2,3,6)

HP_pre_Glx_water_SMA_idx = corr_output_Glx.HP_pre_Glx_water(idx_sma) ; 
HP_post_Glx_water_SMA_idx = corr_output_Glx.HP_post_Glx_water(idx_sma) ; 

outlier_high_cutoff_HP_pre_Glx_water_SMA_idx = nanmean(HP_pre_Glx_water_SMA_idx) + (2.5*nanstd(HP_pre_Glx_water_SMA_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_HP_pre_Glx_water_SMA_idx = nanmean(HP_pre_Glx_water_SMA_idx) - (2.5*nanstd(HP_pre_Glx_water_SMA_idx)) ;

outlier_high_cutoff_HP_post_Glx_water_SMA_idx = nanmean(HP_post_Glx_water_SMA_idx) + (2.5*nanstd(HP_post_Glx_water_SMA_idx)) ;
outlier_low_cutoff_HP_post_Glx_water_SMA_idx = nanmean(HP_post_Glx_water_SMA_idx) - (2.5*nanstd(HP_post_Glx_water_SMA_idx)) ;

HP_pre_Glx_water_outlier_log_SMA_idx = (HP_pre_Glx_water_SMA_idx < outlier_low_cutoff_HP_pre_Glx_water_SMA_idx) | (HP_pre_Glx_water_SMA_idx > outlier_high_cutoff_HP_pre_Glx_water_SMA_idx) ; % log index of outlier values
HP_post_Glx_water_outlier_log_SMA_idx = (HP_post_Glx_water_SMA_idx < outlier_low_cutoff_HP_post_Glx_water_SMA_idx) | (HP_post_Glx_water_SMA_idx > outlier_high_cutoff_HP_post_Glx_water_SMA_idx) ;

HP_pre_Glx_water_SMA_idx(HP_pre_Glx_water_outlier_log_SMA_idx == 1) = NaN; % replace outliers with NaNs 
HP_post_Glx_water_SMA_idx(HP_post_Glx_water_outlier_log_SMA_idx == 1) = NaN; 

HP_pre_post_Glx_water_outlier_corr_SMA_idx = [HP_pre_Glx_water_SMA_idx,HP_post_Glx_water_SMA_idx] ; 

% errorbar variables
mean_HP_pre_Glx_water_SMA_idx_outlier_corr = nanmean(HP_pre_Glx_water_SMA_idx) ; % calculate mean and std
std_HP_pre_Glx_water_SMA_idx_outlier_corr = nanstd(HP_pre_Glx_water_SMA_idx) ;  

mean_HP_post_Glx_water_SMA_idx_outlier_corr = nanmean(HP_post_Glx_water_SMA_idx) ; % calculate mean and std 
std_HP_post_Glx_water_SMA_idx_outlier_corr = nanstd(HP_post_Glx_water_SMA_idx) ;

for x = 1:size(HP_pre_post_Glx_water_outlier_corr_SMA_idx,1)
    plot(xaxis_time,HP_pre_post_Glx_water_outlier_corr_SMA_idx(x,:),'*-k') ;
    hold on;
end

title('HP Glx/H2O following SMA rTMS, outliers removed')
xlabel('Time') ;
ylabel('HP Glx/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_HP_Glx_water_sma_idx = errorbar(xaxis_group,[mean_HP_pre_Glx_water_SMA_idx_outlier_corr,mean_HP_post_Glx_water_SMA_idx_outlier_corr,],[std_HP_pre_Glx_water_SMA_idx_outlier_corr,std_HP_post_Glx_water_SMA_idx_outlier_corr]) ;
set(ebar_HP_Glx_water_sma_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')


%%%%%%% Glx/CR %%%%%%%%%%

figure('color','w') ;

%PTL group - participants who received PTL rTMS

% PTL pre and post Glx/cr
subplot(2,3,1)

PTL_pre_Glx_cr_PTL_idx = corr_output_Glx.PTL_pre_Glx_cr(idx_ptl) ; 
PTL_post_Glx_cr_PTL_idx = corr_output_Glx.PTL_post_Glx_cr(idx_ptl) ; 

outlier_high_cutoff_PTL_pre_Glx_cr_PTL_idx = nanmean(PTL_pre_Glx_cr_PTL_idx) + (2.5*nanstd(PTL_pre_Glx_cr_PTL_idx)) ; % Define outliers as +- 2.5 std outside time point mean
outlier_low_cutoff_PTL_pre_Glx_cr_PTL_idx = nanmean(PTL_pre_Glx_cr_PTL_idx) - (2.5*nanstd(PTL_pre_Glx_cr_PTL_idx)) ;

outlier_high_cutoff_PTL_post_Glx_cr_PTL_idx = nanmean(PTL_post_Glx_cr_PTL_idx) + (2.5*nanstd(PTL_post_Glx_cr_PTL_idx)) ;
outlier_low_cutoff_PTL_post_Glx_cr_PTL_idx = nanmean(PTL_post_Glx_cr_PTL_idx) - (2.5*nanstd(PTL_post_Glx_cr_PTL_idx)) ;

PTL_pre_Glx_cr_outlier_log_PTL_idx = (PTL_pre_Glx_cr_PTL_idx < outlier_low_cutoff_PTL_pre_Glx_cr_PTL_idx) | (PTL_pre_Glx_cr_PTL_idx > outlier_high_cutoff_PTL_pre_Glx_cr_PTL_idx) ; % log index of outlier values
PTL_post_Glx_cr_outlier_log_PTL_idx = (PTL_post_Glx_cr_PTL_idx < outlier_low_cutoff_PTL_post_Glx_cr_PTL_idx) | (PTL_post_Glx_cr_PTL_idx > outlier_high_cutoff_PTL_post_Glx_cr_PTL_idx) ;

PTL_pre_Glx_cr_PTL_idx(PTL_pre_Glx_cr_outlier_log_PTL_idx == 1) = NaN; % replace outliers with NaNs 
PTL_post_Glx_cr_PTL_idx(PTL_post_Glx_cr_outlier_log_PTL_idx == 1) = NaN; 

PTL_pre_post_Glx_cr_outlier_corr_PTL_idx = [PTL_pre_Glx_cr_PTL_idx,PTL_post_Glx_cr_PTL_idx] ; 

% errorbar variables
mean_PTL_pre_Glx_cr_PTL_idx_outlier_corr = nanmean(PTL_pre_Glx_cr_PTL_idx) ; % calculate mean and std
std_PTL_pre_Glx_cr_PTL_idx_outlier_corr = nanstd(PTL_pre_Glx_cr_PTL_idx) ;  

mean_PTL_post_Glx_cr_PTL_idx_outlier_corr = nanmean(PTL_post_Glx_cr_PTL_idx) ; % calculate mean and std 
std_PTL_post_Glx_cr_PTL_idx_outlier_corr = nanstd(PTL_post_Glx_cr_PTL_idx) ;

for x = 1:size(PTL_pre_post_Glx_cr_outlier_corr_PTL_idx,1)
    plot(xaxis_time,PTL_pre_post_Glx_cr_outlier_corr_PTL_idx(x,:),'*-k') ;
    hold on;
end

title('PTL Glx/cr following PTL rTMS, outliers removed')
xlabel('Time') ;
ylabel('PTL Glx/cr') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_PTL_Glx_cr_ptl_idx = errorbar(xaxis_group,[mean_PTL_pre_Glx_cr_PTL_idx_outlier_corr,mean_PTL_post_Glx_cr_PTL_idx_outlier_corr,],[std_PTL_pre_Glx_cr_PTL_idx_outlier_corr,std_PTL_post_Glx_cr_PTL_idx_outlier_corr]) ;
set(ebar_PTL_Glx_cr_ptl_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% SMA pre and post Glx/cr
subplot(2,3,2)

SMA_pre_Glx_cr_PTL_idx = corr_output_Glx.SMA_pre_Glx_cr(idx_ptl) ; 
SMA_post_Glx_cr_PTL_idx = corr_output_Glx.SMA_post_Glx_cr(idx_ptl) ; 

outlier_high_cutoff_SMA_pre_Glx_cr_PTL_idx = nanmean(SMA_pre_Glx_cr_PTL_idx) + (2.5*nanstd(SMA_pre_Glx_cr_PTL_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_SMA_pre_Glx_cr_PTL_idx = nanmean(SMA_pre_Glx_cr_PTL_idx) - (2.5*nanstd(SMA_pre_Glx_cr_PTL_idx)) ;

outlier_high_cutoff_SMA_post_Glx_cr_PTL_idx = nanmean(SMA_post_Glx_cr_PTL_idx) + (2.5*nanstd(SMA_post_Glx_cr_PTL_idx)) ;
outlier_low_cutoff_SMA_post_Glx_cr_PTL_idx = nanmean(SMA_post_Glx_cr_PTL_idx) - (2.5*nanstd(SMA_post_Glx_cr_PTL_idx)) ;

SMA_pre_Glx_cr_outlier_log_PTL_idx = (SMA_pre_Glx_cr_PTL_idx < outlier_low_cutoff_SMA_pre_Glx_cr_PTL_idx) | (SMA_pre_Glx_cr_PTL_idx > outlier_high_cutoff_SMA_pre_Glx_cr_PTL_idx) ; % log index of outlier values
SMA_post_Glx_cr_outlier_log_PTL_idx = (SMA_post_Glx_cr_PTL_idx < outlier_low_cutoff_SMA_post_Glx_cr_PTL_idx) | (SMA_post_Glx_cr_PTL_idx > outlier_high_cutoff_SMA_post_Glx_cr_PTL_idx) ;

SMA_pre_Glx_cr_PTL_idx(SMA_pre_Glx_cr_outlier_log_PTL_idx == 1) = NaN; % replace outliers with NaNs 
SMA_post_Glx_cr_PTL_idx(SMA_post_Glx_cr_outlier_log_PTL_idx == 1) = NaN; 

SMA_pre_post_Glx_cr_outlier_corr_PTL_idx = [SMA_pre_Glx_cr_PTL_idx,SMA_post_Glx_cr_PTL_idx] ; 

% errorbar variables
mean_SMA_pre_Glx_cr_PTL_idx_outlier_corr = nanmean(SMA_pre_Glx_cr_PTL_idx) ; % calculate mean and std
std_SMA_pre_Glx_cr_PTL_idx_outlier_corr = nanstd(SMA_pre_Glx_cr_PTL_idx) ;  

mean_SMA_post_Glx_cr_PTL_idx_outlier_corr = nanmean(SMA_post_Glx_cr_PTL_idx) ; % calculate mean and std 
std_SMA_post_Glx_cr_PTL_idx_outlier_corr = nanstd(SMA_post_Glx_cr_PTL_idx) ;

for x = 1:size(SMA_pre_post_Glx_cr_outlier_corr_PTL_idx,1)
    plot(xaxis_time,SMA_pre_post_Glx_cr_outlier_corr_PTL_idx(x,:),'*-k') ;
    hold on;
end

title('SMA Glx/cr following PTL rTMS, outliers removed')
xlabel('Time') ;
ylabel('SMA Glx/cr') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_SMA_Glx_cr_ptl_idx = errorbar(xaxis_group,[mean_SMA_pre_Glx_cr_PTL_idx_outlier_corr,mean_SMA_post_Glx_cr_PTL_idx_outlier_corr,],[std_SMA_pre_Glx_cr_PTL_idx_outlier_corr,std_SMA_post_Glx_cr_PTL_idx_outlier_corr]) ;
set(ebar_SMA_Glx_cr_ptl_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% HP pre and post Glx/cr
subplot(2,3,3)

HP_pre_Glx_cr_PTL_idx = corr_output_Glx.HP_pre_Glx_cr(idx_ptl) ; 
HP_post_Glx_cr_PTL_idx = corr_output_Glx.HP_post_Glx_cr(idx_ptl) ; 

outlier_high_cutoff_HP_pre_Glx_cr_PTL_idx = nanmean(HP_pre_Glx_cr_PTL_idx) + (2.5*nanstd(HP_pre_Glx_cr_PTL_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_HP_pre_Glx_cr_PTL_idx = nanmean(HP_pre_Glx_cr_PTL_idx) - (2.5*nanstd(HP_pre_Glx_cr_PTL_idx)) ;

outlier_high_cutoff_HP_post_Glx_cr_PTL_idx = nanmean(HP_post_Glx_cr_PTL_idx) + (2.5*nanstd(HP_post_Glx_cr_PTL_idx)) ;
outlier_low_cutoff_HP_post_Glx_cr_PTL_idx = nanmean(HP_post_Glx_cr_PTL_idx) - (2.5*nanstd(HP_post_Glx_cr_PTL_idx)) ;

HP_pre_Glx_cr_outlier_log_PTL_idx = (HP_pre_Glx_cr_PTL_idx < outlier_low_cutoff_HP_pre_Glx_cr_PTL_idx) | (HP_pre_Glx_cr_PTL_idx > outlier_high_cutoff_HP_pre_Glx_cr_PTL_idx) ; % log index of outlier values
HP_post_Glx_cr_outlier_log_PTL_idx = (HP_post_Glx_cr_PTL_idx < outlier_low_cutoff_HP_post_Glx_cr_PTL_idx) | (HP_post_Glx_cr_PTL_idx > outlier_high_cutoff_HP_post_Glx_cr_PTL_idx) ;

HP_pre_Glx_cr_PTL_idx(HP_pre_Glx_cr_outlier_log_PTL_idx == 1) = NaN; % replace outliers with NaNs 
HP_post_Glx_cr_PTL_idx(HP_post_Glx_cr_outlier_log_PTL_idx == 1) = NaN; 

HP_pre_post_Glx_cr_outlier_corr_PTL_idx = [HP_pre_Glx_cr_PTL_idx,HP_post_Glx_cr_PTL_idx] ; 

% errorbar variables
mean_HP_pre_Glx_cr_PTL_idx_outlier_corr = nanmean(HP_pre_Glx_cr_PTL_idx) ; % calculate mean and std
std_HP_pre_Glx_cr_PTL_idx_outlier_corr = nanstd(HP_pre_Glx_cr_PTL_idx) ;  

mean_HP_post_Glx_cr_PTL_idx_outlier_corr = nanmean(HP_post_Glx_cr_PTL_idx) ; % calculate mean and std 
std_HP_post_Glx_cr_PTL_idx_outlier_corr = nanstd(HP_post_Glx_cr_PTL_idx) ;

for x = 1:size(HP_pre_post_Glx_cr_outlier_corr_PTL_idx,1)
    plot(xaxis_time,HP_pre_post_Glx_cr_outlier_corr_PTL_idx(x,:),'*-k') ;
    hold on;
end

title('HP Glx/cr following PTL rTMS, outliers removed')
xlabel('Time') ;
ylabel('HP Glx/cr') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_HP_Glx_cr_ptl_idx = errorbar(xaxis_group,[mean_HP_pre_Glx_cr_PTL_idx_outlier_corr,mean_HP_post_Glx_cr_PTL_idx_outlier_corr,],[std_HP_pre_Glx_cr_PTL_idx_outlier_corr,std_HP_post_Glx_cr_PTL_idx_outlier_corr]) ;
set(ebar_HP_Glx_cr_ptl_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

%SMA group - participants who received PTL rTMS

% PTL pre and post Glx/cr
subplot(2,3,4)

PTL_pre_Glx_cr_SMA_idx = corr_output_Glx.PTL_pre_Glx_cr(idx_sma) ; 
PTL_post_Glx_cr_SMA_idx = corr_output_Glx.PTL_post_Glx_cr(idx_sma) ; 

outlier_high_cutoff_PTL_pre_Glx_cr_SMA_idx = nanmean(PTL_pre_Glx_cr_SMA_idx) + (2.5*nanstd(PTL_pre_Glx_cr_SMA_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_PTL_pre_Glx_cr_SMA_idx = nanmean(PTL_pre_Glx_cr_SMA_idx) - (2.5*nanstd(PTL_pre_Glx_cr_SMA_idx)) ;

outlier_high_cutoff_PTL_post_Glx_cr_SMA_idx = nanmean(PTL_post_Glx_cr_SMA_idx) + (2.5*nanstd(PTL_post_Glx_cr_SMA_idx)) ;
outlier_low_cutoff_PTL_post_Glx_cr_SMA_idx = nanmean(PTL_post_Glx_cr_SMA_idx) - (2.5*nanstd(PTL_post_Glx_cr_SMA_idx)) ;

PTL_pre_Glx_cr_outlier_log_SMA_idx = (PTL_pre_Glx_cr_SMA_idx < outlier_low_cutoff_PTL_pre_Glx_cr_SMA_idx) | (PTL_pre_Glx_cr_SMA_idx > outlier_high_cutoff_PTL_pre_Glx_cr_SMA_idx) ; % log index of outlier values
PTL_post_Glx_cr_outlier_log_SMA_idx = (PTL_post_Glx_cr_SMA_idx < outlier_low_cutoff_PTL_post_Glx_cr_SMA_idx) | (PTL_post_Glx_cr_SMA_idx > outlier_high_cutoff_PTL_post_Glx_cr_SMA_idx) ;

PTL_pre_Glx_cr_SMA_idx(PTL_pre_Glx_cr_outlier_log_SMA_idx == 1) = NaN; % replace outliers with NaNs 
PTL_post_Glx_cr_SMA_idx(PTL_post_Glx_cr_outlier_log_SMA_idx == 1) = NaN; 

PTL_pre_post_Glx_cr_outlier_corr_SMA_idx = [PTL_pre_Glx_cr_SMA_idx,PTL_post_Glx_cr_SMA_idx] ; 

% errorbar variables
mean_PTL_pre_Glx_cr_SMA_idx_outlier_corr = nanmean(PTL_pre_Glx_cr_SMA_idx) ; % calculate mean and std
std_PTL_pre_Glx_cr_SMA_idx_outlier_corr = nanstd(PTL_pre_Glx_cr_SMA_idx) ;  

mean_PTL_post_Glx_cr_SMA_idx_outlier_corr = nanmean(PTL_post_Glx_cr_SMA_idx) ; % calculate mean and std 
std_PTL_post_Glx_cr_SMA_idx_outlier_corr = nanstd(PTL_post_Glx_cr_SMA_idx) ;

for x = 1:size(PTL_pre_post_Glx_cr_outlier_corr_SMA_idx,1)
    plot(xaxis_time,PTL_pre_post_Glx_cr_outlier_corr_SMA_idx(x,:),'*-k') ;
    hold on;
end

title('PTL Glx/cr following SMA rTMS, outliers removed')
xlabel('Time') ;
ylabel('PTL Glx/cr') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_PTL_Glx_cr_sma_idx = errorbar(xaxis_group,[mean_PTL_pre_Glx_cr_SMA_idx_outlier_corr,mean_PTL_post_Glx_cr_SMA_idx_outlier_corr,],[std_PTL_pre_Glx_cr_SMA_idx_outlier_corr,std_PTL_post_Glx_cr_SMA_idx_outlier_corr]) ;
set(ebar_PTL_Glx_cr_sma_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% SMA pre and post Glx/water
subplot(2,3,5)

SMA_pre_Glx_cr_SMA_idx = corr_output_Glx.SMA_pre_Glx_cr(idx_sma) ; 
SMA_post_Glx_cr_SMA_idx = corr_output_Glx.SMA_post_Glx_cr(idx_sma) ; 

outlier_high_cutoff_SMA_pre_Glx_cr_SMA_idx = nanmean(SMA_pre_Glx_cr_SMA_idx) + (2.5*nanstd(SMA_pre_Glx_cr_SMA_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_SMA_pre_Glx_cr_SMA_idx = nanmean(SMA_pre_Glx_cr_SMA_idx) - (2.5*nanstd(SMA_pre_Glx_cr_SMA_idx)) ;

outlier_high_cutoff_SMA_post_Glx_cr_SMA_idx = nanmean(SMA_post_Glx_cr_SMA_idx) + (2.5*nanstd(SMA_post_Glx_cr_SMA_idx)) ;
outlier_low_cutoff_SMA_post_Glx_cr_SMA_idx = nanmean(SMA_post_Glx_cr_SMA_idx) - (2.5*nanstd(SMA_post_Glx_cr_SMA_idx)) ;

SMA_pre_Glx_cr_outlier_log_SMA_idx = (SMA_pre_Glx_cr_SMA_idx < outlier_low_cutoff_SMA_pre_Glx_cr_SMA_idx) | (SMA_pre_Glx_cr_SMA_idx > outlier_high_cutoff_SMA_pre_Glx_cr_SMA_idx) ; % log index of outlier values
SMA_post_Glx_cr_outlier_log_SMA_idx = (SMA_post_Glx_cr_SMA_idx < outlier_low_cutoff_SMA_post_Glx_cr_SMA_idx) | (SMA_post_Glx_cr_SMA_idx > outlier_high_cutoff_SMA_post_Glx_cr_SMA_idx) ;

SMA_pre_Glx_cr_SMA_idx(SMA_pre_Glx_cr_outlier_log_SMA_idx == 1) = NaN; % replace outliers with NaNs 
SMA_post_Glx_cr_SMA_idx(SMA_post_Glx_cr_outlier_log_SMA_idx == 1) = NaN; 

SMA_pre_post_Glx_cr_outlier_corr_SMA_idx = [SMA_pre_Glx_cr_SMA_idx,SMA_post_Glx_cr_SMA_idx] ; 

% errorbar variables
mean_SMA_pre_Glx_cr_SMA_idx_outlier_corr = nanmean(SMA_pre_Glx_cr_SMA_idx) ; % calculate mean and std
std_SMA_pre_Glx_cr_SMA_idx_outlier_corr = nanstd(SMA_pre_Glx_cr_SMA_idx) ;  

mean_SMA_post_Glx_cr_SMA_idx_outlier_corr = nanmean(SMA_post_Glx_cr_SMA_idx) ; % calculate mean and std 
std_SMA_post_Glx_cr_SMA_idx_outlier_corr = nanstd(SMA_post_Glx_cr_SMA_idx) ;

for x = 1:size(SMA_pre_post_Glx_cr_outlier_corr_SMA_idx,1)
    plot(xaxis_time,SMA_pre_post_Glx_cr_outlier_corr_SMA_idx(x,:),'*-k') ;
    hold on;
end

title('SMA Glx/cr following SMA rTMS, outliers removed')
xlabel('Time') ;
ylabel('SMA Glx/cr') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_SMA_Glx_cr_sma_idx = errorbar(xaxis_group,[mean_SMA_pre_Glx_cr_SMA_idx_outlier_corr,mean_SMA_post_Glx_cr_SMA_idx_outlier_corr,],[std_SMA_pre_Glx_cr_SMA_idx_outlier_corr,std_SMA_post_Glx_cr_SMA_idx_outlier_corr]) ;
set(ebar_SMA_Glx_cr_sma_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

% HP pre and post Glx/water
subplot(2,3,6)

HP_pre_Glx_cr_SMA_idx = corr_output_Glx.HP_pre_Glx_cr(idx_sma) ; 
HP_post_Glx_cr_SMA_idx = corr_output_Glx.HP_post_Glx_cr(idx_sma) ; 

outlier_high_cutoff_HP_pre_Glx_cr_SMA_idx = nanmean(HP_pre_Glx_cr_SMA_idx) + (2.5*nanstd(HP_pre_Glx_cr_SMA_idx)) ; % Define outliers as +- 2.5 std outside time point mean 
outlier_low_cutoff_HP_pre_Glx_cr_SMA_idx = nanmean(HP_pre_Glx_cr_SMA_idx) - (2.5*nanstd(HP_pre_Glx_cr_SMA_idx)) ;

outlier_high_cutoff_HP_post_Glx_cr_SMA_idx = nanmean(HP_post_Glx_cr_SMA_idx) + (2.5*nanstd(HP_post_Glx_cr_SMA_idx)) ;
outlier_low_cutoff_HP_post_Glx_cr_SMA_idx = nanmean(HP_post_Glx_cr_SMA_idx) - (2.5*nanstd(HP_post_Glx_cr_SMA_idx)) ;

HP_pre_Glx_cr_outlier_log_SMA_idx = (HP_pre_Glx_cr_SMA_idx < outlier_low_cutoff_HP_pre_Glx_cr_SMA_idx) | (HP_pre_Glx_cr_SMA_idx > outlier_high_cutoff_HP_pre_Glx_cr_SMA_idx) ; % log index of outlier values
HP_post_Glx_cr_outlier_log_SMA_idx = (HP_post_Glx_cr_SMA_idx < outlier_low_cutoff_HP_post_Glx_cr_SMA_idx) | (HP_post_Glx_cr_SMA_idx > outlier_high_cutoff_HP_post_Glx_cr_SMA_idx) ;

HP_pre_Glx_cr_SMA_idx(HP_pre_Glx_cr_outlier_log_SMA_idx == 1) = NaN; % replace outliers with NaNs 
HP_post_Glx_cr_SMA_idx(HP_post_Glx_cr_outlier_log_SMA_idx == 1) = NaN; 

HP_pre_post_Glx_cr_outlier_corr_SMA_idx = [HP_pre_Glx_cr_SMA_idx,HP_post_Glx_cr_SMA_idx] ; 

% errorbar variables
mean_HP_pre_Glx_cr_SMA_idx_outlier_corr = nanmean(HP_pre_Glx_cr_SMA_idx) ; % calculate mean and std
std_HP_pre_Glx_cr_SMA_idx_outlier_corr = nanstd(HP_pre_Glx_cr_SMA_idx) ;  

mean_HP_post_Glx_cr_SMA_idx_outlier_corr = nanmean(HP_post_Glx_cr_SMA_idx) ; % calculate mean and std 
std_HP_post_Glx_cr_SMA_idx_outlier_corr = nanstd(HP_post_Glx_cr_SMA_idx) ;

for x = 1:size(HP_pre_post_Glx_cr_outlier_corr_SMA_idx,1)
    plot(xaxis_time,HP_pre_post_Glx_cr_outlier_corr_SMA_idx(x,:),'*-k') ;
    hold on;
end

title('HP Glx/cr following SMA rTMS, outliers removed')
xlabel('Time') ;
ylabel('HP Glx/cr') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

ebar_HP_Glx_cr_sma_idx = errorbar(xaxis_group,[mean_HP_pre_Glx_cr_SMA_idx_outlier_corr,mean_HP_post_Glx_cr_SMA_idx_outlier_corr,],[std_HP_pre_Glx_cr_SMA_idx_outlier_corr,std_HP_post_Glx_cr_SMA_idx_outlier_corr]) ;
set(ebar_HP_Glx_cr_sma_idx,'Marker','s','LineWidth',0.5,'MarkerSize',20,'Color','k')

%% Save outputs

save('Glx_MRS_output.mat','uncorr_output_Glx','corr_output_Glx','Glx_QC','Data_vox_partial_vol') ; % save .mat file
writetable(corr_output_Glx,'Glx_vol_corrected_values_output.txt','Delimiter','\t','WriteRowNames',true) ; % save Glx volume corrected table as .txt file
writetable(corr_output_Glx,'Glx_vol_corrected_values_output.xlsx','WriteRowNames',true) ; % save Glx volume corrected table as .xlsx file
writetable(Glx_QC,'Glx_QC.txt','Delimiter','\t','WriteRowNames',true) ; % save Glx QC metric table as .txt file
writetable(Glx_QC,'Glx_QC.xlsx','WriteRowNames',true); % save Glx QC metric table as .xlsx file
movefile('Glx_MRS_output.mat',pathIn)
movefile('Glx_vol_corrected_values_output.txt',pathIn) ;
movefile('Glx_vol_corrected_values_output.xlsx',pathIn) ;
movefile('Glx_QC.txt',pathIn) ; 
movefile('Glx_QC.xlsx',pathIn) ;