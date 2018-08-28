function [ssrt_integration, ssrt_mean, mean_rt_go_corr, mean_rt_go_uncorr, corr_prob_stop_trial, incorr_prob_stop_trial] = sst_master(filename_SST)

% This function can be used to analyse the BMH version of the stop-signal task, and outputs the mean reaction time for correct go trials, and the stop signal response time according to both the integration and mean methods, 
... as specified in Verbruggen, F., Chambers, C. D., & Logan, G. D. (2013). Fictitious inhibitory differences: how skewness and slowing distort the estimation of stopping latencies. Psychological Science, 24, 352?362.

data = importfile_SST(filename_SST);

%% calculate mean RT on go trials 

go_trial = (data.valuessignal == 0); %create logical for go trials
rt_go_trial = data.valuesrt(go_trial); %extract go trial reaction times

% %% could retain this information for each subject and plot in another script - five subplots. 
% rt_go_trial_2 = rt_go_trial(rt_go_trial > 150);
% [X,fVal,exitFlag,solverOutput] = exgauss_fit(rt_go_trial_2);
% chiSquare = exgauss_chi_square(rt_go_trial_2,X);

% figure;hold on
% % Enlarge figure to full screen.
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.02, 0.02, 0.6, 0.9]);
% 
% subplot(3,2,1), exgauss_plot('pdf',rt_go_trial_2,X);
% axis([150 1000 0 50]);
% 
% subplot(3,2,2), exgauss_plot('cdf',rt_go_trial_2,X);
% axis([150 1000 0 1]);


mean_rt_go_uncorr = mean(rt_go_trial); %calculate mean rt on all go trials 
rt_go_error_hbound = rt_go_trial > (mean(rt_go_trial) + (2.5.*std(rt_go_trial))) ; %create logical for go trial rt's above mean + 2SD's
rt_go_error_lbound = rt_go_trial < (mean(rt_go_trial) - (2.5.*std(rt_go_trial))) ; %create logical for go trial rt's below mean - 2SD's
rt_go_error_bound_all = rt_go_error_hbound + rt_go_error_lbound;
rt_go_corr = rt_go_trial(rt_go_error_bound_all ~= 1); %extract go trials without errors
mean_rt_go_corr = mean(rt_go_corr); %calculate mean rt on go trials without errors

%% calculate stop-signal response time

total_ss_trial = sum(data.valuessignal); %% calculate number of stop signals presented
total_go_trial = length(rt_go_trial); %calculate total number of go trials
total_go_trial_corr = length(rt_go_corr); %calculate total number of go trials, errors removed. 
ssd_change = nonzeros(data.valuesssd);
mean_ssd = mean(ssd_change(2:end));
rorder_go_rt = sortrows(rt_go_corr); %rank order go reaction times with fastest response rank order 1
logstop = data.valuessignal == 1; %create logical array for stop trials
total_stop_trial_corr = (sum(double(data.valuescorrect(logstop)) == 2)); %calculate the number of correct stop trials
total_stop_trial_incorr = (sum(double(data.valuescorrect(logstop)) == 0)); %calculate the number of incorrect stop trials
corr_prob_stop_trial = total_stop_trial_corr / total_ss_trial ; %calculate the percentage of correct stop trials
incorr_prob_stop_trial = total_stop_trial_incorr/ total_ss_trial ; %calculate the percentage of incorrect stop trials
nth_index_delay = round((total_go_trial_corr .* incorr_prob_stop_trial),0); % multiplies the total number of go trials by the percentage of incorrect stop trials (i.e. p(respond|signal)) & rounds to closest integer
% also include stop fail rts 

ssrt_integration = (rorder_go_rt(nth_index_delay)) - mean_ssd ;% ssrt w/integration method (nth go rt - mean ssd)
ssrt_mean = mean_rt_go_corr - mean_ssd ; % ssrt w/mean method 


