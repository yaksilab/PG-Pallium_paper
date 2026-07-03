%% Plotting the mean traces of neurons exhibiting additivity or depression (Fig. 6G)
%This script plots the mean activity trace of all neurons classified by their interaction index across all 3 conditions (light, vib, light + vib): 
%this index measures quantify the amount of additivity of the neuron's response across all fish (N = 10fish).
%The indices of the classified Integrative Pallial neurons were obtained using the script: InVivo_PalNeurons_LightTapBoth_Additivity.m
%Each section of this script must be run indivudally in proper order.

%Input:
% Data file: 202606_PalNeurons_LightTapBoth_Data.mat
% Analysis file (indices): 202606_PalNeurons_LightTapBoth_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path='C:\Users\Documents\...\2P_InVivo_PalNeurons'; 
fileName_data = '202606_PalNeurons_LightTapBoth_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_InVivo_PalNeurons';
fileName_analysis = '202606_PalNeurons_LightTapBoth_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);
%% Regrouping the average neural acitivty according to their classified identity across all cells per animal
%Defining the variables
avg_traces_SuperAdd_light=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);
avg_traces_SuperAdd_vib=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);
avg_traces_SuperAdd_multimod=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);

avg_traces_Depressed_light=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);
avg_traces_Depressed_vib=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);
avg_traces_Depressed_multimod=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);

avg_traces_SubAdd_light=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);
avg_traces_SubAdd_vib=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);
avg_traces_SubAdd_multimod=nan(size(PalNeurons.fish1.TrialDFF_filt,1),10);

i=1; %for counting across fish
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
% for fish={'fish1'}
    idx_superAdd=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.idx_superAdd;
    idx_depressed=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.idx_depressed;
    idx_subAdd=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.idx_subAdd;

    traces_Pal=PalNeurons.(fish{1}).TrialDFF_filt;  

    %Finding the traces
    idx_traces_SuperAdd_Pal=traces_Pal(:,:,idx_superAdd);
    idx_traces_Depressed_Pal=traces_Pal(:,:,idx_depressed);
    idx_traces_SubAdd_Pal=traces_Pal(:,:,idx_subAdd);

    %Finding the mean activity traces across all neurons per animal
    stim_cond=PalNeurons.(fish{1}).stim_cond;

    m_light_SuperAdd_traces=mean(squeeze(mean(idx_traces_SuperAdd_Pal(:,stim_cond(:,1),:),2,"omitnan")),2,"omitnan");
    m_vib_SuperAdd_traces=mean(squeeze(mean(idx_traces_SuperAdd_Pal(:,stim_cond(:,2),:),2,"omitnan")),2,"omitnan");
    m_multimod_SuperAdd_traces=mean(squeeze(mean(idx_traces_SuperAdd_Pal(:,stim_cond(:,3),:),2,"omitnan")),2,"omitnan");
    
    m_light_Depressed_traces=mean(squeeze(mean(idx_traces_Depressed_Pal(:,stim_cond(:,1),:),2,"omitnan")),2,"omitnan");
    m_vib_Depressed_traces=mean(squeeze(mean(idx_traces_Depressed_Pal(:,stim_cond(:,2),:),2,"omitnan")),2,"omitnan");
    m_multimod_Depressed_traces=mean(squeeze(mean(idx_traces_Depressed_Pal(:,stim_cond(:,3),:),2,"omitnan")),2,"omitnan");
    
    m_light_subAdd_traces=mean(squeeze(mean(idx_traces_SubAdd_Pal(:,stim_cond(:,1),:),2,"omitnan")),2,"omitnan");
    m_tap_subAdd_traces=mean(squeeze(mean(idx_traces_SubAdd_Pal(:,stim_cond(:,2),:),2,"omitnan")),2,"omitnan");
    m_multimod_subAdd_traces=mean(squeeze(mean(idx_traces_SubAdd_Pal(:,stim_cond(:,3),:),2,"omitnan")),2,"omitnan");

    %Saving the average traces
    avg_traces_SuperAdd_light(:,i)=m_light_SuperAdd_traces;
    avg_traces_SuperAdd_vib(:,i)=m_vib_SuperAdd_traces;
    avg_traces_SuperAdd_multimod(:,i)=m_multimod_SuperAdd_traces;
    
    avg_traces_Depressed_light(:,i)=m_light_Depressed_traces;
    avg_traces_Depressed_vib(:,i)=m_vib_Depressed_traces;
    avg_traces_Depressed_multimod(:,i)=m_multimod_Depressed_traces;

    avg_traces_SubAdd_light(:,i)=m_light_subAdd_traces;
    avg_traces_SubAdd_vib(:,i)=m_tap_subAdd_traces;
    avg_traces_SubAdd_multimod(:,i)=m_multimod_subAdd_traces;
     
    i=i+1;
end

%% Plotting the mean activity traces across animals across all 3 conditions (light, vib, light + vib)
%Defining the colors
gray=[0.8 0.8 0.8];
orange=[0.945098039215686	0.352941176470588	0.160784313725490];
teal=[0	0.654901960784314	0.615686274509804];
gold=[0.9294    0.6941    0.1255];

%Calculating the mean activity (and SEM) across animals for each classified cell type
frame_rate=PalNeurons.fish1.volume_rate;
stim_onset=ceil(5*frame_rate);

