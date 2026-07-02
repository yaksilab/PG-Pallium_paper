%% Plotting the fraction of responding neurons by response selectivity (Fig. 2K)
%This script plots the fraction of responding neurons seperately depending on their response selectivity.
%The indices of the responding PG neurons were obtained using the script: InVivo_PGOnly_RespondingCells.m
%Each section of this script must be run indivudally in proper order.
%The p_val_final variable contains the finals p-values used for the manuscript.

%Input:
% Analysis file: 202606_PGNeurons_LightTap_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (a_path) here:
a_path='C:\Users\Documents\...\2P_PGNeurons'; 
fileName_analysis = '202606_PGNeurons_LightTap_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);

%% Regrouping the data (Finding the response selectivity of the neurons)
perc_pos_resp_PG_multiSens_both=[];
perc_pos_resp_PG_lightExcl_both=[];
perc_pos_resp_PG_tapExcl_both=[];

perc_neg_resp_PG_multiSens_both=[];
perc_neg_resp_PG_lightExcl_both=[];
perc_neg_resp_PG_tapExcl_both=[];


for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    for choice =1:2
       if choice==1
            temp_PG_multiSens=Analysis_LightTap_Filt.(fish{1}).PG.both.perc_pos_multiSens;
            perc_pos_resp_PG_multiSens_both=[perc_pos_resp_PG_multiSens_both; temp_PG_multiSens];
                            
            temp_PG_lightExcl=Analysis_LightTap_Filt.(fish{1}).PG.both.perc_pos_lightExcl;
            perc_pos_resp_PG_lightExcl_both=[perc_pos_resp_PG_lightExcl_both; temp_PG_lightExcl];
                                                
            temp_PG_tapExcl=Analysis_LightTap_Filt.(fish{1}).PG.both.perc_pos_tapExcl;
            perc_pos_resp_PG_tapExcl_both=[perc_pos_resp_PG_tapExcl_both; temp_PG_tapExcl];
        end

        if choice==2
            temp_PG_multiSens=Analysis_LightTap_Filt.(fish{1}).PG.both.perc_neg_multiSens;
            perc_neg_resp_PG_multiSens_both=[perc_neg_resp_PG_multiSens_both; temp_PG_multiSens];
                            
            temp_PG_lightExcl=Analysis_LightTap_Filt.(fish{1}).PG.both.perc_neg_lightExcl;
            perc_neg_resp_PG_lightExcl_both=[perc_neg_resp_PG_lightExcl_both; temp_PG_lightExcl];
            
            temp_PG_tapExcl=Analysis_LightTap_Filt.(fish{1}).PG.both.perc_neg_tapExcl;
            perc_neg_resp_PG_tapExcl_both=[perc_neg_resp_PG_tapExcl_both; temp_PG_tapExcl];
        end
        
        
    end
end

%for graph
perc_neg_resp_PG_multiSens_both=perc_neg_resp_PG_multiSens_both*-1;
perc_neg_resp_PG_lightExcl_both=perc_neg_resp_PG_lightExcl_both*-1;
perc_neg_resp_PG_tapExcl_both=perc_neg_resp_PG_tapExcl_both*-1;

%% Calculating the mean and standard error of the mean (SEM)
%excited neurons
m_perc_pos_resp_PG_multiSens_both=mean(perc_pos_resp_PG_multiSens_both,1,"omitnan");
m_perc_pos_resp_PG_lightExcl_both=mean(perc_pos_resp_PG_lightExcl_both,1,"omitnan");
m_perc_pos_resp_PG_tapExcl_both=mean(perc_pos_resp_PG_tapExcl_both,1,"omitnan");

sem_perc_pos_resp_PG_multiSen_both=std(perc_pos_resp_PG_multiSens_both,"omitnan")/sqrt(length(perc_pos_resp_PG_multiSens_both));
sem_perc_pos_resp_PG_lightExcl_both=std(perc_pos_resp_PG_lightExcl_both,"omitnan")/sqrt(length(perc_pos_resp_PG_lightExcl_both));
sem_perc_pos_resp_PG_tapExcl_both=std(perc_pos_resp_PG_tapExcl_both,"omitnan")/sqrt(length(perc_pos_resp_PG_tapExcl_both));

