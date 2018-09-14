clear, close all, clc;

% This script can be used to output the learning score from the
% serial reaction time task (SRTT). The output is structured for within-subject
% comparison of stimulation conditions for ex_rTMS sample.

ID = {'S2_MS';'S3_DJ';'S4_JM';'S5_RD';'S6_KV';'S7_PK';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S13_MD';'S15_AZ';'S16_YS';'S17_JTR';'S18_KF';'S19_JA';'S20_WO';'S21_KC';'S22_NS';'S24_AU';'S25_SC';'S26_KW';'S27_ANW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S33_DJG';'S34_ST';'S35_TG';'S36_AY';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'};

Condition = {'llpc';'sma'};

timePoint = {'pre';'post';'follow_up'};

pathIn = '/Volumes/LaCie/Ex_rTMS_study/Data' ;

for x = 1:length(ID)
    
    for y = 1:length(Condition)
        
        for z = 1:length(timePoint)
            
           filename_SRTT = [char(pathIn),'/all_subjects/',char(ID(x,1)),'/Cognitive/',char(Condition(y,1)),'/SRTT/',char(timePoint(z,1)),'/',char(ID(x,1)),'_',char(timePoint(z,1)),'.csv'];
           
           [mean_random_trial(x,z,y),mean_sequence_trial(x,z,y),learning_score(x,z,y)] = srtt_master(filename_SRTT)
           
        end
    end
end