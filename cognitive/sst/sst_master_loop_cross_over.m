clear; close all; clc;

% This script returns the ssrt according to both integration and mean calculation methods for the
% ICAB stop-signal task. The output is structured for within-subject
% comparison of stimulation conditions for ex_rTMS sample. 
% Joshua Hendrikse joshua.hendrikse@monash.edu

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
            
            %[~,~,~,~,~,ssrt_integration(x,z,y),ssrt_mean(x,z,y)] =
            %sst_master(filename_sst); %% stores only ssrt_integration,
            %ssrt_mean values (40 X 3 X 2 matrix). %uncomment if ssrt is
            %only desired output
            
            [mean_ex_gauss(x,z,y),sigma_ex_gauss(x,z,y),tau_ex_gauss(x,z,y),~,chiSquare(x,z,y),rt_go_omission_count(x,z,y),rt_go_commission_count(x,z,y),mean_rt_go(x,z,y),sd_rt_go(x,z,y),mean_rt_go_omission_replace(x,z,y),mean_ssd(x,z,y),ssd_range(x,z,y),mean_incorr_stop_trial_rt(x,z,y),race_model_assumption_met(x,z,y),p_respond_given_stop(x,y,z),ssrt_integration(x,z,y),ssrt_mean(x,z,y)] = sst_master(filename_sst); %% stores Exgauss parameters & ssrt_integration, ssrt_mean as 40 X 3 X 2 matrix.
        end
    end
end


%% Separate timepoints and conditions for entry into table %%%%%

%%%%% Ex Gauss %%%%%%%

% mean ex gauss llpc
mean_ex_gauss_pre_llpc = mean_ex_gauss(:,1,1) ;
mean_ex_gauss_post_llpc = mean_ex_gauss(:,2,1) ;
mean_ex_gauss_follow_up_llpc = mean_ex_gauss(:,3,1) ;

% mean ex gauss sma
mean_ex_gauss_pre_sma = mean_ex_gauss(:,1,2) ; 
mean_ex_gauss_post_sma = mean_ex_gauss(:,2,2) ; 
mean_ex_gauss_follow_up_sma = mean_ex_gauss(:,3,2) ; 

% sigma ex gauss llpc
sigma_ex_gauss_pre_llpc = sigma_ex_gauss(:,1,1) ;
sigma_ex_gauss_post_llpc = sigma_ex_gauss(:,2,1) ;
sigma_ex_gauss_follow_up_llpc = sigma_ex_gauss(:,3,1) ;

% sigma ex gauss sma
sigma_ex_gauss_pre_sma = sigma_ex_gauss(:,1,2) ; 
sigma_ex_gauss_post_sma = sigma_ex_gauss(:,2,2) ; 
sigma_ex_gauss_follow_up_sma = sigma_ex_gauss(:,3,2) ; 

% tau ex gauss llpc
tau_ex_gauss_pre_llpc = tau_ex_gauss(:,1,1) ;
tau_ex_gauss_post_llpc = tau_ex_gauss(:,2,1) ;
tau_ex_gauss_follow_up_llpc = tau_ex_gauss(:,3,1) ;

% tau ex gauss sma
tau_ex_gauss_pre_sma = tau_ex_gauss(:,1,2) ; 
tau_ex_gauss_post_sma = tau_ex_gauss(:,2,2) ; 
tau_ex_gauss_follow_up_sma = tau_ex_gauss(:,3,2) ; 

% Chi squared llpc
chiSquare_pre_llpc = chiSquare(:,1,1) ;
chiSquare_post_llpc = chiSquare(:,2,1) ;
chiSquare_follow_up_llpc = chiSquare(:,3,1) ;

% Chi squared sma
chiSquare_pre_sma = chiSquare(:,1,2) ; 
chiSquare_post_sma = chiSquare(:,2,2) ; 
chiSquare_follow_up_sma = chiSquare(:,3,2) ;

%%%%%%% RT parameters %%%%%%

% rt go omission count llpc
rt_go_omission_count_pre_llpc = rt_go_omission_count(:,1,1) ;
rt_go_omission_count_post_llpc = rt_go_omission_count(:,2,1) ;
rt_go_omission_count_follow_up_llpc = rt_go_omission_count(:,3,1) ;

% rt go omission count sma
rt_go_omission_count_pre_sma = rt_go_omission_count(:,1,2) ;
rt_go_omission_count_post_sma = rt_go_omission_count(:,2,2) ;
rt_go_omission_count_follow_up_sma = rt_go_omission_count(:,3,2) ;

