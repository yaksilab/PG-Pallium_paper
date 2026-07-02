%% Plotting the fraction of responding Pallial neurons across hemispheres following a PG stimulation (ex-vivo) (Fig 4C)
%This script generates a bar plot illustrating the fraction of responding Pallial neurons following an electrical PG micro-stimulation (ex-vivo).

%The indices of the responding Pallial neurons were obtained using the script: ExVivo_Pallium_PGStim_RespondingCells.m
%Each section of this script must be run indivudally in proper order.
%The final p-values are stored in the variables: "p_val_final_excited" and "p_val_final_inhibited".
%NOTE: the hemisphereIndex variable contains the indices for the hemisphere of each individual neuron
%Legend: 1 = left hemisphere, 2 = right hemisphere

%Input:
% Data file: 202606_PalNeurons_PGStim_Data.mat
% Analysis file (indices): 202606_PalNeurons_PGStim_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path='C:\Users\Documents\...\2P_ExVivo_PalNeurons'; 
fileName_data = '202606_PalNeurons_PGStim_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_ExVivo_PalNeurons'; 
fileName_analysis = '202606_PalNeurons_PGStim_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);
%% Finding the percentages
positive_Resp_all={};
negative_Resp_all={};

a=1; %counter for number of fish
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
    b=1; %counter for hemispheres
    for hemisphere=1:2
        idx_posResp_Pal=Analysis_PG_Stim_Filt.(fish{1}).all.positive_resp_cells;
        idx_negResp_Pal=Analysis_PG_Stim_Filt.(fish{1}).all.negative_resp_cells;        
        hemisphereIdx=Pallium_PGStim.(fish{1}).hemisphereIndex;
        idx_hemisphere=find(hemisphereIdx==hemisphere);
        
        temp_hemisphere_posResp=hemisphereIdx(idx_posResp_Pal);
        temp_hemisphere_negResp=hemisphereIdx(idx_negResp_Pal);

        neurons_pos_hemisphere=find(temp_hemisphere_posResp==hemisphere);
        neurons_negative_hemisphere=find(temp_hemisphere_negResp==hemisphere);

        perc_pos_hemisphere=numel(neurons_pos_hemisphere)/numel(idx_hemisphere);
        perc_negative_hemisphere=numel(neurons_negative_hemisphere)/numel(idx_hemisphere);
                   
        positive_Resp_all{a,b}=perc_pos_hemisphere;
        negative_Resp_all{a,b}=perc_negative_hemisphere;         
        b=b+1; %counter
    end
a=a+1;
        
end

%Regrouping the data
positive_Resp_all=cell2mat(positive_Resp_all);
positive_Resp_all(:,[1,2]) = positive_Resp_all(:,[2,1]);
negative_Resp_all=cell2mat(negative_Resp_all);
negative_Resp_all(:,[1,2]) = negative_Resp_all(:,[2,1]);

%Mean + SEM
m_pos_Resp_all=mean(positive_Resp_all,1,"omitnan");
m_negative_Resp_all=mean(negative_Resp_all,1,"omitnan");

sem_pos_Resp_all=std(positive_Resp_all,0,1,"omitnan")/sqrt(size(positive_Resp_all,1));
sem_negative_Resp_all=std(negative_Resp_all,0,1,"omitnan")/sqrt(size(negative_Resp_all,1));

%% Making the bar graph for the responding Pallial neurons (excited neurons only) (Fig. 4C, top)
%Defining the data
data=[positive_Resp_all(:,1),positive_Resp_all(:,2)];
data=data*100;
data_avg=m_pos_Resp_all';
data_avg=data_avg*100;
sem=sem_pos_Resp_all';
sem=sem*100;

x=[1:size(data,2)];
y=[1:size(data_avg,1)];

%Color
color=[1 0.67 0.67; 1 0 0];

%Plotting the bar graph
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 5 6];
b=bar(y,data_avg,0.7,'faceColor','flat');
b.CData=color;
b.FaceAlpha = 0.75;
xlim([0 size(positive_Resp_all,2)+1]);
ylim([-2 40]);
hold on

g=0;
for g=1:size(data,2)
    scatter(x(g),data(:,g),25,'MarkerEdgeColor','k','LineWidth',1);
end

for exp=1:size(data, 1)
    plot([x(1) x(2)], [data(exp,1), data(exp,2)], 'Color', 'k')
end

% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(data_avg);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',data_avg,sem,'k','linestyle','none','LineWidth',1,'CapSize',10);

set(gca, 'xTickLabel', {'Contra','Ipsi'});
ylabel('Responding Pallial neurons (%)');
box off;

%For saving as a .svg file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Stats for excited neurons (signed rank)
p_val=nan(size(data,2),size(data,2));
h_val=nan(size(data,2),size(data,2));
for i=1:size(p_val,1)
    for j=1:size(p_val,1)
        [p,h] = signrank(data(:,i),data(:,j));
        p_val(i, j) = p;
        h_val(i,j)=h;
    end
end
p_val_final_excited=[p_val(1,2)];

%% Making the bar graph for the responding Pallial neurons (inhibited neurons only) (Fig. 4C, bottom)
%Defining the data
data=negative_Resp_all;
data=data*100;
data_avg=m_negative_Resp_all';
data_avg=data_avg*100;
sem=sem_negative_Resp_all';
sem=sem*100;

x=[1:size(data,2)];
y=[1:size(data_avg,1)];

%Color
color=[0.709803921568628	0.807843137254902	1; 0 0.45 0.74];

%Plotting the bar graph
f2=figure;
f2.Units="centimeters";
f2.Position=[10 15 5 6];
b2=bar(y,data_avg,0.7,'FaceColor','flat');
b2.CData=color;
b2.FaceAlpha = 0.75;
xlim([0 size(negative_Resp_all,2)+1]);
ylim([-2 40]);
hold on

g=0;
for g=1:size(data,2)
    scatter(x(g),data(:,g),25,'MarkerEdgeColor','k','LineWidth',1);
end

for exp=1:size(data, 1)
    plot([x(1) x(2)], [data(exp,1), data(exp,2)], 'Color', 'k')
end

% Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(data_avg);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b2(i).XEndPoints;
end
% Plot the errorbars
errorbar(x',data_avg,sem,'k','linestyle','none','LineWidth',1,'CapSize',10);

set(gca, 'xTickLabel', {'Contra','Ipsi'});
ylabel('Responding Pallial neurons (%)');
box off;

%For saving as a .svg file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
%% Stats for inhibited neurons (signed rank)
p_val=nan(size(data,2),size(data,2));
h_val=nan(size(data,2),size(data,2));
for i=1:size(p_val,1)
    for j=1:size(p_val,1)
        [p,h] = signrank(data(:,i),data(:,j));
        p_val(i, j) = p;
        h_val(i,j)=h;
    end
end
p_val_final_inhibited=[p_val(1,2)];