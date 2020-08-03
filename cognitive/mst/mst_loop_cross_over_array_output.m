
% This script returns the main outcome variables from the MST task. The
% script is set up to loop over participants from ex_rtms study sample. 

clear; close all; clc; 

addpath(genpath('/Volumes/LaCie/Ex_rTMS_study/ex_rtms_code/cognitive/mst')) ; 
addpath(genpath('/Volumes/Lacie/Ex_rTMS_study/Data/all_subjects')) ;

ID = {'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'} ;

% Dummy variable to encode PA group (1 = active, 2 = sedentary)
activity_group = [1;1;1;1;1;2;1;1;1;1;2;2;1;1;2;1;1;2;1;2;1;2;1;2;2;2;2;2;1;1;1;1;2;2;2;2;2;2;2;2] ; 

timePoint = {'pre';'post';'follow_up'};

pathIn = '/Volumes/Lacie/Ex_rTMS_study/Data';

Condition = {'llpc';'sma'};

bias_metric = cell(40,3,2) ;

percent_corr = cell(40,3,2) ;

for x = 1:length(ID)
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
            if exist(([char(pathIn),'/all_subjects/',char(ID(x,1)),'/Cognitive/',char(Condition(y,1)),'/mst/',char(timePoint(z,1)),'/',char(ID(x,1)),'_',char(timePoint(z,1)),'.xlsx']),'file') == 2 
               
                filename_mst = [char(pathIn),'/all_subjects/',char(ID(x,1)),'/Cognitive/',char(Condition(y,1)),'/mst/',char(timePoint(z,1)),'/',char(ID(x,1)),'_',char(timePoint(z,1)),'.xlsx'] ;
               
                [bias_metric(x,z,y),percent_corr(x,z,y)] = mst_master(filename_mst) ; %% stores output as 40 X 3 X 2 matrix.
            
            else
                bias_metric(x,z,y) = {NaN} ;
                percent_corr(x,z,y) = {NaN} ;
            end
        end
    end
   
end

% Separate timepoints and conditions for entry into table

% bias llpc
bias_pre_llpc = bias_metric(:,1,1) ;
bias_post_llpc = bias_metric(:,2,1) ;
bias_follow_up_llpc = bias_metric(:,3,1) ;

delta_pre_post_bias_llpc = ((str2double(bias_post_llpc)) - (str2double(bias_pre_llpc))) ./ (str2double(bias_pre_llpc)) ;
delta_pre_follow_up_bias_llpc = ((str2double(bias_follow_up_llpc)) - (str2double(bias_pre_llpc))) ./ (str2double(bias_pre_llpc)) ;

% bias metric sma
bias_pre_sma = bias_metric(:,1,2) ;
bias_post_sma = bias_metric(:,2,2) ;
bias_follow_up_sma = bias_metric(:,3,2) ; 

delta_pre_post_bias_sma = ((str2double(bias_post_sma)) - (str2double(bias_pre_sma))) ./ (str2double(bias_pre_sma)) ;
delta_pre_follow_up_bias_sma = ((str2double(bias_follow_up_sma)) - (str2double(bias_pre_sma))) ./ (str2double(bias_pre_sma)) ;

% percent correct llpc
percent_corr_pre_llpc = percent_corr(:,1,1) ;
percent_corr_post_llpc = percent_corr(:,2,1) ;
percent_corr_follow_up_llpc = percent_corr(:,3,1) ;

delta_pre_post_percent_corr_llpc = ((str2double(percent_corr_post_llpc)) - (str2double(percent_corr_pre_llpc))) ./ (str2double(percent_corr_pre_llpc)) ;
delta_pre_follow_up_percent_corr_llpc = ((str2double(percent_corr_follow_up_llpc)) - (str2double(percent_corr_pre_llpc))) ./ (str2double(percent_corr_pre_llpc)) ;

% percent correct sma
percent_corr_pre_sma = percent_corr(:,1,2) ;
percent_corr_post_sma = percent_corr(:,2,2) ;
percent_corr_follow_up_sma = percent_corr(:,3,2) ;

delta_pre_post_percent_corr_sma = ((str2double(percent_corr_post_sma)) - (str2double(percent_corr_pre_sma))) ./ (str2double(percent_corr_pre_sma)) ;
delta_pre_follow_up_percent_corr_sma = ((str2double(percent_corr_follow_up_sma)) - (str2double(percent_corr_pre_sma))) ./ (str2double(percent_corr_pre_sma)) ;

Dataset_mst_all_subjects = table(ID,activity_group,bias_pre_llpc,bias_post_llpc,bias_follow_up_llpc,bias_pre_sma,bias_post_sma,bias_follow_up_sma,percent_corr_pre_llpc,percent_corr_post_llpc,percent_corr_follow_up_llpc,percent_corr_pre_sma,percent_corr_post_sma,percent_corr_follow_up_sma,delta_pre_post_bias_llpc,delta_pre_post_bias_sma,delta_pre_follow_up_bias_llpc,delta_pre_follow_up_bias_sma,delta_pre_post_percent_corr_llpc,delta_pre_post_percent_corr_sma,delta_pre_follow_up_percent_corr_llpc,delta_pre_follow_up_percent_corr_sma) ; 

save('mst_output_cross_over.mat','Dataset_mst_all_subjects') 
writetable(Dataset_mst_all_subjects,'Dataset_mst_all_subjects.xlsx','WriteRowNames',true) ;
movefile mst_output_cross_over.mat /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;
movefile Dataset_mst_all_subjects.xlsx /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;
