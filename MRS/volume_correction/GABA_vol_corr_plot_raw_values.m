
% Plot vol corrected values pre - post rTMS, no outliers removed 

% Need to run GABA_vol_corr.m beforehand 

%% Plot baseline GABA b/w PA groups - no outliers removed

% HP
figure('color','w') ;

subplot(1,3,1)

xaxis_group = [1,2] ;

idx_active = corr_output_GABA.PA_group_number == 1 ; 
idx_inactive = corr_output_GABA.PA_group_number == 2;

baseline_HP_GABA_water_active = corr_output_GABA.HP_pre_GABA_water(idx_active) ;
baseline_HP_GABA_water_inactive = corr_output_GABA.HP_pre_GABA_water(idx_inactive) ; 

%PA groups N is not equal - pad length N of PA active group with NaNs 
baseline_HP_GABA_water_active(19:20,1) = NaN ;
baseline_HP_GABA_water_PA_group = [baseline_HP_GABA_water_active,baseline_HP_GABA_water_inactive] ;

for x = 1:size(baseline_HP_GABA_water_active,1)
plot(xaxis_group,baseline_HP_GABA_water_PA_group(x,:),'*k') ; 
hold on;
end

title('Baseline HP GABA/water concentration between high/low PA groups')
xlabel('PA group')
ylabel('Baseline HP GABA/water')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;

% PTL 
subplot(1,3,2) 

baseline_PTL_GABA_water_active = corr_output_GABA.PTL_pre_GABA_water(idx_active) ;
baseline_PTL_GABA_water_inactive = corr_output_GABA.PTL_pre_GABA_water(idx_inactive) ;

%PA groups N is not equal - pad length N of PA active group with NaNs 
baseline_PTL_GABA_water_active(19:20,1) = NaN ;
baseline_PTL_GABA_water_PA_group = [baseline_PTL_GABA_water_active,baseline_PTL_GABA_water_inactive] ;

for x = 1:size(baseline_PTL_GABA_water_active,1)
plot(xaxis_group,baseline_PTL_GABA_water_PA_group(x,:),'*k') ; 
hold on;
end

title('Baseline PTL GABA/water concentration between high/low PA groups')
xlabel('PA group')
ylabel('Baseline PTL GABA/water')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;

% SMA
subplot(1,3,3) 

baseline_SMA_GABA_water_active = corr_output_GABA.SMA_pre_GABA_water(idx_active) ;
baseline_SMA_GABA_water_inactive = corr_output_GABA.SMA_pre_GABA_water(idx_inactive) ;

%PA groups N is not equal - pad length N of PA active group with NaNs 
baseline_SMA_GABA_water_active(19:20,1) = NaN ;
baseline_SMA_GABA_water_PA_group = [baseline_SMA_GABA_water_active,baseline_SMA_GABA_water_inactive] ;

for x = 1:size(baseline_SMA_GABA_water_active,1)
plot(xaxis_group,baseline_SMA_GABA_water_PA_group(x,:),'*k') ; 
hold on;
end

title('Baseline SMA GABA/water concentration between high/low PA groups')
xlabel('PA group')
ylabel('Baseline SMA GABA/water')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Active','Inactive'},'xtick',1:2) ;

%% Pre - post comparisons

% ALL WRONG - need to take partial volume corrected values 

%%%%%%% GABA/WATER %%%%%%%%%%
xaxis_time = [1,2] ; 
figure('color','w') ;

%PTL group - participants who received PTL rTMS

idx_ptl = corr_output_GABA.Stim_cond_num == 1 ;

% PTL pre and post GABA/water
subplot(2,3,1)

PTL_GABA_water_PTL_idx = PTL_pre_post_GABA_water(idx_ptl,:) ; 

