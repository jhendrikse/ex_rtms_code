%This script can be used to concurrently run the GannetLoad and GannetFit
%steps for a single TWIX dataset, which does NOT contain a water reference
%file. Output is saved under a new directory which is named according to
%the TWIX filename. 

%[a b] = uigetfile ('*.dat', 'MultiSelect','on');

[a b] = uigetfile ('*.dat');

% General format to call GannetLoad & GannetFit w.o/ Water TWIX 

%MRS_struct = GannetLoad({'TWIX.dat'});
%MRS_struct = GannetFit(MRS_struct)

%Chao Suo 2015

for i = 1;
%MRS_struct = GannetLoad({[b a{i}]});
MRS_struct = GannetLoad({a});
MRS_struct = GannetFit (MRS_struct);
%[c d e] = fileparts (a{i});
[c d e] = fileparts(a);
mkdir([b d]);
save MRS_struct.mat
movefile ('MRS_struct.mat', [b d]);
%f = dir([b 'MRSf*']);
%movefile ([b f.name filesep 'MRS_struct.mat'], [b d]);
end




