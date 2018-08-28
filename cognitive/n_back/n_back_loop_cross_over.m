clear; close all; clc;

% This script can be used to return the main outcome measures for the
% n-back task across the entire ex_rTMS participant sample pre-post wk1

ID = {'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'};

timePoint = {'pre';'post';'follow_up'};

pathIn = '/Volumes/Lacie/Ex_rTMS_study/Data';

for x = 1:length(ID)
   
    pathIn_mod = dir([char(pathIn),'/all_subjects/',char(ID(x,1)),'/Cognitive/','wk*']);
    
    Condition = {pathIn_mod(1).name;pathIn_mod(2).name};
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
            filename_nback = [char(pathIn),'/all_subjects/',char(ID(x,1)),'/Cognitive/',char(Condition(y,1)),'/n_back/',char(timePoint(z,1)),'/',char(ID(x,1)),'_',char(timePoint(z,1)),'.xlsx'];
            
            % filename = [pathIn,'/','Active','/',ActiveID(x,1),'/','Cognitive','/',Condition(y,1),'/','SST','/',timePoint(z,1),'/','SST_',ActiveID(x,1),'_',timePoint(z,1),'.dat'] 
            
            [Data.(ID{x}).(Condition{y}).hits(1,z),Data.(ID{x}).(Condition{y}).misses(1,z),Data.(ID{x}).(Condition{y}).fAlarm(1,z),Data.(ID{x}).(Condition{y}).hitsRT(1,z),Data.(ID{x}).(Condition{y}).dPrime(1,z)] = n_back_master(filename_nback);
            
        end
    end
   
 
end