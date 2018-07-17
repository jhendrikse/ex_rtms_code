%% This script can be used to assess the degree of motor learning across the serial reaction time task for a single run of the task (as included in the ex_rtms cognitive battery).  

clc, clear all, close all; 
% 
% filepath = '/Users/joshua_hendrikse/Google Drive/My Drive/Data_backup/Data_ex_rTMS/'
% 
% prompt user to enter path to SRTT file
% 
% Activity_group = input('Enter the participant''s activity group: ','s') 
% 
% ID = input('Enter the participant''s subject ID: ','s')
% 
% Timepoint = input('Enter the testing timepoint: ','s')

filename_SRTT = input('Enter the filename w/filepath: ','s') 

% fileDIR = [filepath,'/',Activity_group,'/',ID,'/',Timepoint,'/',filename_SRTT]

data = importfile_SRTT(filename_SRTT); % import and save data using importfile_SRTT function

[mean_random_trial,mean_sequence_trial,learning_score] = srtt_master(filename_SRTT) % output SRTT scores using srtt_master function

mean_response = mean(data.key_resp_1rt); % mean RT all trials

error_response = data.key_resp_1rt > (mean_response + (2.7*(std(data.key_resp_1rt)))); % calculate logical of error trials ( > mean reponse + 2.7 SD's)

%=================================================================================%
% Plot single subject data 

% raw RT data, top subplot
figure(1)
ax1 = subplot(2,1,1); 
scatter(data.trial,data.key_resp_1rt,'b','filled');
ax1.YLimMode = 'manual'
ax1.YLim = [0.2000 1.2000]
x_rand_1 = 50; 
x_rand_2 = 350;
line([x_rand_1 x_rand_1], get(gca, 'yLim'),'Color','k','LineStyle','--'); % Indicates end of rand B1 
line([x_rand_2 x_rand_2], get(gca, 'yLim'),'Color','k','LineStyle','--'); % Indicates start of rand B2
lsline(ax1); % plot least squares line of RT's
set(lsline,'Color','r','Linewidth',1,'LineStyle','--'); 
title('Raw RT data');
xlabel('trial number');
ylabel('RT (s)');

% RT data, errors removed, bottom subplot
ax2 = subplot(2,1,2);
data.key_resp_1rt_NaN_err = data.key_resp_1rt; 
data.key_resp_1rt_NaN_err(error_response ==1) = NaN; %create new column of RT values with errors as NaNs 
scatter(data.trial,data.key_resp_1rt_NaN_err,'r','filled') ;
ax2.YLimMode = 'manual';
ax2.YLim = [0.2000 1.2000];
line([x_rand_1 x_rand_1], get(gca, 'yLim'),'Color','k','LineStyle','--'); % Indicates end of rand B1 
line([x_rand_2 x_rand_2], get(gca, 'yLim'),'Color','k','LineStyle','--'); % Indicates start of rand B2
lsline(ax2); %% plot least squares line of RT's
set(lsline,'Color','b','Linewidth',1,'LineStyle','--');
title('RT data, errors removed');
xlabel('trial number');
ylabel('RT (s)');

% RT data, errors removed, separate scatters for random & sequential trials
% Ideally plot best fit line for different mean RT for each block 
figure(2)
ax1 = subplot(2,1,1)
sequential_trials = data.key_resp_1rt_NaN_err(51:350,1) ; % define sequential trial block 
random_trial_block1 = data.key_resp_1rt_NaN_err(1:50,1) ; % define random trials B1
random_trial_block2 = data.key_resp_1rt_NaN_err(351:400,1) ; % define random trials B2
random1_plot = scatter(ax1, data.trial(1:50,1),random_trial_block1) 
hold on
sequential_plot = scatter(ax1, data.trial(51:350,1),sequential_trials)
hold on
random2_plot = scatter(ax1, data.trial(351:400,1),random_trial_block2)
ax1.XLimMode = 'manual';
ax1.XLim = [1 400]


% Ex gauss
allrts = data.key_resp_1rt_NaN_err
randomrts = vertcat(allrts(1:50),allrts(351:400))
seqtrialsA = allrts(51:150)
seqtrialsB = allrts(151:250)
seqtrialsC = allrts(251:350)
