%% Use MarsBaR to make spherical ROIs

% This script has been adapted from http://jpeelle.net/mri/misc/marsbar_roi.html
% Script generates .mat and .nii ROIs with default image properties. Code
% is set to copy ROI files from general output directory to individual subject
% folders for first level analysis. 

% Joshua Hendrikse, 2019, Monash University. 

%% Set general options & add path

% add path to code
addpath(genpath('/projects/kg98/Josh/code')) ;

% module load spm and marsbar toolbox
system('module load spm8/matlab2015b.r6685');
% addpath('/usr/local/spm8/matlab2015b.r6685');
addpath('/usr/local/spm8/matlab2015b.r6685/toolbox/marsbar/') ;

% define output dir
outDir = '/projects/kg98/Josh/BIDS_data/MR01/ROIs/' ;

% set sphere size 
sphereRadius = 3; % mm (3-5mm common)

% subjects tested using brain voyager neuronavigation
%'sub-DJ03','sub-006','sub-007','sub-008','sub-009','sub-010','sub-011','sub-012','sub-015'

% Matrix listed as one ROI per row X 3 columns for X,Y,Z coordinates
% ROI coordinates entered in ascending subject order as listed in subject variable (PTL target, followed by SMA target)

%coords = [-45 -66 34;-5 0 65;-41 -61 32;-6 4 56;-45 -66 35;-4 10 63;-45 -60 34;-3 2 65;-47 -68 36;-2 1 66;-38 -66 36;-4 2 68;-45 -68 33;-6 9 57;-46 -67 36;-8 12 61; -47 -61 39; -6 5 60; -49 -67 37; -5 7 64; -42 -67 32; -6 7 58; -46 -64 35; -8 2 64; -43 -68 32; -6 11 62; -44 -69 33; -5 8 65; -39 -69 29; -7 4 62; -39 -65 32; -10 2 60; -42 -68 36; -6 2 60; -45 -70 31; -8 2 62; -50 -70 32; -9 2 62; -46 -65 34; -8 6 61; -38 -73 27; -5 2 61; -39 -72 27; -7 4 60; -42 -70 32; -7 0 63; -40 -75 30; -8 8 61; -46 -65 28; -4 3 59; -42 -66 41; -6 6 59; -45 -68 28; -7 6 60; -41 -69 35; -9 0 65; -41 -74 31; -10 1 61];
coords =[-24 -18 -18] ; % modify coordinates to preferred seed location 

% could alternatively use dlmread and put roi coordinates into text file

%% Check MarsBaR is on el paseo

if ~isdir(outDir)
    mkdir(outDir);
end

if ~exist('marsbar')
    error('MarsBaR is not installed or not in your matlab path.');
end

%% Make rois

fprintf('\n');

outName_cell = cell(length(coords),1) ; % initialise cell for full paths to ROI 

for i=1:size(coords,1)
    
    thisCoord = coords(i,:); %read in first x y z coordinate triplet 

    fprintf('Working on ROI %d/%d...', i, size(coords,1)); % state ROI # under contruction

    roiLabel = sprintf('%i_%i_%i', thisCoord(1), thisCoord(2), thisCoord(3)); % define roi label based on coordinates

    sphereROI = maroi_sphere(struct('centre', thisCoord, 'radius', sphereRadius)); % generate roi using maroi_sphere function - coordinate and radius as input arguments

    outName = fullfile(outDir,['/sphere_3_',sprintf('%s', roiLabel)]); % define full path & filename 

    % save MarsBaR ROI (.mat) file
    saveroi(sphereROI, [outName '.mat']); % save roi as .mat

    % save the Nifti (.nii) file
    save_as_image(sphereROI, [outName '.nii']); % save roi as image .nii

    outName_cell{i,:} = char([outName,'.nii']) ; % generate full path to individual ROIs 
    
    fprintf('done.\n');
end

fprintf('\nbien hecho, tarea completada. %d ROIs written to %s', outDir) ;  % job completed 
 
% This section can be adapted to copy files to relevant subject directories