%inhibited neurons
m_perc_neg_resp_PG_multiSen_both=mean(perc_neg_resp_PG_multiSens_both,1,"omitnan");
m_perc_neg_resp_PG_lightExcl_both=mean(perc_neg_resp_PG_lightExcl_both,1,"omitnan");
m_perc_neg_resp_PG_tapExcl_both=mean(perc_neg_resp_PG_tapExcl_both,1,"omitnan");

sem_perc_neg_resp_PG_multiSen_both=std(perc_neg_resp_PG_multiSens_both,"omitnan")/sqrt(length(perc_neg_resp_PG_multiSens_both));
sem_perc_neg_resp_PG_lightExcl_both=std(perc_neg_resp_PG_lightExcl_both,"omitnan")/sqrt(length(perc_neg_resp_PG_lightExcl_both));
sem_perc_neg_resp_PG_tapExcl_both=std(perc_neg_resp_PG_tapExcl_both,"omitnan")/sqrt(length(perc_neg_resp_PG_tapExcl_both));

%% Making the bar graph for the responding PG neurons
%Data is ordered as: excited light exclusive, inhibited light exclusive, excited Vib exclusive, inhibited Vib exlusive, excited multi-sensory, inhibited multi-sensory

%Defining the data
data=[m_perc_pos_resp_PG_lightExcl_both m_perc_neg_resp_PG_lightExcl_both; m_perc_pos_resp_PG_tapExcl_both m_perc_neg_resp_PG_tapExcl_both; m_perc_pos_resp_PG_multiSens_both m_perc_neg_resp_PG_multiSen_both];
data=data*100;
sem=[sem_perc_pos_resp_PG_lightExcl_both sem_perc_neg_resp_PG_lightExcl_both; sem_perc_pos_resp_PG_tapExcl_both sem_perc_neg_resp_PG_tapExcl_both; sem_perc_pos_resp_PG_multiSen_both sem_perc_neg_resp_PG_multiSen_both];
sem=sem*100;
all_data=[perc_pos_resp_PG_lightExcl_both,perc_neg_resp_PG_lightExcl_both, perc_pos_resp_PG_tapExcl_both,perc_neg_resp_PG_tapExcl_both, perc_pos_resp_PG_multiSens_both,perc_neg_resp_PG_multiSens_both];
all_data=all_data*100;

y=[1:3];

%Plotting the bar graph
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 10 12];
b=barh(y,data,'grouped');
b(1).FaceColor=[1.0 0 0]; %red
b(2).FaceColor=[0 0.45 0.74]; %blue
xlim([-15 25]);
xlabel('Responding PG neurons (%)');
set(gca, 'XTick', [-25:5:25]);
set(gca, 'yTickLabel', {'Light exclusive', 'Vibration exclusive', 'Multi-sensory'});
box off;

hold on

%Calculate the number of groups and number of bars in each group
[ngroups,nbars] = size(data);
% Get the x coordinate of the bars
x = nan(nbars, ngroups);
for i = 1:nbars
    x(i,:) = b(i).XEndPoints;
end
% Plot the errorbars
errorbar(data,x',sem,'horizontal','k','linestyle','none','LineWidth',1,'CapSize',10);

% %Adding the data points
a=0; % counter
for i=1:size(y,2)
    for j=1:2 % data within groups
        a=a+1;
        temp=repmat(all_data(:,a),1);
        temp(:,2)=b(j).XEndPoints(i);
        scatter(temp(:,1),temp(:,2),25,'MarkerEdgeColor','k','LineWidth',1);
    end
end

hold off

% title('Responding cells - both hemisphere - 11 fish');
% legend('positive','negative');

%for saving as .svg
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Calculating the statistics (Rank sum test)
%input: all_data where the data in each column is compared with another column
%output: Table array (T) displaying the p-values comparison between groups
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
p_val_final(:,1)=[p_val(1,3);p_val(1,5)];
p_val_final(:,2)=[NaN;p_val(3,5)];

%Creating the table array with the final p-values
T=array2table(p_val_final,'VariableNames',{'Light Excl','Vib Excl'},'RowNames',{'Vib Excl','Multi-sensory'})