% rt go commission count llpc
rt_go_commission_count_pre_llpc = rt_go_commission_count(:,1,1) ;
rt_go_commission_count_post_llpc = rt_go_commission_count(:,2,1) ;
rt_go_commission_count_follow_up_llpc = rt_go_commission_count(:,3,1) ;

% rt go comission count sma
rt_go_commission_count_pre_sma = rt_go_commission_count(:,1,2) ;
rt_go_commission_count_post_sma = rt_go_commission_count(:,2,2) ;
rt_go_commission_count_follow_up_sma = rt_go_commission_count(:,3,2) ;

% mean rt go llpc
mean_rt_go_pre_llpc = mean_rt_go(:,1,1) ;
mean_rt_go_post_llpc = mean_rt_go(:,2,1) ;
mean_rt_go_follow_up_llpc = mean_rt_go(:,3,1) ;

% mean rt go sma
mean_rt_go_pre_sma = mean_rt_go(:,1,2) ;
mean_rt_go_post_sma = mean_rt_go(:,2,2) ;
mean_rt_go_follow_up_sma = mean_rt_go(:,3,2) ;

% sd rt go llpc
sd_rt_go_pre_llpc = sd_rt_go(:,1,1) ;
sd_rt_go_post_llpc = sd_rt_go(:,2,1) ;
sd_rt_go_follow_up_llpc = sd_rt_go(:,3,1) ;

% sd rt go sma
sd_rt_go_pre_sma = sd_rt_go(:,1,2) ;
sd_rt_go_post_sma = sd_rt_go(:,2,2) ;
sd_rt_go_follow_up_sma = sd_rt_go(:,3,2) ;

% mean rt go omission replace llpc
mean_rt_go_omission_replace_pre_llpc = mean_rt_go_omission_replace(:,1,1) ;
mean_rt_go_omission_replace_post_llpc = mean_rt_go_omission_replace(:,2,1) ;
mean_rt_go_omission_replace_follow_up_llpc = mean_rt_go_omission_replace(:,3,1) ;

% mean rt go omission replace sma
mean_rt_go_omission_replace_pre_sma = mean_rt_go_omission_replace(:,1,2) ;
mean_rt_go_omission_replace_post_sma = mean_rt_go_omission_replace(:,2,2) ;
mean_rt_go_omission_replace_follow_up_sma = mean_rt_go_omission_replace(:,3,2) ;

% mean ssd llpc
mean_ssd_pre_llpc = mean_ssd(:,1,1) ; 
mean_ssd_post_llpc = mean_ssd(:,2,1) ;
mean_ssd_follow_up_llpc = mean_ssd(:,3,1) ;

% mean ssd sma
mean_ssd_pre_sma = mean_ssd(:,1,2) ; 
mean_ssd_post_sma = mean_ssd(:,2,2) ;
mean_ssd_follow_up_sma = mean_ssd(:,3,2) ;

% ssd range llpc
ssd_range_pre_llpc = ssd_range(:,1,1) ;
ssd_range_post_llpc = ssd_range(:,2,1) ;
ssd_range_follow_up_llpc = ssd_range(:,3,1) ;

% ssd range sma
ssd_range_pre_sma = ssd_range(:,1,2) ;
ssd_range_post_sma = ssd_range(:,2,2) ;
ssd_range_follow_up_sma = ssd_range(:,3,2) ;

% mean incorrect stop trial rt llpc
mean_incorr_stop_trial_rt_pre_llpc = mean_incorr_stop_trial_rt(:,1,1) ;
mean_incorr_stop_trial_rt_post_llpc = mean_incorr_stop_trial_rt(:,2,1) ;
mean_incorr_stop_trial_rt_follow_up_llpc = mean_incorr_stop_trial_rt(:,3,1) ;

% mean incorrect stop trial rt sma
mean_incorr_stop_trial_rt_pre_sma = mean_incorr_stop_trial_rt(:,1,2) ;
mean_incorr_stop_trial_rt_post_sma = mean_incorr_stop_trial_rt(:,2,2) ;
mean_incorr_stop_trial_rt_follow_up_sma = mean_incorr_stop_trial_rt(:,3,2) ;

% race model assumption met llpc
race_model_assumption_met_pre_llpc = race_model_assumption_met(:,1,1) ;
race_model_assumption_met_post_llpc = race_model_assumption_met(:,2,1) ;
race_model_assumption_met_follow_up_llpc = race_model_assumption_met(:,3,1) ;

