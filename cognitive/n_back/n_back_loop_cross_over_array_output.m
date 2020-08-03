clear; close all; clc;

% This script can be used to return the main outcome measures for the
% n-back task across the entire ex_rTMS participant sample across both
% stimulation conditions

addpath(genpath('/Volumes/LaCie/Ex_rTMS_study/ex_rtms_code/cognitive/n_back')) ; 
addpath(genpath('/Volumes/Lacie/Ex_rTMS_study/Data/all_subjects')) ;

ID = {'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'};

% Dummy variable to encode PA group (1 = active, 2 = sedentary)
activity_group = [1;1;1;1;1;2;1;1;1;1;2;2;1;1;2;1;1;2;1;2;1;2;1;2;2;2;2;2;1;1;1;1;2;2;2;2;2;2;2;2] ; 

timePoint = {'pre';'post';'follow_up'};

pathIn = '/Volumes/Lacie/Ex_rTMS_study/Data';

Condition = {'llpc';'sma'};

for x = 1:length(ID)
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
            filename_nback = [char(pathIn),'/all_subjects/',char(ID(x,1)),'/Cognitive/',char(Condition(y,1)),'/n_back/',char(timePoint(z,1)),'/',char(ID(x,1)),'_',char(timePoint(z,1)),'.xlsx'];
            
            [hits(x,z,y),misses(x,z,y),fAlarm(x,z,y),hitsRT(x,z,y),dPrime(x,z,y)] = n_back_master(filename_nback); %% stores output as 40 X 3 X 2 matrix. 
            
        end
    end
   
end

% Separate timepoints and conditions for entry into table

% hitsRT llpc
hitsRT_pre_llpc = hitsRT(:,1,1) ;
hitsRT_post_llpc = hitsRT(:,2,1) ;
hitsRT_follow_up_llpc = hitsRT(:,3,1) ;

% hits RT sma
hitsRT_pre_sma = hitsRT(:,1,2) ;
hitsRT_post_sma = hitsRT(:,2,2) ;
hitsRT_follow_up_sma = hitsRT(:,3,2) ; 

% dPrime llpc 
dPrime_pre_llpc = dPrime(:,1,1) ; 
dPrime_post_llpc = dPrime(:,2,1) ; 
dPrime_follow_up_llpc = dPrime(:,3,1) ; 

% dPrime sma 
dPrime_pre_sma = dPrime(:,1,2) ; 
dPrime_post_sma = dPrime(:,2,2) ; 
dPrime_follow_up_sma = dPrime(:,3,2) ; 

Dataset_n_back_all_subjects = table(ID,activity_group,hitsRT_pre_llpc,hitsRT_post_llpc,hitsRT_follow_up_llpc,hitsRT_pre_sma,hitsRT_post_sma,hitsRT_follow_up_sma,dPrime_pre_llpc,dPrime_post_llpc,dPrime_follow_up_llpc,dPrime_pre_sma,dPrime_post_sma,dPrime_follow_up_sma) ; 

save('n_back_output_cross_over.mat','Dataset_n_back_all_subjects') 
writetable(Dataset_n_back_all_subjects,'Dataset_n_back_all_subjects.xlsx','WriteRowNames',true) ;
movefile n_back_output_cross_over.mat /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;
movefile Dataset_n_back_all_subjects.xlsx /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;
