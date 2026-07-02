%% Plots the Cluster fidelity percentages for the PG neurons as a bar graph (Fig. 2E, S4G)
%This scripts plots the cluster fidelity (percentage of neurons remaining in the same cluster across different time periods).
%This script needs to be run by individual section.
%The p_val_final variable contains the finals p-values used for the manuscript.

%Input:
% Analysis file: 202606_PGNeurons_AnalysisKmeans.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (a_path) here:
a_path='C:\Users\Documents\...\2P_PGNeurons';
fileName_analysis = '202606_PGNeurons_AnalysisKmeans.mat';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);
%% Plotting the Bargraph for Spontaenous (ongoing) data (Fig. 2E)
%Cluster fidelity of spontaneous period 1 vs period 2
%Cluster fidelity (%) is then compared to a shuffled distribution

m_perc_clust_fidel_spont=mean(perc_clust_fidel_spont,1);
m_perc_clust_fidel_spont_shuffle=mean(perc_clust_fidel_spont_shuffle,1);

sem_perc_clust_fidel_spont=std(perc_clust_fidel_spont)/sqrt(length(perc_clust_fidel_spont));
sem_perc_clust_fidel_spont_shuffle=std(perc_clust_fidel_spont_shuffle)/sqrt(length(perc_clust_fidel_spont_shuffle));

%organizing spontaneous (ongoing) data
y=1;
data=[m_perc_clust_fidel_spont m_perc_clust_fidel_spont_shuffle];
sem=[sem_perc_clust_fidel_spont sem_perc_clust_fidel_spont_shuffle];
all_data=[perc_clust_fidel_spont, perc_clust_fidel_spont_shuffle];
   
%Plotting the figure
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 5 6];
b=bar(y,data,0.65,'grouped');
b(1).FaceColor=[0.45 0.45 0.45]; %light black
b(2).FaceColor=[0.8 0.8 0.8]; %gray
ylim([0 60]); %default
ylabel('Cluster fidelity (%)');
set(gca, 'XTickLabel', {'Spontaneous'}); %for spontaneous comparison
box off;

hold on

% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(data);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',data,sem,'k','linestyle','none','LineWidth',1,'CapSize',10);

%Adding the data points
a=0; % counter
for i=1:size(y,2)
    for j=1:2
        a=a+1;
        temp=repmat(all_data(:,a),1);
        temp(:,2)=b(j).XEndPoints(i);
        scatter(temp(:,2),temp(:,1),20,'MarkerEdgeColor','k','LineWidth',1);
    end
end
%Adding the lines between pairs
a=0; % counter
for k=1:size(y,2)
    for exp=1:size(all_data, 1)
        plot([b(1).XEndPoints(k) b(2).XEndPoints(k)], [all_data(exp,k+a), all_data(exp,k+a+1)], 'Color', 'k')    
    end
    a=a+1; %counter
end
hold off

% title('Cluster Fidelity of PG neurons - Spontaneous Period 1 vs Spontaneous Period 2');
legend('Stim','Shuffled'); %for stim data

set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Stats (paired data - signrank)
%input: all_data where the data in each column is compared with another column
%output: p_val_final for the pairwise comparison
%comparison was only done on the excited neurons
p_val_final=[];
p_val=nan(size(all_data,2),size(all_data,2));
h_val=nan(size(all_data,2),size(all_data,2));
for i=1:size(p_val,1)
    for j=1:size(p_val,1)
        [p,h] = signrank(all_data(:,i),all_data(:,j));
        p_val(i, j) = p;
        h_val(i,j)=h;
    end
end
p_val_final=[p_val(1,2)];

%% Plotting the Bargraph for Stim data (Suppl. fig. 4G)
%Cluster fidelity of spontaneous period vs stim period
%Cluster fidelity (%) is then compared to a shuffled distribution

%Calculating the average
m_perc_clust_fidel_light=mean(perc_clust_fidel_light,1);
m_perc_clust_fidel_light_shuffle=mean(perc_clust_fidel_light_shuffle,1);
m_perc_clust_fidel_tap=mean(perc_clust_fidel_tap,1);
m_perc_clust_fidel_tap_shuffle=mean(perc_clust_fidel_tap_shuffle,1);

%Calculating the standard error of the mean
sem_perc_clust_fidel_light=std(perc_clust_fidel_light)/sqrt(length(perc_clust_fidel_light));
sem_perc_clust_fidel_light_shuffle=std(perc_clust_fidel_light_shuffle)/sqrt(length(perc_clust_fidel_light_shuffle));
sem_perc_clust_fidel_tap=std(perc_clust_fidel_tap)/sqrt(length(perc_clust_fidel_tap));
sem_perc_clust_fidel_tap_shuffle=std(perc_clust_fidel_tap_shuffle)/sqrt(length(perc_clust_fidel_tap_shuffle));

%organizing stim data
y=[1:2];
data=[m_perc_clust_fidel_light m_perc_clust_fidel_light_shuffle; m_perc_clust_fidel_tap m_perc_clust_fidel_tap_shuffle];
sem=[sem_perc_clust_fidel_light sem_perc_clust_fidel_light_shuffle; sem_perc_clust_fidel_tap sem_perc_clust_fidel_tap_shuffle];
all_data=[perc_clust_fidel_light,perc_clust_fidel_light_shuffle,perc_clust_fidel_tap,perc_clust_fidel_tap_shuffle];

%Plotting the figure   
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 5 6];
b=bar(y,data,'FaceColor','flat'); 
b(1).CData(1,:)=[0.945098039215686	0.352941176470588	0.160784313725490]; %orange
b(2).CData(1,:)=[0.8 0.8 0.8]; %gray

b(1).CData(2,:)=[0	0.654901960784314	0.615686274509804]; %teal
b(2).CData(2,:)=[0.8 0.8 0.8]; %gray

% ylim([10 35]); %default
ylim([10 30]);
ylabel('Cluster fidelity (%)');
set(gca, 'XTickLabel', {'Light','Vibration'}); %for stim data
box off;

hold on

% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(data);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',data,sem,'k','linestyle','none','LineWidth',1,'CapSize',10);

%Adding the data points
a=0; % counter
for i=1:size(y,2)
    for j=1:2
        a=a+1;
        temp=repmat(all_data(:,a),1);
        temp(:,2)=b(j).XEndPoints(i);
        scatter(temp(:,2),temp(:,1),20,'MarkerEdgeColor','k','LineWidth',1);
    end
end
%Adding the lines between pairs
a=0; % counter
for k=1:size(y,2)
    for exp=1:size(all_data, 1)
        plot([b(1).XEndPoints(k) b(2).XEndPoints(k)], [all_data(exp,k+a), all_data(exp,k+a+1)], 'Color', 'k')    
    end
    a=a+1; %counter
end
hold off

% title('Cluster Fidelity of PG neurons - Spontaneous to Stim period');
legend('Stim','Shuffled'); %for stim data

set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');


%% Stats (paired data - signrank)
%input: all_data where the data in each column is compared with another column
%output: p_val_final for the pairwise comparison
%comparison was only done on the excited neurons
p_val_final=[];
p_val=nan(size(all_data,2),size(all_data,2));
h_val=nan(size(all_data,2),size(all_data,2));
for i=1:size(p_val,1)
    for j=1:size(p_val,1)
        [p,h] = signrank(all_data(:,i),all_data(:,j));
        p_val(i, j) = p;
        h_val(i,j)=h;
    end
end
p_val_final=[p_val(1,2);p_val(3,4)];