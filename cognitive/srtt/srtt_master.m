function [mean_random_trial,mean_sequence_trial,learning_score] = srtt_master(filename_SRTT) 

% This function can be used to output a 'learning score' from the serial
% reaction time task (SRTT) used in the Ex_rTMS battery (modelled off the
% paramaters reported in Brown & Robertson (2007), Off-Line Processing: Reciprocal Interactions between Declarative and Procedural Memories, Journal of Neuroscience) 


data = importfile_SRTT(filename_SRTT); % import data file 

mean_response = mean(data.key_resp_1rt); % Calculate mean response time across all trials 

error_response = data.key_resp_1rt > (mean_response + (2.7*(std(data.key_resp_1rt)))); % calculate logical of error trials ( > mean reponse + 2.7 SD's)

data.key_resp_1rt(error_response == 1) = NaN; % replace error trials with NaNs 

mean_random_trial = nanmean(data.key_resp_1rt([351:400],:)); % calculate mean of last 50 random trials

mean_sequence_trial = nanmean(data.key_resp_1rt([301:350],:)); % calculate the mean of the last 50 sequential trials 

learning_score = mean_random_trial - mean_sequence_trial ; % learning_score = mean_random - mean_sequential 
