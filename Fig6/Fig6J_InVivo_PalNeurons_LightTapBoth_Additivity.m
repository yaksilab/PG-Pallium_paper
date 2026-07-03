%% Plotting the fraction of neurons exhibiting additivity or depression (Fig. 6J)
%This script plots the fraction of neurons classified by their interaction index (this measure quantify the amount of additivity of the neuron's response).
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
%% Quantifying additivity in integrative neurons only
Perc_superAdd_Pal=[];
Perc_depressed_Pal=[];
Perc_subAdd_Pal=[];
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'} 
    idx_posResp_Integrative=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.bothStim.idx_pos_integrative;

    temp_interact_code=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.interact_code;
    idx_superAdd=idx_posResp_Integrative(find(temp_interact_code(idx_posResp_Integrative)==2));
    idx_depressed=idx_posResp_Integrative(find(temp_interact_code(idx_posResp_Integrative)==-1));
    idx_subAdd=idx_posResp_Integrative(find(temp_interact_code(idx_posResp_Integrative)==0));

    %Finding the percentage of enhanced/suppressed cells in the pallium
    perc_superAdd=numel(idx_superAdd)/numel(idx_posResp_Integrative);
    perc_depressed=numel(idx_depressed)/numel(idx_posResp_Integrative);
    perc_subAdd=numel(idx_subAdd)/numel(idx_posResp_Integrative);

    %Saving
    Perc_superAdd_Pal=[Perc_superAdd_Pal;perc_superAdd];
    Perc_depressed_Pal=[Perc_depressed_Pal;perc_depressed];
    Perc_subAdd_Pal=[Perc_subAdd_Pal;perc_subAdd];

end

% Mean & SEM for bar graph
m_Perc_superAdd_Pal=mean(Perc_superAdd_Pal,1,"omitnan");
m_Perc_depressed_Pal=mean(Perc_depressed_Pal,1,"omitnan");
m_Perc_subAdd_Pal=mean(Perc_subAdd_Pal,1,"omitnan");

sem_Perc_superAdd_Pal=std(Perc_superAdd_Pal,"omitnan")/sqrt(length(Perc_superAdd_Pal));
sem_Perc_depressed_Pal=std(Perc_depressed_Pal,"omitnan")/sqrt(length(Perc_depressed_Pal));
sem_Perc_subAdd_Pal=std(Perc_subAdd_Pal,"omitnan")/sqrt(length(Perc_subAdd_Pal));


%% Plotting the data (integrative cells only)
%Regrouping the data
data=[m_Perc_depressed_Pal;...
    m_Perc_subAdd_Pal;...
    m_Perc_superAdd_Pal];
data=data*100;
sem=[sem_Perc_depressed_Pal;...
    sem_Perc_subAdd_Pal;...
    sem_Perc_superAdd_Pal];
sem=sem*100;
all_data=[Perc_depressed_Pal,...
    Perc_subAdd_Pal,...
    Perc_superAdd_Pal];
all_data=all_data*100;
   
%Color
color=[0.301960784313725	0.745098039215686	0.933333333333333;... %light blue
    0.635294117647059	0.0784313725490196	0.184313725490196;...     %dark red
    0.9294    0.6941    0.1255];    %gold

%Making the bar plot
y=[1:3];
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 6 8];
b=bar(y,data,0.75,'FaceColor','flat',CData=color);
ylim([0 90]);
ylabel('Integrative Pallial neurons (%)');
set(gca, 'XTickLabel', {'Depressed','Sub-Additive','Super-Additive'});
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

a=0; % counter
%Adding the data points
for i=1:size(y,2)
    for j=1:nbars
        a=a+1;
        temp=repmat(all_data(:,a),1);
        temp(:,2)=b(j).XEndPoints(i);
        scatter(temp(:,2),temp(:,1),20,'MarkerEdgeColor','k','LineWidth',1);
    end
end
hold off


%for saving as a .svg file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Calculating the statistics (Rank sum test)
%input: all_data where the data in each column is compared with another column
%output: p_val_final for the comparison between groups
%comparison was only done on the excited neurons

p_val=nan(size(all_data,2),size(all_data,2));
h_val=nan(size(all_data,2),size(all_data,2));
for i=1:size(p_val,1)
    for j=1:size(p_val,1)
        [p,h] = ranksum(all_data(:,i),all_data(:,j));
        p_val(i, j) = p;
        h_val(i,j)=h;
    end
end
p_val_final=[p_val(1,2);p_val(1,3)];