%Cells classified as super-additive
m_avg_SuperAdd_light=mean(avg_traces_SuperAdd_light,2,"omitnan");
m_avg_SuperAdd_vib=mean(avg_traces_SuperAdd_vib,2,"omitnan");
m_avg_SuperAdd_multimod=mean(avg_traces_SuperAdd_multimod,2,"omitnan");

sem_avg_SuperAdd_light=std(avg_traces_SuperAdd_light',0,"omitnan")/sqrt(length(avg_traces_SuperAdd_light'));
sem_avg_SuperAdd_vib=std(avg_traces_SuperAdd_vib',0,"omitnan")/sqrt(length(avg_traces_SuperAdd_vib'));
sem_avg_SuperAdd_multimod=std(avg_traces_SuperAdd_multimod',0,"omitnan")/sqrt(length(avg_traces_SuperAdd_multimod'));

%Cells classified as depressed
m_avg_Depressed_light=mean(avg_traces_Depressed_light,2,"omitnan");
m_avg_Depressed_vib=mean(avg_traces_Depressed_vib,2,"omitnan");
m_avg_Depressed_multimod=mean(avg_traces_Depressed_multimod,2,"omitnan");

sem_avg_Depressed_light=std(avg_traces_Depressed_light',0,"omitnan")/sqrt(length(avg_traces_Depressed_light'));
sem_avg_Depressed_vib=std(avg_traces_Depressed_vib',0,"omitnan")/sqrt(length(avg_traces_Depressed_vib'));
sem_avg_Depressed_multimod=std(avg_traces_Depressed_multimod',0,"omitnan")/sqrt(length(avg_traces_Depressed_multimod'));

%Cells classified as sub-additive
m_avg_subAdd_light=mean(avg_traces_SubAdd_light,2,"omitnan");
m_avg_subAdd_vib=mean(avg_traces_SubAdd_vib,2,"omitnan");
m_avg_subAdd_multimod=mean(avg_traces_SubAdd_multimod,2,"omitnan");

sem_avg_subAdd_light=std(avg_traces_SubAdd_light',0,"omitnan")/sqrt(length(avg_traces_SubAdd_light'));
sem_avg_subAdd_vib=std(avg_traces_SubAdd_vib',0,"omitnan")/sqrt(length(avg_traces_SubAdd_vib'));
sem_avg_subAdd_multimod=std(avg_traces_SubAdd_multimod',0,"omitnan")/sqrt(length(avg_traces_SubAdd_multimod'));


%Plotting the figures
x=[1:size(m_avg_SuperAdd_light,1)];

%Cells classified as super-additive
f1=figure();
f1.Units="centimeters";
f1.Position=[10 15 6 8];
hold on
shadedErrorBar(x,m_avg_SuperAdd_light,sem_avg_SuperAdd_light, 'lineprops', {'Color',orange});
shadedErrorBar(x,m_avg_SuperAdd_vib,sem_avg_SuperAdd_vib, 'lineprops', {'Color',teal});
shadedErrorBar(x,m_avg_SuperAdd_multimod,sem_avg_SuperAdd_multimod, 'lineprops', {'Color',gold});
hold off
ylim([-5 30]);
xlim([0 50]);
xt = get(gca, 'XTick');
xtnew = linspace(min(xt), max(xt), 13);   % New 'XTick' Values
ticks_seconds=floor(xt/frame_rate);
xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks
title('Supra-Additive');
ylabel('DF/F'),
xlabel('time (s)');
xline(stim_onset,'-.k','linewidth', 1);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Cells classified as depressed
f2=figure();
f2.Units="centimeters";
f2.Position=[10 15 6 8];
hold on
shadedErrorBar(x,m_avg_Depressed_light,sem_avg_Depressed_light, 'lineprops', {'Color',orange});
shadedErrorBar(x,m_avg_Depressed_vib,sem_avg_Depressed_vib, 'lineprops', {'Color',teal});
shadedErrorBar(x,m_avg_Depressed_multimod,sem_avg_Depressed_multimod, 'lineprops', {'Color',gold});
hold off
ylim([-5 30]);
xlim([0 50]);
xt = get(gca, 'XTick');
xtnew = linspace(min(xt), max(xt), 13);   % New 'XTick' Values
ticks_seconds=floor(xt/frame_rate);
xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks
title('Deppressed');
ylabel('DF/F'),
xlabel('time (s)');
xline(stim_onset,'-.k','linewidth', 1);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Cells classified as sub-additive
f3=figure();
f3.Units="centimeters";
f3.Position=[10 15 6 8];
hold on
shadedErrorBar(x,m_avg_subAdd_light,sem_avg_subAdd_light, 'lineprops', {'Color',orange});
shadedErrorBar(x,m_avg_subAdd_vib,sem_avg_subAdd_vib, 'lineprops', {'Color',teal});
shadedErrorBar(x,m_avg_subAdd_multimod,sem_avg_subAdd_multimod, 'lineprops', {'Color',gold});
hold off
ylim([-5 30]);
xlim([0 50]);
xt = get(gca, 'XTick');
xtnew = linspace(min(xt), max(xt), 13);   % New 'XTick' Values
ticks_seconds=floor(xt/frame_rate);
xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks
title('Sub-Additive');
ylabel('DF/F'),
xlabel('time (s)');
xline(stim_onset,'-.k','linewidth', 1);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

