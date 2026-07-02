%% Plots the fraction of multi-sensory units across all datasets (Fig. 5I)
%This scripts plots the fraction of responding units (neurons and axonal pixels) across all datasets as a bar plot.
%This script needs to be run by individual section.
%The p-values for each comparison between datasets is organized in a table variable (T).

%Input:
% Analysis file: 202606_PGNeurons_LightTap_Analysis.mat
% Analysis file: 202606_PGAxons_AnalysisKmeans.mat
% Analysis file: 202606_PalNeurons_LightTapBoth_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (a_path) here:
a_path_PGNeuron='C:\Users\Documents\...\2P_PGNeurons'; 
a_path_PGAxons='C:\Users\Documents\...\2P_PGAxons';
a_path_PalNeurons='C:\Users\Documents\...\2P_InVivo_PalNeurons'; 

%PG Neurons
fileName_PGNeurons = '202606_PGNeurons_LightTap_Analysis.mat';
data_path1=fullfile(a_path_PGNeuron,fileName_PGNeurons);
load(data_path1);

%PG Axons
fileName_PGAxons= '202606_PGAxons_LightTap_Analysis.mat';
data_path2=fullfile(a_path_PGAxons,fileName_PGAxons);
load(data_path2);

%Pallial Neurons
fileName_PalNeurons = '202606_PalNeurons_LightTapBoth_Analysis.mat';
data_path3=fullfile(a_path_PalNeurons,fileName_PalNeurons);
load(data_path3);


%% (Pallium) Regrouping the data
perc_pos_resp_Pallium_multiSens_both=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'} %for Pallium Light/Tap/Both

    idx_Pallium_multiSens_pos=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.idx_pos_multiSens;
    idx_posResp_light_Pallium=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.light.positive_resp_cells;
    idx_posResp_tap_Pallium=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.tap.positive_resp_cells;
    all_resp_pos=[idx_posResp_light_Pallium;idx_posResp_tap_Pallium];
    idx_all_resp_Pallium_pos=unique(all_resp_pos);

    temp_Pallium_multiSens_pos=numel(idx_Pallium_multiSens_pos)/numel(idx_all_resp_Pallium_pos);
   
    perc_pos_resp_Pallium_multiSens_both=[perc_pos_resp_Pallium_multiSens_both; temp_Pallium_multiSens_pos];                    

end

%% Mean & SEM
m_perc_pos_resp_Pallium_multiSens_both=mean(perc_pos_resp_Pallium_multiSens_both,1,"omitnan");
sem_perc_pos_resp_Pallium_multiSens_both=std(perc_pos_resp_Pallium_multiSens_both,"omitnan")/sqrt(length(perc_pos_resp_Pallium_multiSens_both));

%% (PG Axons) Regrouping the data
perc_pos_resp_PGAxons_multiSens_both=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}

    idx_PGAxons_multiSens_pos=Analysis_PGAxons_Filt.(fish{1}).PGAxons.idx_pos_multiSens;
    idx_PosResp_light_PGAxons=Analysis_PGAxons_Filt.(fish{1}).all.light.positive_resp_pixels;
    idx_PosResp_tap_PGAxons=Analysis_PGAxons_Filt.(fish{1}).all.tap.positive_resp_pixels;
    all_resp_pos=[idx_PosResp_light_PGAxons;idx_PosResp_tap_PGAxons];
    idx_resp_pos_PGaxons=unique(all_resp_pos);

    temp_PGAxons_multiSens_pos=numel(idx_PGAxons_multiSens_pos)/numel(idx_resp_pos_PGaxons);
 
    perc_pos_resp_PGAxons_multiSens_both=[perc_pos_resp_PGAxons_multiSens_both; temp_PGAxons_multiSens_pos];                            
   
end

%% Mean & SEM
m_perc_pos_resp_PGAxons_multiSens_both=mean(perc_pos_resp_PGAxons_multiSens_both,1,"omitnan");
sem_perc_pos_resp_PGAxons_multiSens_both=std(perc_pos_resp_PGAxons_multiSens_both,"omitnan")/sqrt(length(perc_pos_resp_PGAxons_multiSens_both));

%% (PG) Regrouping the data
perc_pos_resp_PG_multiSens_both=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}

    idx_PG_multiSens_pos=Analysis_LightTap_Filt.(fish{1}).PG.both.idx_pos_multiSens;
    idx_PosResp_light_PG=Analysis_LightTap_Filt.(fish{1}).all.light.positive_resp_cells;
    idx_PosResp_tap_PG=Analysis_LightTap_Filt.(fish{1}).all.tap.positive_resp_cells;
    all_resp_pos=[idx_PosResp_light_PG;idx_PosResp_tap_PG];
    idx_resp_pos_PG=unique(all_resp_pos);
   
    temp_PG_multiSens_pos=numel(idx_PG_multiSens_pos)/numel(idx_resp_pos_PG);
  
    perc_pos_resp_PG_multiSens_both=[perc_pos_resp_PG_multiSens_both; temp_PG_multiSens_pos]; 
  
end

%% Mean & SEM
m_perc_pos_resp_PG_multiSens_both=mean(perc_pos_resp_PG_multiSens_both,1,"omitnan");
sem_perc_pos_resp_PG_multiSens_both=std(perc_pos_resp_PG_multiSens_both,"omitnan")/sqrt(length(perc_pos_resp_PG_multiSens_both));


%% Plotting the combined figure
%Correcting the data matrices
perc_pos_resp_PG_multiSens_both(12,:)=NaN;
perc_pos_resp_Pallium_multiSens_both(11:12)=NaN;

%positive responding neurons
data=[m_perc_pos_resp_PG_multiSens_both;...
    m_perc_pos_resp_PGAxons_multiSens_both;...
    m_perc_pos_resp_Pallium_multiSens_both];
data=data*100;
sem=[sem_perc_pos_resp_PG_multiSens_both;...
    sem_perc_pos_resp_PGAxons_multiSens_both;...    
    sem_perc_pos_resp_Pallium_multiSens_both];
sem=sem*100;
all_data=[perc_pos_resp_PG_multiSens_both,...
    perc_pos_resp_PGAxons_multiSens_both,...
    perc_pos_resp_Pallium_multiSens_both];
all_data=all_data*100;

%Color: shades of purple
color=[0.705882352941177	0.568627450980392	0.784313725490196;...
    0.486274509803922	0.321568627450980	0.584313725490196;...
    0.321568627450980	0.188235294117647	0.486274509803922];

y=[1:3];
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 6 8];
b=bar(y,data,0.75,'FaceColor','flat',CData=color);
ylim([0 60]);
ylabel('Fraction of multi-sensory responses (%)');
set(gca, 'XTickLabel', {'PG neurons','PG axons','Pallial neurons'});
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

title('Response Selectivity');

%for saving as a .svg file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Stats (Kruskall-Wallis + Dunn's test)
%output: Table array (T) displaying the p-values comparison between groups
group=[];
data_stat=[];
for i=1:size(all_data,2)
    if i==1
        test="PG";
    end
    if i==2
        test="PGAxons";
    end
    if i==3
        test="Pal";
    end
    
    for j=1:size(all_data,1)
        group=[group;test];
    end
    data_stat=[data_stat;all_data(:,i)]; 
end
[p,tbl,stats] = kruskalwallis(data_stat,group);
[c,m,h,names] = multcompare(stats,"CriticalValueType","dunn-sidak");

%Creating the table array with the final p-values
comp_labels = strcat(names(c(:,1)), " vs ", names(c(:,2)));
T = table(comp_labels, c(:,6),'VariableNames', {'Comparison', 'p-Value'})
