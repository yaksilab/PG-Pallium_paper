%% Response selectivity of excited PG neurons as a scatter plot (Fig. 5F)
%This scripts plots the mean neural responses for all excited neurons following light and vibration trials color-coded by their response selectivity.
%This script needs to be run by individual section.

%Input:
% Dataset: 202606_PGNeurons_LightTap_Data.mat
% Analysis file: 202606_PGNeurons_LightTap_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path_PGNeuron='C:\Users\Documents\...\2P_PGNeurons'; 
a_path_PGNeuron='C:\Users\Documents\...\2P_PGNeurons'; 

%PG Neurons
fileName_PGNeurons = '202606_PGNeurons_LightTap_Data.mat';
data_path1=fullfile(d_path_PGNeuron,fileName_PGNeurons);
load(data_path1);

fileName_PGNeurons = '202606_PGNeurons_LightTap_Analysis.mat';
analysis_path1=fullfile(a_path_PGNeuron,fileName_PGNeurons);
load(analysis_path1);

%% Making the scatter plot (Fig. 5F)

%Defining the colors
gray=[0.8 0.8 0.8];
orange=[0.945098039215686	0.352941176470588	0.160784313725490];
teal=[0	0.654901960784314	0.615686274509804];
purple=[0.321568627450980	0.188235294117647	0.486274509803922];

%Making the figure
f1=figure;
f1.Units="centimeters";
f1.Position=[10 15 10 10];
hold on
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    %Defining the parameters
    frame_rate=PGNeurons.(fish{1}).volume_rate;
    org_traces=PGNeurons.(fish{1}).TrialDFF_filt;
    cond=PGNeurons.(fish{1}).stim_cond;

    %Defining the responding period
    resp_time=5;
    baseline_dur = ceil(5 * frame_rate); %determining the baseline period
    resp_period = [baseline_dur+1:baseline_dur+1+ceil(resp_time * frame_rate)];
       
    %for excited neurons only
    temp_light_all=Analysis_LightTap_Filt.(fish{1}).all.light.positive_resp_cells;
    temp_tap_all=Analysis_LightTap_Filt.(fish{1}).all.tap.positive_resp_cells;
    
    %Creating the list for classification
    select_list=zeros(size(org_traces,3),2);
    
    select_list(temp_light_all,1)=1;
    select_list(temp_tap_all,2)=1;
        
    list_PG=select_list(:,:);
    traces_PG=org_traces(:,:,:);
    
    resp_sel=zeros(size(list_PG,1),1);
    for i=1:size(list_PG,1)
        if list_PG(i,1)==1 & list_PG(i,2)==0
            resp_sel(i)=1;
        end
        if list_PG(i,1)==0 & list_PG(i,2)==1
            resp_sel(i)=2;
        end
        if list_PG(i,1)==1 & list_PG(i,2)==1
            resp_sel(i)=3;
        end
    end
    
    %Classification of the neurons
    test_l=find(resp_sel==1);
    test_t=find(resp_sel==2);
    test_m=find(resp_sel==3);
    test_n=find(resp_sel==0);
    
    %Finding the PG neuron's responses during light trials
    traces_PG_light_l=traces_PG(resp_period,cond(:,1),test_l);
    traces_PG_light_t=traces_PG(resp_period,cond(:,1),test_t);
    traces_PG_light_m=traces_PG(resp_period,cond(:,1),test_m);
    traces_PG_light_n=traces_PG(resp_period,cond(:,1),test_n);
    
    %Finding the PG neuron's responses during vibration trials
    traces_PG_tap_l=traces_PG(resp_period,cond(:,2),test_l);
    traces_PG_tap_t=traces_PG(resp_period,cond(:,2),test_t);
    traces_PG_tap_m=traces_PG(resp_period,cond(:,2),test_m);
    traces_PG_tap_n=traces_PG(resp_period,cond(:,2),test_n);
    
    %Calculating the mean light responses
    m_traces_PG_light_l=squeeze(nanmean(mean(traces_PG_light_l,2),1));
    m_traces_PG_light_t=squeeze(nanmean(mean(traces_PG_light_t,2),1));
    m_traces_PG_light_m=squeeze(nanmean(mean(traces_PG_light_m,2),1));
    m_traces_PG_light_n=squeeze(nanmean(mean(traces_PG_light_n,2),1));
    
    %Calculating the mean vibration responses
    m_traces_PG_tap_l=squeeze(nanmean(mean(traces_PG_tap_l,2),1));
    m_traces_PG_tap_t=squeeze(nanmean(mean(traces_PG_tap_t,2),1));
    m_traces_PG_tap_m=squeeze(nanmean(mean(traces_PG_tap_m,2),1));
    m_traces_PG_tap_n=squeeze(nanmean(mean(traces_PG_tap_n,2),1));

    %Plotting the scatter plots
    scatter(m_traces_PG_light_l,m_traces_PG_tap_l,40,orange,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5);
    scatter(m_traces_PG_light_t,m_traces_PG_tap_t,40,teal,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5);
    scatter(m_traces_PG_light_m,m_traces_PG_tap_m,40,purple,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5);
    scatter(m_traces_PG_light_n,m_traces_PG_tap_n,30,gray,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5);

end

%Figure parameters
xlim([-25 80]);
ylim([-25 80]);
xline(0,'-.k','linewidth', 1.5);
yline(0,'-.k','linewidth', 1.5);
xlabel('Light response (% DF/F)');
ylabel('Vibration response (% DF/F)');
% title('PG');
legend('Light Excl','Vibration Excl','Multi-sensory','OtherResp');

%for saving as a .svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');