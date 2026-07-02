%% Plots the fraction of multi-sensory units across all datasets (Fig. 5L)
%This scripts plots the cosine similarity between the sensory responses for all units (neurons and axonal pixels) across all datasets as a bar plot.
%This script needs to be run by individual section.
%The p-values for each comparison between datasets is organized in a table variable (T).

%Input:
% Dataset: 202606_PGNeurons_LightTap_Data.mat
% Dataset: 202606_PGAxons_LightTap_Data.mat
% Dataset: 202606_PalNeurons_LightTapBoth_Data.mat
% Analysis file: 202606_PGNeurons_LightTap_Analysis.mat
% Analysis file: 202606_PGAxons_AnalysisKmeans.mat
% Analysis file: 202606_PalNeurons_LightTapBoth_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path_PGNeuron='C:\Users\Documents\...\2P_PGNeurons'; 
d_path_PGAxons='C:\Users\Documents\...\2P_PGAxons';
d_path_PalNeurons='C:\Users\Documents\...\2P_InVivo_PalNeurons'; 

a_path_PGNeuron='C:\Users\Documents\...\2P_PGNeurons'; 
a_path_PGAxons='C:\Users\Documents\...\2P_PGAxons';
a_path_PalNeurons='C:\Users\Documents\...\2P_InVivo_PalNeurons'; 

%PG Neurons
fileName_PGNeurons = '202606_PGNeurons_LightTap_Data.mat';
data_path1=fullfile(d_path_PGNeuron,fileName_PGNeurons);
load(data_path1);

fileName_PGNeurons = '202606_PGNeurons_LightTap_Analysis.mat';
analysis_path1=fullfile(a_path_PGNeuron,fileName_PGNeurons);
load(analysis_path1);

%PG Axons
fileName_PGAxons= '202606_PGAxons_LightTap_Data.mat';
data_path2=fullfile(d_path_PGAxons,fileName_PGAxons);
load(data_path2);

fileName_PGAxons= '202606_PGAxons_LightTap_Analysis.mat';
analysis_path2=fullfile(a_path_PGAxons,fileName_PGAxons);
load(analysis_path2);

%Pallial Neurons
fileName_PalNeurons = '202606_PalNeurons_LightTapBoth_Data.mat';
data_path3=fullfile(d_path_PalNeurons,fileName_PalNeurons);
load(data_path3);

fileName_PalNeurons = '202606_PalNeurons_LightTapBoth_Analysis.mat';
analysis_path3=fullfile(a_path_PalNeurons,fileName_PalNeurons);
load(analysis_path3);

%% Finding the mean responses per cell to sensory stim
sensory_respPG={};
f=1; %counter for individual animals
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    for choice=1:2
        frame_rate=PGNeurons.(fish{1}).volume_rate;
        org_traces=PGNeurons.(fish{1}).TrialDFF_filt;
        cond=PGNeurons.(fish{1}).stim_cond;
        
        resp_time=5;
        baseline_dur = ceil(5 * frame_rate); %changed from floor, Dec 12 2022
        % baseline_period=[1:baseline_dur-2];
        resp_period = [baseline_dur+1:baseline_dur+1+ceil(resp_time * frame_rate)];
        
        temp=[Analysis_LightTap_Filt.(fish{1}).all.light.positive_resp_cells;Analysis_LightTap_Filt.(fish{1}).all.tap.positive_resp_cells];
        all_resp_neurons=unique(temp);

        temp_traces=org_traces(:,:,:);

        if choice==1
    
            data_PG_both= temp_traces(resp_period,cond(:,1),:);
            
            %average activity vector per cell
            m_data_PG_cell=squeeze(nanmean(data_PG_both,2));

            %saving
            sensory_respPG{f,1}=m_data_PG_cell;
        end
        
        if choice==2
   
            data_PG_both= temp_traces(resp_period,cond(:,2),:);
            
            %average activity vector per cell
            m_data_PG_cell=squeeze(nanmean(data_PG_both,2));
            
            %saving
            sensory_respPG{f,2}=m_data_PG_cell;
            
        end
    end
    f=f+1;
