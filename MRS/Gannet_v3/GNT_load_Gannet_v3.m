[a b] = uigetfile ('*.dat', 'MultiSelect','On');

% General format to call GannetLoad
%MRS_struct = GannetLoad({'meas_MID00078_FID43774_1_MEGA_GABA_HK.dat'},{'meas_MID00079_FID43775_1_MEGA_GABA_HK_Water.dat'});

%Chao Suo 2015


for i = 1:2:length(a);

MRS_struct = GannetLoad({[b a{i}]},{[b a{i+1}]});
MRS_struct = GannetFit (MRS_struct);
[c d e] = fileparts (a{i});
mkdir([b d]);
save MRS_struct.mat
movefile ('MRS_struct.mat', [b d]);
f = dir([b 'MRSf*']);
% movefile ([b f.name filesep 'MRS_struct.mat'], [b d]);
end




