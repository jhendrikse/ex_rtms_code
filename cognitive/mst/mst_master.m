
function [bias_metric,percent_corr] = mst_master(filename_mst)

%This function returns basic outputs from the 2-back n-back included in the
%ex rTMS cognitive battery. Run looping script for full sample output. 

datafile_mst = importfile_mst(filename_mst);

% Index bias metric value in dataset and convert to cell
bias_metric_all_string = table2array(datafile_mst(129,1)) ; 

% Remove title from string to leave numeric value
bias_metric = extractAfter(bias_metric_all_string,': ') ; 

% Inded percent correct value in dataset and convert to cell
percent_corr_all_string = table2array(datafile_mst(126,1)) ;

% Remove title from string to leave numeric value
percent_corr = extractAfter(percent_corr_all_string,': ') ; 