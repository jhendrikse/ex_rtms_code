clear; close all; clc;
% This script runs a for loop to output the main outcome measures for the
% n-back task across the ex rTMS participant sample 

ActiveID = {'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S16_YS';'S17_JTR';'S19_JA';'S20_WO';'S22_NS';'S25_SC';'S27_ANW';'S33_DJG';'S34_ST';'S35_TG';'S36_AY'};

InactiveID = {'S7_PK';'S13_MD';'S15_AZ';'S18_KF';'S21_KC';'S24_AU';'S26_KW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'};

% Condition = {'wk1_llpc';'wk2_sma'} - This was replaced for pathIn_mod ln
% 19 - allowing use of wildcard for stimulation conditions 

timePoint = {'pre';'post';'follow_up'};

pathIn = '/Volumes/Lacie/Ex_rTMS_study/Data';

%%=======Loop over active subjects================

for x = 1:length(ActiveID)
    
    pathIn_mod = dir([char(pathIn),'/Active/',char(ActiveID(x,1)),'/Cognitive/','wk*']);
    
    Condition = {pathIn_mod(1).name; pathIn_mod(2).name}
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
            filename_nback = [char(pathIn),'/Active/',char(ActiveID(x,1)),'/Cognitive/',char(Condition(y,1)),'/n_back/',char(timePoint(z,1)),'/',char(ActiveID(x,1)),'_',char(timePoint(z,1)),'.xlsx']
            
            % filename = [pathIn,'/','Active','/',ActiveID(x,1),'/','Cognitive','/',Condition(y,1),'/','SST','/',timePoint(z,1),'/','SST_',ActiveID(x,1),'_',timePoint(z,1),'.dat'] 
            
            [hits(y,z),misses(y,z),fAlarm(y,z),hitsRT(y,z),dPrime(y,z)] = n_back_master(filename_nback);
        end
    end
end


%%======Loop over inactive subjects===============

for x = 1:length(InactiveID)
    
    pathIn_mod = dir([char(pathIn),'/Inactive/',char(InactiveID(x,1)),'/Cognitive/','wk*']);
       
    Condition = {pathIn_mod(1).name; pathIn_mod(2).name}
    
    for y = 1:length(Condition)
        
        for z = 1:lenght(timePoint)
            
            filename_nback = [char(pathIn),'/Inactive/',char(InactiveID(x,1)),'/Cognitive/',char(Condition(y,1)),'/n_back/',char(timePoint(z,1)),'/',char(InactiveID(x,1)),'_',char(timePoint(z,1)),'.xlsx']
           
            [hits(y,z),misses(y,z),fAlarm(y,z),hitsRT(y,z),dPrime(y,z)] = n_back_master(filename_nback);
        end
    end
end


%======Output cell================

