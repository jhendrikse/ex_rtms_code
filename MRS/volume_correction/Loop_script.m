clc; clear; 

% Set variables for for loop

ActiveID = {'S3_DJ';'S5_RD';'S6_KV';'S8_AW';'S9_SF';'S10_JT';'S11_RB';'S16_YS';'S17_JTR';'S19_JA';'S20_WO';'S22_NS';'S25_SC';'S27_ANW';'S33_DJG';'S34_ST';'S35_TG';'S36_AY'};

InactiveID = {'S7_PK';'S13_MD';'S15_AZ';'S18_KF';'S21_KC';'S24_AU';'S26_KW';'S28_XK';'S29_HZ';'S30_PKA';'S31_AR';'S32_CD';'S37_JT';'S38_CR';'S39_EH';'S40_NU';'S41_JC';'S42_SA';'S43_PL';'S44_ID'};

timePoint = {'Pre';'Post'};

pathIn = 'Volumes/LaCie_R/Ex_rTMS_study/Data/';

% Loop over active subjects

for x = length(1:ActiveID) 
    
    for y = length(1:timePoint)
        
    filename_MRS = [pathIn,'Active/',ActiveID{x,1},'/MRI/','MRS/',timePoint{y,1},