for x = 1:size(PTL_GABA_water_PTL_idx,1)
    plot(xaxis_time,PTL_GABA_water_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('PTL GABA/H2O following PTL rTMS')
xlabel('Time') ;
ylabel('PTL GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/water 
subplot(2,3,2)

SMA_GABA_water_PTL_idx = SMA_pre_post_GABA_water(idx_ptl,:) ;

for x = 1:size(SMA_GABA_water_PTL_idx,1)
    plot(xaxis_time,SMA_GABA_water_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/H2O following PTL rTMS')
xlabel('Time') ;
ylabel('SMA GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/water
subplot(2,3,3)

HP_GABA_water_PTL_idx = HP_pre_post_GABA_water(idx_ptl,:) ; 

for x = 1:size(HP_GABA_water_PTL_idx,1)
    plot(xaxis_time,HP_GABA_water_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('HP GABA/H2O following PTL rTMS')
xlabel('Time') ; 
ylabel('HP GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%SMA group - participants who received SMA rTMS

idx_sma = corr_output_GABA.Stim_cond_num == 2 ; % Logical index for SMA subjects

% PTL pre and post GABA/water
subplot(2,3,4)

PTL_GABA_water_SMA_idx = PTL_pre_post_GABA_water(idx_sma,:) ; 

for x = 1:size(PTL_GABA_water_SMA_idx,1)
    plot(xaxis_time,PTL_GABA_water_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/H2O following SMA rTMS')
xlabel('Time') ;
ylabel('PTL GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/water 
subplot(2,3,5)

SMA_GABA_water_SMA_idx = SMA_pre_post_GABA_water(idx_sma,:) ;

for x = 1:size(SMA_GABA_water_SMA_idx,1)
    plot(xaxis_time,SMA_GABA_water_SMA_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/H2O following SMA rTMS')
xlabel('Time') ;
ylabel('SMA GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/water
subplot(2,3,6)

HP_GABA_water_SMA_idx = HP_pre_post_GABA_water(idx_sma,:) ; 

for x = 1:size(HP_GABA_water_SMA_idx,1)
    plot(xaxis_time,HP_GABA_water_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/H2O following SMA rTMS')
xlabel('Time') ;
ylabel('HP GABA/H2O') ;
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;


%%%%%%% GABA/cr %%%%%%%%%%

figure('color','w');

%PTL group - participants who received PTL rTMS

idx_ptl = corr_output_GABA.Stim_cond_num == 1 ;

% PTL pre and post GABA/cr
subplot(2,3,1)

PTL_GABA_cr_PTL_idx = PTL_pre_post_GABA_cr(idx_ptl,:) ; 

for x = 1:size(PTL_GABA_cr_PTL_idx,1)
    plot(xaxis_time,PTL_GABA_cr_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/cr following PTL rTMS')
xlabel('Time')
ylabel('PTL GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/cr 
subplot(2,3,2)

SMA_GABA_cr_PTL_idx = SMA_pre_post_GABA_cr(idx_ptl,:) ;

for x = 1:size(SMA_GABA_cr_PTL_idx,1)
    plot(xaxis_time,SMA_GABA_cr_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/cr following PTL rTMS')
xlabel('Time')
ylabel('SMA GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/cr
subplot(2,3,3)

HP_GABA_cr_PTL_idx = HP_pre_post_GABA_cr(idx_ptl,:) ; 

for x = 1:size(HP_GABA_cr_PTL_idx,1)
    plot(xaxis_time,HP_GABA_cr_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/cr following PTL rTMS')
xlabel('Time')
ylabel('HP GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%SMA group - participants who received SMA rTMS

% PTL pre and post GABA/cr
subplot(2,3,4)

PTL_GABA_cr_SMA_idx = PTL_pre_post_GABA_cr(idx_sma,:) ; 

for x = 1:size(PTL_GABA_cr_SMA_idx,1)
    plot(xaxis_time,PTL_GABA_cr_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/cr following SMA rTMS')
xlabel('Time')
ylabel('PTL GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/cr
subplot(2,3,5)

SMA_GABA_cr_SMA_idx = SMA_pre_post_GABA_cr(idx_sma,:) ;

for x = 1:size(SMA_GABA_cr_SMA_idx,1)
    plot(xaxis_time,SMA_GABA_cr_SMA_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/cr following SMA rTMS')
xlabel('Time')
ylabel('SMA GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/cr
subplot(2,3,6)

HP_GABA_cr_SMA_idx = HP_pre_post_GABA_cr(idx_sma,:) ; 

for x = 1:size(HP_GABA_cr_SMA_idx,1)
    plot(xaxis_time,HP_GABA_cr_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/cr following SMA rTMS')
xlabel('Time')
ylabel('HP GABA/cr')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%%%%% GABA/NAA %%%%%%%% 

figure('color','w');

%PTL group - participants who received PTL rTMS

idx_ptl = corr_output_GABA.Stim_cond_num == 1 ;

% PTL pre and post GABA/NAA
subplot(2,3,1)

PTL_GABA_NAA_PTL_idx = PTL_pre_post_GABA_NAA(idx_ptl,:) ; 

for x = 1:size(PTL_GABA_NAA_PTL_idx,1)
    plot(xaxis_time,PTL_GABA_NAA_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/NAA following PTL rTMS')
xlabel('Time')
ylabel('PTL GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/NAA 
subplot(2,3,2)

SMA_GABA_NAA_PTL_idx = SMA_pre_post_GABA_NAA(idx_ptl,:) ;

for x = 1:size(SMA_GABA_NAA_PTL_idx,1)
    plot(xaxis_time,SMA_GABA_NAA_PTL_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/NAA following PTL rTMS')
xlabel('Time')
ylabel('SMA GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/NAA
subplot(2,3,3)

HP_GABA_NAA_PTL_idx = HP_pre_post_GABA_NAA(idx_ptl,:) ; 

for x = 1:size(HP_GABA_NAA_PTL_idx,1)
    plot(xaxis_time,HP_GABA_NAA_PTL_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/NAA following PTL rTMS')
xlabel('Time')
ylabel('HP GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

%SMA group - participants who received SMA rTMS

% PTL pre and post GABA/cr
subplot(2,3,4)

PTL_GABA_NAA_SMA_idx = PTL_pre_post_GABA_NAA(idx_sma,:) ;

for x = 1:size(PTL_GABA_NAA_SMA_idx,1)
    plot(xaxis_time,PTL_GABA_NAA_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('PTL GABA/NAA following SMA rTMS')
xlabel('Time')
ylabel('PTL GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% SMA pre and post GABA/NAA
subplot(2,3,5)

SMA_GABA_NAA_SMA_idx = SMA_pre_post_GABA_NAA(idx_sma,:) ;

for x = 1:size(SMA_GABA_NAA_SMA_idx,1)
    plot(xaxis_time,SMA_GABA_NAA_SMA_idx(x,:),'.-k') ;
    hold on;
end

title('SMA GABA/NAA following SMA rTMS')
xlabel('Time')
ylabel('SMA GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;

% HP pre and post GABA/cr
subplot(2,3,6)

HP_GABA_NAA_SMA_idx = HP_pre_post_GABA_NAA(idx_sma,:) ; 

for x = 1:size(HP_GABA_NAA_SMA_idx,1)
    plot(xaxis_time,HP_GABA_NAA_SMA_idx(x,:),'k.-') ;
    hold on;
end

title('HP GABA/NAA following SMA rTMS')
xlabel('Time')
ylabel('HP GABA/NAA')
set(gca,'XLimMode','manual','XLim',[0.5,2.5],'box','off','tickdir','out','XTickLabel',{'Pre','Post'},'xtick',1:2) ;