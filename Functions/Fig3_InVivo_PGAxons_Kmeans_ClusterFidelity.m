%% K-means Analysis and Calculating the cluster fidelity index (For PG axons in the pallium) (Function for Fig. 3)
%This script is based on the one used in Bartoszek et al., (2021): https://doi.org/10.1016/j.cub.2021.08.021 
%This function examines the percentage of neurons remaining in the same K-means cluster during 2 pre-defined time periods.
%Note: Used mean stimulus responses activity (mean across all trials, i.e., trial based DFF)

%Inputs: 
% d_path: folder path for dataset
% s_path: folder path for saved correlations (output)

%Outputs: 
% perc_clust_fidel_spont = percentage of neurons remaining the same cluster following 2 spontaneous activity periods
% perc_clust_fidel_shuffle = percentage of neurons remaining the same cluster following 2 spontaneous activity periods (following a shuffling of the cluster identities)
% perc_clust_fidel_light = percentage of neurons remaining the same cluster following light stimulation using the centroid obtained from the spontaneous activity period
% perc_clust_fidel__light_shuffle = percentage of neurons remaining the same cluster following light stimulation using the centroid obtained from the spontaneous activity period (following a shuffling of the cluster identities)
% perc_clust_fidel_tap = percentage of neurons remaining the same cluster following following vibration stimulation using the centroid obtained from the spontaneous activity period
% perc_clust_fidel_tap_shuffle = percentage of neurons remaining the same cluster following following vibration stimulation using the centroid obtained from the spontaneous activity period (following a shuffling of the cluster identities)
%KmeansIdx_spontAll= all the cluster indices following the K-means analysis for the spontaneous period (8 min)
%KmeansIdx_spont1= all the cluster indices following the K-means analysis for the spontaneous period 1 (4 min)
%KmeansIdx_spont2= all the cluster indices following the K-means analysis for the spontaneous period 2 (4 min)
%KmeansIdx_light= all the cluster indices following the K-means analysis for the light responding period (25 s);
%KmeansIdx_tap= all the cluster indices following the K-means analysis for the vibration responding period (25 s);

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)

function [perc_clust_fidel_spont,perc_clust_fidel_spont_shuffle,perc_clust_fidel_light,perc_clust_fidel_light_shuffle,...
    perc_clust_fidel_tap,perc_clust_fidel_tap_shuffle,KmeansIdx_spontAll,KmeansIdx_spont1,KmeansIdx_spont2,KmeansIdx_light,KmeansIdx_tap]=Fig3_InVivo_PGAxons_Kmeans_ClusterFidelity(d_path,s_path);
%% Loading the data
fileName_data = '202606_PGAxons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);
%% K-means clustering and calculating the cluster fidelity index
%Defining the variables to be saved
% perc_clust_fidel_spont=[];
% perc_clust_fidel_spont_shuffle=[];

perc_clust_fidel_light=[];
perc_clust_fidel_light_shuffle=[];

perc_clust_fidel_tap=[];
perc_clust_fidel_tap_shuffle=[];

KmeansIdx_spontAll={};
% KmeansIdx_spont1={};
% KmeansIdx_spont2={};
KmeansIdx_light={};
KmeansIdx_tap={};
f=1;

