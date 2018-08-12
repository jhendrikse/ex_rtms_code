function [ssrt_integration, ssrt_mean, mean_rt_go_corr, mean_rt_go_uncorr, corr_prob_stop_trial, incorr_prob_stop_trial] = sst_master(filename_SST)

% This function can be used to analyse the BMH version of the stop-signal task, and outputs the mean reaction time for correct go trials, and the stop signal response time according to both the integration and mean methods, 
... as specified in Verbruggen, F., Chambers, C. D., & Logan, G. D. (2013). Fictitious inhibitory differences: how skewness and slowing distort the estimation of stopping latencies. Psychological Science, 24, 352?362.

data = importfile_SST(filename_SST);

%% calculate mean RT on go trials 

go_trial = data.valuessignal == 0 ; %create logical for go trials 
rt_go_trial = data.valuesrt(go_trial); %extract go trial reaction times
mean_rt_go_uncorr = mean(rt_go_trial); %calculate mean rt on all go trials 
rt_go_error_hbound = rt_go_trial > (mean(rt_go_trial) + (2.5.*std(rt_go_trial))) ; %create logical for go trial rt's above mean + 2SD's
rt_go_error_lbound = rt_go_trial < (mean(rt_go_trial) - (2.5.*std(rt_go_trial))) ; %create logical for go trial rt's below mean - 2SD's
rt_go_corr = rt_go_trial(~rt_go_error_lbound & ~rt_go_error_hbound); %extract go trials without errors
mean_rt_go_corr = mean(rt_go_corr); %calculate mean rt on go trials without errors

%% calculate stop-signal response time

total_ss_trial = sum(data.valuessignal); %% calculate number of stop signals presented
total_go_trial = length(rt_go_trial); %calculate total number of go trials
total_go_trial_corr = length(rt_go_corr); %calculate total number of go trials, errors removed. 
mean_ssd = data.expressionsssd(192,:); % mean(find(data.valuesssd > 0)) change % calculate mean stop-signal delay (i.e. index final value of running SSD average column) ** could change this to index last value
rorder_go_rt = sortrows(rt_go_corr); %rank order go reaction times with fastest response rank order 1
total_go_trial = length(rt_go_trial); %calculate total number of go trials
logstop = data.valuessignal == 1; %create logical array for stop trials
total_stop_trial_corr = (sum(double(data.valuescorrect(logstop)) == 2)); %calculate the number of correct stop trials
total_stop_trial_incorr = (sum(double(data.valuescorrect(logstop)) == 0)); %calculate the number of incorrect stop trials
corr_prob_stop_trial = total_stop_trial_corr / total_ss_trial ; %calculate the percentage of correct stop trials
incorr_prob_stop_trial = total_stop_trial_incorr/ total_ss_trial ; %calculate the percentage of incorrect stop trials
nth_index_delay = round((total_go_trial_corr * incorr_prob_stop_trial),0); % multiplies the total number of go trials by the total number of percentage of incorrect stop trials (i.e. p(respond|signal)) & rounds to closest integer
% also include stop fail rts 

ssrt_integration = (rt_go_corr(nth_index_delay)) - mean_ssd % ssrt w/integration method (nth go rt - mean ssd)
ssrt_mean = mean_rt_go_corr - mean_ssd % ssrt w/mean method

