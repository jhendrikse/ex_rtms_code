clear; close all; clc;

% This script returns the ssrt according to both integration and mean calculation methods for the
% ICAB stop-signal task. The output is structured for within-subject
% comparison of stimulation conditions for ex_rTMS sample.  

ID = {'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'};

active = char({'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S16_YS';'S17_JTR';'S19_JA';'S20_WO';'S22_NS';'S25_SC';'S27_ANW';'S33_DJG';'S34_ST';'S35_TG';'S36_AY'}) ;

sedentary = char({'S7_PK';'S13_MD';'S15_AZ';'S21_KC';'S24_AU';'S26_KW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'}) ;

timePoint = {'pre';'post';'follow_up'};

pathIn = '/Volumes/Lacie/Ex_rTMS_study/Data';

Condition = {'llpc';'sma'};

for x = 1:length(ID)
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
            filename_sst = [char(pathIn),'/all_subjects/',char(ID(x,1)),'/Cognitive/',char(Condition(y,1)),'/sst/',char(timePoint(z,1)),'/',char(ID(x,1)),'_',char(timePoint(z,1)),'.dat'];
            
            [ssrt_integration(x,z,y),ssrt_mean(x,z,y)] = sst_master(filename_sst); %% stores output as 40 X 3 X 2 matrix. 
        end
    end
   
end

% Separate timepoints and conditions for entry into table

% learning score llpc
ssrt_integration_pre_llpc = ssrt_integration(:,1,1) ;
ssrt_integration_post_llpc = ssrt_integration(:,2,1) ;
ssrt_integration_follow_up_llpc = ssrt_integration(:,3,1) ;

% learning score sma
ssrt_integration_pre_sma = ssrt_integration(:,1,2) ;
ssrt_integration_post_sma = ssrt_integration(:,2,2) ;
ssrt_integration_follow_up_sma = ssrt_integration(:,3,2) ;

% Dummy variable to encode PA group (1 = active, 2 = sedentary)
activity_group = [1;1;1;1;1;2;1;1;1;1;2;2;1;1;2;1;1;2;1;2;1;2;1;2;2;2;2;2;1;1;1;1;2;2;2;2;2;2;2;2] ; 

Dataset_sst_all_subjects = table(ID,activity_group,ssrt_integration_pre_llpc,ssrt_integration_post_llpc,ssrt_integration_follow_up_llpc,ssrt_integration_pre_sma,ssrt_integration_post_sma,ssrt_integration_follow_up_sma) ; 

save('sst_output_cross_over.mat','Dataset_sst_all_subjects') 
writetable(Dataset_sst_all_subjects,'Dataset_sst_all_subjects.xlsx','WriteRowNames',true) ;
movefile sst_output_cross_over.mat /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;
movefile Dataset_sst_all_subjects.xlsx /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;