end
%% Cosine Similarity
cosine_sim_all_PG={};
m_cosine_sim_PG=[];
for i=1:11
    m_LightResp=sensory_respPG{i,1}';
    m_TapResp=sensory_respPG{i,2}';   
   
    cosine_similarity=[];
    for j=1:size(m_LightResp,1)
        temp=1-pdist2(m_LightResp(j,:),m_TapResp(j,:),'cosine');
        cosine_similarity=[cosine_similarity;temp];
    end
    m_temp=mean(cosine_similarity);
    cosine_sim_all_PG{i,1}=cosine_similarity;
    m_cosine_sim_PG=[m_cosine_sim_PG;m_temp];

end

%% Finding the mean responses per cell to sensory stim
sensory_resp_PGAxon={};
f=1; %counter for individual animals
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
    for choice=1:2
        frame_rate=PGAxons.(fish{1}).volume_rate;
        org_traces=PGAxons.(fish{1}).TrialDFF_filt;
        cond=PGAxons.(fish{1}).stim_cond;
        
        resp_time=5;
        baseline_dur = ceil(5 * frame_rate); %changed from floor, Dec 12 2022
        % baseline_period=[1:baseline_dur-2];
        resp_period = [baseline_dur+1:baseline_dur+1+ceil(resp_time * frame_rate)];
   
        % %Select either all neurons or positive only here
%         test=[idx_PosResp_light;idx_PosResp_tap;idx_NegResp_light;idx_NegResp_tap];
        % test=[idx_PosResp_light;idx_PosResp_tap];
        % all_resp_neurons=unique(test);

        %for all pixels
        temp_traces=org_traces(:,:,:);

        if choice==1
            data_PGAxon_both= temp_traces(resp_period,cond(:,1),:);
    
            %average activity vector per cell
            m_data=squeeze(nanmean(data_PGAxon_both,2));
            
            %saving
            sensory_resp_PGAxon{f,1}=m_data;
        end
        
        if choice==2    
            data_PGAxon_both= temp_traces(resp_period,cond(:,2),:);
            
            %average activity vector per cell
            m_data=squeeze(nanmean(data_PGAxon_both,2));
            
            %saving
            sensory_resp_PGAxon{f,2}=m_data;
        end
    end
    f=f+1;
end
%% Cosine Similarity
cosine_sim_all_PGAxons={};
m_cosine_sim_PGAxons=[];
for i=1:12
    m_LightResp=sensory_resp_PGAxon{i,1}';
    m_TapResp=sensory_resp_PGAxon{i,2}';   
   
    cosine_similarity=[];
    for j=1:size(m_LightResp,1)
        temp=1-pdist2(m_LightResp(j,:),m_TapResp(j,:),'cosine');
        cosine_similarity=[cosine_similarity;temp];
    end
    m_temp=mean(cosine_similarity);
    cosine_sim_all_PGAxons{i,1}=cosine_similarity;
    m_cosine_sim_PGAxons=[m_cosine_sim_PGAxons;m_temp];

end

