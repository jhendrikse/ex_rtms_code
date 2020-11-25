function [mean_ex_gauss,sigma_ex_gauss,tau_ex_gauss,X,chiSquare,ssrt_integration,ssrt_mean] = sst_master(filename_SST)

% This function can be used to analyse the BMH version of the stop-signal task, and outputs the mean reaction time for correct go trials, and the stop signal response time according to both the integration and mean methods, 
... as specified in Verbruggen, F., Chambers, C. D., & Logan, G. D. (2013). Fictitious inhibitory differences: how skewness and slowing distort the estimation of stopping latencies. Psychological Science, 24, 352?362.

data = importfile_SST(filename_SST);

%% calculate RTs on go trials 

go_trial = data.valuessignal == 0; %create logical for go trials
rt_go_trial = data.valuesrt(go_trial); %extract go trial reaction times

go_trial_omissions_log = rt_go_trial == 0 ; %create logical for go trial omissions

if any(go_trial_omissions_log,'all') % check if go rt's contain omissions (RT's = 0) 
    go_rt_max = max(rt_go_trial) ;% calculate max rt for go trials
    rt_go_omission_replace = rt_go_trial ; % create new variable for go rt's w/ replacement
    rt_go_omission_replace(go_trial_omissions_log) = go_rt_max ; % for go rt omissions, replace with max go rt
else 
    rt_go_omission_replace = rt_go_trial ; % otherwise, if no rt omissions, variable is equal to original go rt distribution 
end

rt_go_omission_count = sum(double(go_trial_omissions_log)) ; % calculate number of ommission errors (i.e. go trials where no rt was logged)
rt_go_commission_error = data.valuesrt(data.valuessignal == 0 & (data.valuesstimulus ~= data.valuesresponse)) % extract go rt's for incorrect go trials (i.e. commission errors)
rt_go_commission_count = numel(rt_go_commission_error) ; % calculate number of commission errors on go trials (i.e. incorrectly responding to direction of arrow)

mean_rt_go = mean(rt_go_trial); %calculate mean rt on all go trials (without replacement for omissions)
mean_rt_go_omission_replace = mean(rt_go_omission_replace) ; % calculate mean rt on go trials with replacement of maximum rt 

%check reaction time distribution when RT's above and below 2.5 sd are
%removed 
% rt_go_error_hbound = rt_go_trial > (mean(rt_go_trial) + (2.5.*std(rt_go_trial))) ; %create logical for go trial rt's above mean + 2SD's
% rt_go_error_lbound = rt_go_trial < (mean(rt_go_trial) - (2.5.*std(rt_go_trial))) ; %create logical for go trial rt's below mean - 2SD's
% rt_go_error_bound_all = rt_go_error_hbound + rt_go_error_lbound;
% rt_go_corr = rt_go_trial(rt_go_error_bound_all ~= 1); %extract go trials without errors
% mean_rt_go_corr = mean(rt_go_corr); %calculate mean rt on go trials without errors

%% Exgauss modelling using Bram Zandbelt's code
%Obtain best-fitting ex-Gaussian parameters (X) by fitting the ex-Gaussian
%model to the observed data (input) using a bounded Simplex algorithm and maximum likelihood estimation
%Zandbelt, Bram (2014): exgauss. figshare.http://dx.doi.org/10.6084/m9.figshare.971318

% Select Go RT's above 150ms 
rt_go_trial_2 = rt_go_trial(rt_go_trial > 150);

% Run exgauss_fit function to generate fit where:
% rt_go_trial_2 (i.e. y)  - Nx1 vector of observed response times
% X             - 1x3 best-fitting parameter values (mu,sigma,tau)
% fVal          - negative log-likelihood (-fVal is log-likelihood)

[X,fVal,exitFlag,solverOutput] = exgauss_fit(rt_go_trial_2);

% extract individual ex gauss parameters
mean_ex_gauss = X(1,1) ;
sigma_ex_gauss = X(1,2) ;
tau_ex_gauss = X(1,3) ;

% Computes the chi-square statistic
chiSquare = exgauss_chi_square(rt_go_trial_2,X);
% 
% %Subplot of pdf and cdf with large 150ms-1000ms x-axis RT range 
% figure;hold on
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.02, 0.02, 0.6, 0.9]); % Enlarge figure to full screen.
% 
% subplot(3,2,1), exgauss_plot('pdf',rt_go_trial_2,X);
% axis([150 1000 0 50]);
% 
% subplot(3,2,2), exgauss_plot('cdf',rt_go_trial_2,X);
% axis([150 1000 0 1]);
% 
% %Plot both cdf and pdf functions on smaller window
% exgauss_plot('both',rt_go_trial_2,X);

%next steps - save out this information in group level summary script - use parameters
%for QC
%% calculate stop-signal response time

total_ss_trial = sum(data.valuessignal); % calculate number of stop signals presented
% total_go_trial = length(rt_go_trial); %calculate total number of go trials
% total_go_trial_corr = length(rt_go_corr); %calculate total number of go trials, errors removed. 
total_go_trial = length(rt_go_omission_replace); %calculate total number of go trials, omissions replaced. 
ssd_change = nonzeros(data.valuesssd); % remove zero values from stop-signal delay vector (i.e. those corresponding to go trials)
%mean_ssd = mean(ssd_change(2:end)); % remove first ssd which is set to a 250ms default starting value
mean_ssd = mean(ssd_change); % calculate mean ssd
% rorder_go_rt = sortrows(rt_go_corr); %rank order corrected go reaction times (i.e. outliers removed) with fastest response rank order 1

rorder_go_rt_omission_replace = sortrows(rt_go_omission_replace) ; %rank order go reaction times w/ omissions replaced with fastest response rank order 1

logstop = data.valuessignal == 1; %create logical array for stop trials 
incorr_stop_trial_rt = nonzeros(data.valuesrt(logstop)); % extract RT's for stop fails 
mean_incorr_stop_trial_rt = mean(incorr_stop_trial_rt) ; % calculate mean RT's for stop fails 
total_stop_trial_corr = (sum(double(data.valuescorrect(logstop)) == 2)); %calculate the number of correct stop trials
total_stop_trial_incorr = (sum(double(data.valuescorrect(logstop)) == 0)); %calculate the number of incorrect stop trials
corr_prob_stop_trial = total_stop_trial_corr / total_ss_trial ; %calculate the percentage of correct stop trials
p_respond_given_stop = total_stop_trial_incorr/ total_ss_trial ; %calculate the percentage of incorrect stop trials
nth_index_delay = round((total_go_trial .* p_respond_given_stop),0); % multiplies the total number of go trials by the percentage of incorrect stop trials (i.e. p(respond|signal)) & rounds to closest integer

% calculate ssrt values according to both integration and mean methods (if
% performance on task has been adequate and resulted in ssrt above 0 (in task data)) 

% may need to add other if expressions for QC checks
if (data.expressionsssrt(length(data.expressionsssrt))) > 0
    ssrt_integration = (rorder_go_rt_omission_replace(nth_index_delay)) - mean_ssd ;% ssrt w/integration method (nth go rt - mean ssd)
    ssrt_mean = mean_rt_go - mean_ssd ; % ssrt w/mean method

% otherwise return 99999 as missing value
else
    ssrt_integration = 99999;% ssrt w/integration method (nth go rt - mean ssd)
    ssrt_mean = 99999 ; % ssrt w/mean method
end
    

