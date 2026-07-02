%% Plotting the fraction of reliable Pallial neurons across hemispheres following PG stimulation (ex-vivo) (Fig 4E)
%This script generates a bar plot illustrating the fraction of reliable Pallial neurons (neurons with a high "across-trial" correlations) 
% following an electrical PG micro-stimulation (ex-vivo).

%The "across-trial" correlations and p-values of the Pallial neurons were obtained using the script: ExVivo_Pallium_PGStim_RespondingCells.m
%Each section of this script must be run indivudally in proper order.
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
%% Finding the percentages of reliable Pallial neurons across fish
%Defining the variables
HighCorr_all=[];
alpha=0.1; %change p-Value threshold here

a=1; %counter for number of fish
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
    b=1; %counter for hemisphere
    for hemisphere=1:2
            %Loading the across-trials correlations and p-values
            Corr_Pal=Analysis_PG_Stim_Filt.(fish{1}).all.all_cell_avg_corr;
            pVal_Pal=Analysis_PG_Stim_Filt.(fish{1}).all.all_cell_corr_pVal;

            idx_hemisphere_Pal=Pallium_PGStim.(fish{1}).hemisphereIndex;

            %P-Value
            idx_highCorr=find(pVal_Pal<=alpha);

            %Limiting the correlations to those that have a p-Value < alpha        
            temp_hemisphere_Corr=idx_hemisphere_Pal(idx_highCorr);                    
            neurons_Corr_hemisphere=find(temp_hemisphere_Corr==hemisphere);
            
            %Finding the indices of all pallial neurons per hemisphere
            neuron_hemisphere=find(idx_hemisphere_Pal==hemisphere);

            %Calculating the percentage of reliable neurons
            perc_Corr_hemisphere=numel(neurons_Corr_hemisphere)/numel(neuron_hemisphere);
            %Saving the            
            HighCorr_all(a,b)=perc_Corr_hemisphere;           
       
    
    b=b+1;
    end
a=a+1;        
end
%Reorganizing the data for the figure (contra/ipsi: right/left columns)
HighCorr_all(:,[1,2])=HighCorr_all(:,[2, 1]);
%% Regrouping the data, Mean + SEM
m_HighCorr_all=mean(HighCorr_all,1,"omitnan");
sem_HighCorr_all=std(HighCorr_all,0,1,"omitnan")/sqrt(size(HighCorr_all,1));

%% Making the bar graph for the reliable Pallial neurons (Fig. 4E)

%Color Definition
color=[0.164705882352941	0.474509803921569	0.552941176470588; 0.37777892,  0.79178146,  0.3779385]; %dark blue and green

%Defining the data
data=[HighCorr_all(:,1),HighCorr_all(:,2)];
data=data*100;
data_avg=m_HighCorr_all';
data_avg=data_avg*100;
sem=sem_HighCorr_all';
sem=sem*100;

x=[1:size(data,2)];
y=[1:size(data_avg,1)];

%Creating the figure
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 5 6];
b=bar(y,data_avg,0.7,'faceColor','flat');
% b(1).FaceColor=[1.0 0 0]; %red
b.CData=color;
b.FaceAlpha = 0.75;
hold on

%Plot the scatter dots
g=0;
for g=1:size(y,2)
    scatter(x(g),data(:,g),20,'MarkerEdgeColor','k','LineWidth',1);
end

%Plot the lines
for exp=1:size(data, 1)
    plot([x(1) x(2)], [data(exp,1), data(exp,2)], 'Color', 'k')
end

% Plot the errorbars
errorbar(x',data_avg,sem,'k','linestyle','none','LineWidth',1,'CapSize',10);

%Figure parameters
xlim([0 size(HighCorr_all,2)+1]);
ylim([-2 20]); %p-Value
set(gca, 'xTickLabel', {'Contra','Ipsi'});
ylabel('Reliable Pallial neurons (%)');
box off;

%for saving as a .svg file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Stats for reliable neurons (signed rank)
p_val=nan(size(data,2),size(data,2));
h_val=nan(size(data,2),size(data,2));
for i=1:size(p_val,1)
    for j=1:size(p_val,1)
        [p,h] = signrank(data(:,i),data(:,j));
        p_val(i, j) = p;
        h_val(i,j)=h;
    end
end
p_val_final_reliable=[p_val(1,2)];