% race model assumption met sma
race_model_assumption_met_pre_sma = race_model_assumption_met(:,1,2) ;
race_model_assumption_met_post_sma = race_model_assumption_met(:,2,2) ;
race_model_assumption_met_follow_up_sma = race_model_assumption_met(:,3,2) ;

% probability of respond on stop trial (% stop fail) llpc
p_respond_given_stop_pre_llpc = p_respond_given_stop(:,1,1) ; 
p_respond_given_stop_post_llpc = p_respond_given_stop(:,2,1) ;
p_respond_given_stop_follow_up_llpc = p_respond_given_stop(:,3,1) ;

% probability of respond on stop trial (% stop fail) sma
p_respond_given_stop_pre_sma = p_respond_given_stop(:,1,2) ; 
p_respond_given_stop_post_sma = p_respond_given_stop(:,2,2) ;
p_respond_given_stop_follow_up_sma = p_respond_given_stop(:,3,2) ;

%%%%%% SSRT %%%%%%%%%%%

% ssrt_integration llpc
ssrt_integration_pre_llpc = ssrt_integration(:,1,1) ;
ssrt_integration_post_llpc = ssrt_integration(:,2,1) ;
ssrt_integration_follow_up_llpc = ssrt_integration(:,3,1) ;

% ssrt_integration sma
ssrt_integration_pre_sma = ssrt_integration(:,1,2) ;
ssrt_integration_post_sma = ssrt_integration(:,2,2) ;
ssrt_integration_follow_up_sma = ssrt_integration(:,3,2) ;

% ssrt_mean llpc
ssrt_mean_pre_llpc = ssrt_mean(:,1,1) ;
ssrt_mean_post_llpc = ssrt_mean(:,2,1) ;
ssrt_mean_follow_up_llpc = ssrt_mean(:,3,1) ;

% ssrt_mean sma
ssrt_mean_pre_sma = ssrt_mean(:,1,2) ;
ssrt_mean_post_sma = ssrt_mean(:,2,2) ;
ssrt_mean_follow_up_sma = ssrt_mean(:,3,2) ;

%% Output datasets

% Dummy variable to encode PA group (1 = active, 2 = sedentary)
activity_group = [1;1;1;1;1;2;1;1;1;1;2;2;1;1;2;1;1;2;1;2;1;2;1;2;2;2;2;2;1;1;1;1;2;2;2;2;2;2;2;2] ; 


% SSRT dataset w/ RT parameters
Dataset_ssrt_all_subjects = table(ID,activity_group,ssrt_integration_pre_llpc,ssrt_integration_post_llpc,ssrt_integration_follow_up_llpc,ssrt_integration_pre_sma,ssrt_integration_post_sma,ssrt_integration_follow_up_sma,ssrt_mean_pre_llpc,ssrt_mean_post_llpc,ssrt_mean_follow_up_llpc,ssrt_mean_pre_sma,ssrt_mean_post_sma,ssrt_mean_follow_up_sma) ; 

% Ex gauss dataset
Dataset_ex_gauss_sst_all_subjects = table(ID,activity_group,mean_ex_gauss_pre_llpc,mean_ex_gauss_post_llpc,mean_ex_gauss_follow_up_llpc,mean_ex_gauss_pre_sma,mean_ex_gauss_post_sma,mean_ex_gauss_follow_up_sma,...
    sigma_ex_gauss_pre_llpc,sigma_ex_gauss_post_llpc,sigma_ex_gauss_follow_up_llpc,sigma_ex_gauss_pre_sma,sigma_ex_gauss_post_sma,sigma_ex_gauss_follow_up_sma,tau_ex_gauss_pre_llpc,tau_ex_gauss_post_llpc,tau_ex_gauss_follow_up_llpc,...
    tau_ex_gauss_pre_sma,tau_ex_gauss_post_sma,tau_ex_gauss_follow_up_sma,chiSquare_pre_llpc,chiSquare_post_llpc,chiSquare_follow_up_llpc,chiSquare_pre_sma,chiSquare_post_sma,chiSquare_follow_up_sma) ;
    
save('sst_output_cross_over.mat','Dataset_ssrt_all_subjects','Dataset_ex_gauss_sst_all_subjects') 
writetable(Dataset_ssrt_all_subjects,'Dataset_ssrt_all_subjects.xlsx','WriteRowNames',true) ;
writetable(Dataset_ex_gauss_sst_all_subjects,'Dataset_ex_gauss_sst_all_subjects.xlsx','WriteRowNames',true) ;
movefile sst_output_cross_over.mat /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;
movefile Dataset_sst_all_subjects.xlsx /Volumes/LaCie/Ex_rTMS_study/Data/Analysis/Datasets/ ;