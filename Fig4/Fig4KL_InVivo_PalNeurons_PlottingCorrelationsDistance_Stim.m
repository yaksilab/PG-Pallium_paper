%% Plotting the Pairwise correlations as a function of distance during sensory stimulation (Fig. 4K, 4L)
%This scripts plots the parwise neuron-to-neuron correlations for all Pallial neurons as a function of distance between neuron pairs during sensory stimulation.
%This script needs to be run by individual section.
%Adapted from Bartoszek et al., 2021 & Ostenrath et al., 2025

%Input:
% Analysis file: 202606_PalNeurons_SpatialCorr.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (a_path) here:
a_path='C:\Users\Documents\...\2P_InVivo_PalNeurons'; 
fileName_data = '202606_PalNeurons_SpatialCorr.mat';
data_path=fullfile(a_path,fileName_data);
load(data_path);
%% Grouping the data
distShufCorrL=[];
distShufCorrT=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
    temp3=spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.distShufCorr;
    temp4=spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.distShufCorr;
    distShufCorrL=[distShufCorrL;temp3;temp4];
    temp5=spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.distShufCorr;
    temp6=spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.distShufCorr;
    distShufCorrT=[distShufCorrT;temp5;temp6];
end

distCorrL=[];
distCorrT=[];
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
    temp3=spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.distCorr;
    temp4=spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.distCorr;
    distCorrL=[distCorrL;temp3;temp4];
    temp5=spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.distCorr;
    temp6=spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.distCorr;
    distCorrT=[distCorrT;temp5;temp6];
end

%% Finding the mean and standard error of the mean (SEM)
%Calculating the average
%Light
m_distShufCorrL=mean(distShufCorrL,1,"omitnan");
m_distCorrL=mean(distCorrL,1,"omitnan");

%Vibration
m_distShufCorrT=mean(distShufCorrT,1,"omitnan");
m_distCorrT=mean(distCorrT,1,"omitnan");

%Calculating the SEM
%Light
sem_distShufCorrL=std(distShufCorrL,"omitnan")/sqrt(length(distShufCorrL));
sem_distCorrL=std(distCorrL,"omitnan")/sqrt(length(distCorrL));

%Vibration
sem_distShufCorrT=std(distShufCorrT,"omitnan")/sqrt(length(distShufCorrT));
sem_distCorrT=std(distCorrT,"omitnan")/sqrt(length(distCorrT));

%% Plotting the figure for the Light responding period (Fig. 4K)

%defining the colors
dgray=[0.57 0.57 0.57];
orange=[0.945098039215686	0.352941176470588	0.160784313725490];
teal=[0	0.654901960784314	0.615686274509804];

%defining the bin size for the x axis
steps = floor(linspace(0,200,51)); 

f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 5 6];
shadedErrorBar(steps(2:end),m_distCorrL,sem_distCorrL,'lineprops',{'Color',orange});
hold on
shadedErrorBar(steps(2:end),m_distShufCorrL,sem_distShufCorrL, 'lineprops', {'LineStyle','--','Color',dgray});
ylabel ('Pairwise correlation'); 
xlabel('Distance (um)');
ylim([0 0.3]);
xlim([0 200]);
% legend(' ',' ',' ','Data',' ','','','Shuffle');
set(gca, 'XTick', [0:40:200]);
set(gca, 'YTick', [0:0.05:0.3]);

%for exporting the figure as .svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Plotting the figure for the Vibration responding period (Fig. 4L)
%defining the bin size for the x axis
steps = floor(linspace(0,200,51));  

f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 5 6];
shadedErrorBar(steps(2:end),m_distCorrT,sem_distCorrT,'lineprops',{'Color',teal});
hold on
shadedErrorBar(steps(2:end),m_distShufCorrT,sem_distShufCorrT, 'lineprops', {'LineStyle','--','Color',dgray});
ylabel ('Pairwise correlation'); 
xlabel('Distance (um)');
ylim([0 0.3]);
xlim([0 200]);
% legend(' ',' ',' ','Data',' ','','','Shuffle');
set(gca, 'XTick', [0:40:200]);
set(gca, 'YTick', [0:0.05:0.3]);

%for exporting the figure as .svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