%% For pallium data (Anna's data)
sensory_resp_pal={};
f=1; %counter for individual animals
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
    for choice=1:2
        frame_rate=PalNeurons.(fish{1}).volume_rate;
        org_traces=PalNeurons.(fish{1}).TrialDFF_filt;
        cond=PalNeurons.(fish{1}).stim_cond;

        resp_time=5;
        baseline_dur = ceil(5 * frame_rate); %changed from floor, Dec 12 2022
        % baseline_period=[1:baseline_dur-2];
        resp_period = [baseline_dur+1:baseline_dur+1+ceil(resp_time * frame_rate)];
        

        if choice==1   
            data_Pallium= org_traces(resp_period,cond(:,1),:);
            
            %average activity vector per cell
            m_data_Pallium_cell=squeeze(nanmean(data_Pallium,2));

            %saving
%             sensory_resp_pal{a,1}=m_data_cell;
            sensory_resp_pal{f,1}=m_data_Pallium_cell;

        end
        
        if choice==2    
            data_Pallium= org_traces(resp_period,cond(:,2),:);
            
            %average activity vector per cell
            m_data_Pallium_cell=squeeze(nanmean(data_Pallium,2));

            %saving
%             sensory_resp_pal{a,2}=m_data_cell;
            sensory_resp_pal{f,2}=m_data_Pallium_cell;
        end
    end
    f=f+1;
end
%% Cosine Similarity
cosine_sim_all_Pallium={};
m_cosine_sim_Pallium=[];
for i=1:10
    m_Lightresp_pal=sensory_resp_pal{i,1}';
    m_Tapresp_pal=sensory_resp_pal{i,2}';
    
   
    % % Average cosine similarity  
    % % between all rows (optional) 
    % mean_cosine_similarity = mean(mean(cosine_similarity));
    cosine_similarity=[];
    for j=1:size(m_Lightresp_pal,1)
        temp=1-pdist2(m_Lightresp_pal(j,:),m_Tapresp_pal(j,:),'cosine');
        cosine_similarity=[cosine_similarity;temp];
    end
    m_temp=mean(cosine_similarity);
    cosine_sim_all_Pallium{i,1}=cosine_similarity;
    m_cosine_sim_Pallium=[m_cosine_sim_Pallium;m_temp];


end

%% Plotting the combined bargraph (Pallium vs PGaxons vs PG) (Fig. 5L)
% Regrouping the data (correlation)
m_cosine_sim_Pallium2=m_cosine_sim_Pallium;
m_cosine_sim_Pallium2(11:12,:)=NaN;
m_cosine_sim_PG2=m_cosine_sim_PG;
m_cosine_sim_PG2(12,:)=NaN;
all_data=[m_cosine_sim_PG2,m_cosine_sim_PGAxons,m_cosine_sim_Pallium2];

mean_CosineSim_PG=mean(all_data(:,1),"omitnan");
mean_CosineSim_PGaxon=mean(all_data(:,2),"omitnan");
mean_CosineSim_Pallium=mean(all_data(:,3),"omitnan");

sem_CosineSim_PG=std(all_data(:,1),"omitnan")/sqrt(length(all_data(:,1)));
sem_CosineSim_PGaxon=std(all_data(:,2),"omitnan")/sqrt(length(all_data(:,2)));
sem_CosineSim_Pallium=std(all_data(:,3),"omitnan")/sqrt(length(all_data(:,3)));

% PLotting the bar graph (correlation)
%Defining the data
data=[mean_CosineSim_PG;mean_CosineSim_PGaxon;mean_CosineSim_Pallium];
sem=[sem_CosineSim_PG;sem_CosineSim_PGaxon;sem_CosineSim_Pallium];

%Color: shades of purple
color=[0.705882352941177	0.568627450980392	0.784313725490196;...
    0.486274509803922	0.321568627450980	0.584313725490196;...
    0.321568627450980	0.188235294117647	0.486274509803922];

y=[1:3];
%Creating the figure
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 6 8];
%Plotting the bar graph
b=bar(y,data,0.75,'FaceColor','flat',CData=color);
ylim([-0.2 0.5]);
ylabel('Mean Sensory Response Correlation');
set(gca, 'XTickLabel', {'PG neurons', 'PG axons','Pallial neurons'});
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

% %Adding the data points
a=0; % counter
for i=1:size(y,2)
%     for j=1:3
        a=a+1;
        temp=repmat(all_data(:,a),1);
        temp(:,2)=b(1).XEndPoints(i);
        scatter(temp(:,2),temp(:,1),20,'MarkerEdgeColor','k','LineWidth',1);
%     end
end

hold off

title('Mean Sensory Response Correlation');
% legend('Light Exclusive','MechVib Exclusive','Mixed Selective');

%for saving as a .svg file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Stats (Kruskall-Wallis + Dunn's test)
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