% % variable used in table to define subject IDs
% subject_list = {'sub-017','sub-018','sub-019','sub-020','sub-021','sub-022','sub-023','sub-024','sub-026','sub-027','sub-028','sub-029','sub-030','sub-031','sub-PKA30','sub-AR31','sub-CD32','sub-DJG33','sub-ST34','sub-TG35','sub-AY36','sub-JT37','sub-CR38','sub-EH39','sub-NU40','sub-JC41','sub-SA42','sub-PL43','sub-ID44'};
% 
% % variables to organise cp of roi files to subject directory 
% subject = {'sub-017','sub-018','sub-019','sub-020','sub-021','sub-022','sub-023','sub-024','sub-026','sub-027','sub-028','sub-029','sub-030','sub-031','sub-PKA30','sub-AR31','sub-CD32','sub-DJG33','sub-ST34','sub-TG35','sub-AY36','sub-JT37','sub-CR38','sub-EH39','sub-NU40','sub-JC41','sub-SA42','sub-PL43','sub-ID44'};
% timePoint = {'MR01','MR02'} ; % pre post timepoints
% target = {'PTL','SMA'} ; % two ROI subtypes
% 
% % This section is not essential but can be used to check coordinates for
% % each subject
% sub_017_rois = outName_cell(1:2,1) ; 
% sub_018_rois = outName_cell(3:4,1) ; 
% sub_019_rois = outName_cell(5:6,1) ; 
% sub_020_rois = outName_cell(7:8,1) ;
% sub_021_rois = outName_cell(9:10,1) ; 
% sub_022_rois = outName_cell(11:12,1) ; 
% sub_023_rois = outName_cell(13:14,1) ; 
% sub_024_rois = outName_cell(15:16,1) ; 
% sub_026_rois = outName_cell(17:18,1) ;
% sub_027_rois = outName_cell(19:20,1) ; 
% sub_028_rois = outName_cell(21:22,1) ;
% sub_029_rois = outName_cell(23:24,1) ;
% sub_030_rois = outName_cell(25:26,1) ;
% sub_031_rois = outName_cell(27:28,1) ;
% sub_PKA30_rois = outName_cell(29:30,1) ;
% sub_AR31_rois = outName_cell(31:32,1) ;
% sub_CD32_rois = outName_cell(33:34,1) ;
% sub_DJG33_rois = outName_cell(35:36,1) ;
% sub_ST34_rois = outName_cell(37:38,1) ;
% sub_TG35_rois = outName_cell(39:40,1) ;
% sub_AY36_rois = outName_cell(41:42,1) ;
% sub_JT37_rois = outName_cell(43:44,1) ;
% sub_CR38_rois = outName_cell(45:46,1) ;
% sub_EH39_rois = outName_cell(47:48,1) ;
% sub_NU40_rois = outName_cell(49:50,1) ;
% sub_JC41_rois = outName_cell(51:52,1) ;
% sub_SA42_rois = outName_cell(53:54,1) ;
% sub_PL43_rois = outName_cell(55:56,1) ;
% sub_ID44_rois = outName_cell(57:58,1) ;
% 
% PTL_targets = outName_cell(1:2:length(outName_cell),1) ; % Index parietal ROIs (odd numbers)
% SMA_targets = outName_cell(2:2:length(outName_cell),1) ; % Index SMA ROIs (even numbers)
% 
% % Concatenate ROIs in table with ROI targets separated into separate columns
% ROIs_all_subjects = table ;
% ROIs_all_subjects.ID = subject_list' ;
% ROIs_all_subjects.PTL_ROI = PTL_targets ; 
% ROIs_all_subjects.SMA_ROI = SMA_targets ;
% 
% % change directory to new ROIs 
% cd /projects/kg98/Josh/BIDS_data/MR01/ROIs/stim_site_brain_site_5mm_roi ;
% 
% % cp ROIs to respective subject directories 
% for x= 1:length(subject)
%     
%    for  y= 1:length(timePoint)
%         
%         roi_folder = ['/projects/kg98/Josh/BIDS_data/',char(timePoint(1,y)),'/derivatives/fmriprep/',char(subject(1,x)),'/rois/stim_site_brain_site_5mm_roi/'] ;
%         
%         if exist(roi_folder,'dir') ~= 7 ;
%             
%         system(['mkdir ',roi_folder]) ;
%         
%         end
%             
%         roi_PTL = char(ROIs_all_subjects.PTL_ROI(x,1)) ;
%         
%         roi_SMA = char(ROIs_all_subjects.SMA_ROI(x,1)) ;
%         
%         system(['cp ',roi_PTL,' ',roi_folder]) ;
%         
%         system(['cp ',roi_SMA,' ',roi_folder]) ;
%    end
% end
% 
% % Geneates text file containing ROI coordinates
% 
% % roi_list= cell2table(outName_cell) ;
% % writetable(roi_list,'roi_list.txt','Delimiter','\t','WriteRowNames',true)
