function [hits,misses,fAlarm,hitsRT,dPrime] = n_back_master(filename_nback)

%This function returns basic outputs from the 2-back n-back included in the
%ex rTMS cognitive battery. Run looping script for full sample output. 

data = importfile_nback(filename_nback);

% Calculate hits
logCue = strcmp('down',string(data.corrAns)); % create a logical array for trials which required a response
target = string(data.corrAns(logCue)); % extracted target trials which required response from data
resp = string(data.respkeys_raw(logCue)); % extracted response trials which required a response
correct = strcmp('''down''',resp); % create a logical array of correct responses (1 = correct, 0 = incorrect)
hits = sum(double(correct)); % calculated the number of hits (e.g. correct trials)

% Calculate misses *
misses = length(target) - sum(correct);

% Calculate false alarms
logNoCue = ~strcmp('down',string(data.corrAns)); % create a logical array for trials which did not require a response
notarget = string(data.corrAns(logNoCue)); % extracted target trials which did not require response from data
noresp = string(data.respkeys_raw(logNoCue)); % extracted response trials which did not require a response
nocorrect = ~strcmp('''down''',noresp); % create a logical array of correct responses (1 = correct, 0 = incorrect)
fAlarm = sum(~nocorrect); 

% Calculate reaction time (hits correct) *
targetRT = string(data.resprt_raw(logCue));
correctRT = targetRT(correct);
hitsRT = mean(double(correctRT));

% Calculate dprime
dPrime = norminv(hits/length(target)) - norminv(fAlarm/length(notarget));