for choice =2 % choice (1=comparing between 2 spontaneous activity periods) (2=comparing between spontaneous and sensory stimulation periods)

    for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
    %% Defining the parameters & data
    
    %parameters
    frame_rate=PGAxons.(fish{1}).volume_rate;
    cond=PGAxons.(fish{1}).stim_cond;
    
    %data
    traces_PGAxons=PGAxons.(fish{1}).DFFmovwindow_filt;
    traces_PGAxons_stim=PGAxons.(fish{1}).TrialDFF_filt;
    
    %defining the number of clusters
    n_clusters=6;
    
    if choice==1
        %defining the spont period
        spont_onset=floor(90*frame_rate);
        spont_offset=spont_onset+floor(240*frame_rate);
        
        spont_onset2=spont_offset+floor(30*frame_rate);
        spont_offset2=spont_onset2+floor(240*frame_rate);
    end
    
    if choice==2
        %defining the spont period
        spont_onset=floor(90*frame_rate);
        spont_offset=spont_onset+floor(480*frame_rate); %changed to 8 mins
        
        %defining the stim period *For LightTap data
        resp_off=floor(10*frame_rate);
        light_traces=traces_PGAxons_stim(1:resp_off,cond(:,1),:);
        m_light_traces=squeeze(mean(light_traces,2))';
        
        tap_traces=traces_PGAxons_stim(1:resp_off,cond(:,2),:);
        m_tap_traces=squeeze(mean(tap_traces,2))';
    end
    
    if choice==1
    %% Kmeans for spontaneous data period 1
    data_spont=traces_PGAxons(:,spont_onset:spont_offset);
    [IDX_b_spont,~,~,~] = kmeans(data_spont(:,:),n_clusters,'Distance','correlation','Replicates',100, 'Start','sample');
    
    KmeansIdx_spont1=[KmeansIdx_spont1;IDX_b_spont];
    
    %% Kmeans for spontaneous period 2
    data_spont2=traces_PGAxons(:,spont_onset2:spont_offset2);
    
    startpoint=[];
    for i=1:max(max(IDX_b_spont))
    startpoint=cat(1,startpoint,mean(data_spont2(IDX_b_spont==i,:),1));
    end
    
    [IDX_b_spont2,~,~,~] = kmeans(data_spont2(:,:),n_clusters,'Distance','correlation','Start',startpoint);
    
    KmeansIdx_spont2=[KmeansIdx_spont2;IDX_b_spont2];
    
    %% Compare data
    %Function adapted from Bartoszek et al., (2021)
    [res_spont,shuffled_res0]=Cluster_Compare(IDX_b_spont,IDX_b_spont2);
    
    %grouping data
    perc_clust_fidel_spont=[perc_clust_fidel_spont; res_spont];
    perc_clust_fidel_spont_shuffle=[perc_clust_fidel_spont_shuffle; shuffled_res0];
    
    end
    
    if choice ==2
    %% Kmeans for spontaneous data (all)
    n_clusters=6;
    data_spont=traces_PGAxons(:,spont_onset:spont_offset);
    [IDX_b_spont,~,~,~] = kmeans(data_spont(:,:),n_clusters,'Distance','correlation','Replicates',100, 'Start','sample');
    
    KmeansIdx_spontAll=[KmeansIdx_spontAll;IDX_b_spont];
    % IDX_b_spont=KmeansIdx_spontAll{f,1};
    
    %% Kmeans for Light stim data
    data_light=m_light_traces;
    
    startpoint=[];
    for i=1:max(max(IDX_b_spont))
    startpoint=cat(1,startpoint,mean(data_light(IDX_b_spont==i,:),1));
    end
    
    [IDX_b_light,~,~,~] = kmeans(data_light(:,:),n_clusters,'Distance','correlation','Start',startpoint);
    
    KmeansIdx_light=[KmeansIdx_light;IDX_b_light];
    
    %% Kmeans for MechVib stim data
    data_tap=m_tap_traces;
    
    startpoint=[];
    for i=1:max(max(IDX_b_spont))
    startpoint=cat(1,startpoint,mean(data_tap(IDX_b_spont==i,:),1));
    end
    
    [IDX_b_tap,~,~,~] = kmeans(data_tap(:,:),n_clusters,'Distance','correlation','Start',startpoint);
    
    KmeansIdx_tap=[KmeansIdx_tap;IDX_b_tap];
    
    %% Comparing clusters
    %Function adapted from Bartoszek et al., (2021)
    
    [res_light,shuffled_res]=Cluster_Compare(IDX_b_spont,IDX_b_light);
    [res_tap,shuffled_res2]=Cluster_Compare(IDX_b_spont,IDX_b_tap);
    
    %grouping data
    perc_clust_fidel_light=[perc_clust_fidel_light; res_light];
    perc_clust_fidel_light_shuffle=[perc_clust_fidel_light_shuffle; shuffled_res];
    
    perc_clust_fidel_tap=[perc_clust_fidel_tap; res_tap];
    perc_clust_fidel_tap_shuffle=[perc_clust_fidel_tap_shuffle;shuffled_res2];
    end
    
    end
end

%% Saving
%Note replace the location where you want to save the variables.
 fileName_save='202605_PGAxons_AnalysisKmeans'; %Change the name of the file here
 save_path=fullfile(s_path,fileName_save);
 save(save_path, 'perc_clust_fidel_spont', 'perc_clust_fidel_spont_shuffle', ...
    'perc_clust_fidel_light', 'perc_clust_fidel_light_shuffle',...
    'perc_clust_fidel_tap', 'perc_clust_fidel_tap_shuffle',...
    'KmeansIdx_spontAll','KmeansIdx_spont1','KmeansIdx_spont2','KmeansIdx_light','KmeansIdx_tap');
end