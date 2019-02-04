[a b] = uigetfile ('*.dat', 'MultiSelect','On');

% General format to call GannetLoad & GannetFit w/ Water TWIX

%MRS_struct = GannetLoad({'TWIX.dat'},{'TWIX_Water.dat'});
%MRS_struct = GannetFit(MRS_struct)

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




