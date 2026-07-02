%% Plotting the Pairwise correlations as a function of distance (Fig. 2D, Suppl Fig. 4C)
%This scripts plots the parwise neuron-to-neuron correlations for all PG neurons as a function of distance between neuron pairs.
%This script needs to be run by individual section.
%Adapted from Bartoszek et al., 2021 & Ostenrath et al., 2025

%Input:
% Analysis file: 202606_PGNeurons_SpatialCorr.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (a_path) here:
a_path='\\\forskning.it.ntnu.no\ntnu\mh\kin\yaksi\5\Anh-Tuan\Codes\PG_Manuscript\Datasets\Final\2P_PGNeurons';
fileName_data = '202606_PGNeurons_SpatialCorr.mat';
data_path=fullfile(a_path,fileName_data);
load(data_path);
%% Grouping the data
distShufCorr=[];
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    temp=spatialCorr.PG.(fish{1}).leftHemi.spontAll.distShufCorr;
    temp2=spatialCorr.PG.(fish{1}).rightHemi.spontAll.distShufCorr;
    distShufCorr=[distShufCorr;temp;temp2];

end

distCorr=[];
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    temp=spatialCorr.PG.(fish{1}).leftHemi.spontAll.distCorr;
    temp2=spatialCorr.PG.(fish{1}).rightHemi.spontAll.distCorr;
    distCorr=[distCorr;temp;temp2];
end

distPosCorr=[];
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    temp=spatialCorr.PG.(fish{1}).leftHemi.spontAll.distPosCorr;
    temp2=spatialCorr.PG.(fish{1}).rightHemi.spontAll.distPosCorr;
    distPosCorr=[distPosCorr;temp;temp2];
end

distNegCorr=[];
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    temp=spatialCorr.PG.(fish{1}).leftHemi.spontAll.distNegCorr;
    temp2=spatialCorr.PG.(fish{1}).rightHemi.spontAll.distNegCorr;
    distNegCorr=[distNegCorr;temp;temp2];
end

%% Finding the mean and standard error of the mean (SEM)
%Calculating the average
m_distShufCorr=mean(distShufCorr,1,"omitnan");
m_distCorr=mean(distCorr,1,"omitnan");
m_distPosCorr=mean(distPosCorr,1,"omitnan");
m_distNegCorr=mean(distNegCorr,1,"omitnan");

%Calculating the SEM
sem_distShufCorr=std(distShufCorr,"omitnan")/sqrt(length(distShufCorr));
sem_distCorr=std(distCorr,"omitnan")/sqrt(length(distCorr));
sem_distPosCorr=std(distPosCorr,"omitnan")/sqrt(length(distPosCorr));
sem_distNegCorr=std(distNegCorr,"omitnan")/sqrt(length(distNegCorr));


%% Plotting the figures (Fig 2D and fig. S5D)
close all;
%Defining the colors for plots
red=[1.0 0 0];
dgray=[0.57 0.57 0.57];
blue= [0 0.45 0.74];

%Defining the bin sizes for the graph
steps = floor(linspace(0,120,31)); 

%Making the figure for the entire spontaneous ongoing period - 8 mins for all correlations (Fig. 2D)
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 5 6];
shadedErrorBar(steps(2:end),m_distCorr,sem_distCorr,'lineprops','k');
hold on
shadedErrorBar(steps(2:end),m_distShufCorr,sem_distShufCorr, 'lineprops', {'LineStyle','--','Color',dgray});
ylabel ('Pairwise correlation'); 
xlabel('Distance (um)');
ylim([0 0.2]);
xlim([0 90]);
% title('Correlation as function of distance - Spontaneous');
% legend(' ',' ',' ','Data',' ','','','Shuffle');
set(gca, 'XTick', [0:20:100]);
set(gca, 'YTick', [0:0.04:0.2]);

%for exporting the figure as .svg
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the entire spontaneous ongoing period - 8 mins, seperating the positive and negative correlations (Suppl. fig. 4C)
f2=figure;
f2.Units="centimeters";
f2.Position=[10 15 5.5 6];
shadedErrorBar(steps(2:end),m_distPosCorr, sem_distPosCorr, 'lineprops', {'Color',red});
hold on
shadedErrorBar(steps(2:end),m_distNegCorr, sem_distNegCorr, 'lineprops', {'Color',blue});
yline(0,'-.k');
ylabel ('Pairwise correlation'); 
xlabel('Distance (um)');
ylim([-0.15 0.3]);
xlim([0 90]);
% legend(' ',' ',' ','Positive Corr',' ','','','Negative Corr');
% title('Correlations as function of distance - pos vs neg');
set(gca, 'XTick', [0:20:100]);
set(gca, 'YTick', [-0.15:0.1:0.3]);

%for exporting the figure as .svg
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
