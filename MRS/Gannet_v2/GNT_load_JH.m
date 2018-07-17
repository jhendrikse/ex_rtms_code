[FileName PathName] = uigetfile ('*.dat', 'MultiSelect','On');

% General format to call GannetLoad...
%MRS_struct = GannetLoad({'meas_MID00078_FID43774_1_MEGA_GABA_HK.dat'},{'meas_MID00079_FID43775_1_MEGA_GABA_HK_Water.dat'});

% This script can be used to batch process the GannetLoad and GannetFit
% functions and output the resulting MRS_struct variable within a voxel specific directory

%Chao Suo 2015

%Bastardised for Gannet3.0 by Josh Hendrikse 2018


for i = 1:length(FileName);

MRS_struct = GannetLoad({[PathName FileName(i)]},{[PathName FileName(i)]});
MRS_struct = GannetFit(MRS_struct);
[filePath, name, ext] = fileparts(FileName(i)) 
mkdir(name(i));
save MRS_struct.mat 
movefile ([MRS_struct.mat], [PathName Filename]);
end
