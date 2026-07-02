%% Response selectivity of excited Pallial PG axonal pixels as a KS density scatter plot (Fig. 3K)
%This script plots the mean neural responses for all excited Pallial PG axonal pixels following light and vibration trials.
%Overlayed the position of the scatter data points with a kernel density probability estimate. 
%Each section of this script must be run indivudally in proper order.

%Inputs: 
% Data file: 202606_PGAxons_LightTap_Data.mat
% Analysis file (indices): 202606_PGAxons_LightTap_Analysis.mat
 
%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path='C:\Users\Documents\...\2P_PGAxons';
fileName_data = '202606_PGAxons_LightTap_Datamat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_PGAxons';
fileName_analysis = '202606_PGAxons_LightTap_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);
%% Making the scatter density plot (Fig. 3K)

%Defining the colors
gray=[0.8 0.8 0.8];

%Defining the output variables
all_pixels_l=[];
all_pixels_t=[];
all_pixels_non_l=[];
all_pixels_non_t=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
    %Defining the parameters
    frame_rate=PGAxons.(fish{1}).volume_rate;
    org_traces=PGAxons.(fish{1}).TrialDFF_filt;
    cond=PGAxons.(fish{1}).stim_cond;
    
    %Defining the responding period
    resp_time=5;
    baseline_dur = floor(5 * frame_rate); %determining the baseline period
    resp_period = [baseline_dur+1:baseline_dur+1+floor(resp_time * frame_rate)];
       
    %for excited axonal pixels only
    temp_light_all=Analysis_PGAxons_Filt.(fish{1}).all.light.positive_resp_pixels;
    temp_tap_all=Analysis_PGAxons_Filt.(fish{1}).all.tap.positive_resp_pixels;
    
    %Creating the list for classification
    select_list=zeros(size(org_traces,3),2);

    select_list(temp_light_all,1)=1;
    select_list(temp_tap_all,2)=1;
    
    resp_sel=zeros(size(select_list,1),1);
    for i=1:size(select_list,1)
        if select_list(i,1)==1 & select_list(i,2)==0
            resp_sel(i)=1;
        end
        if select_list(i,1)==0 & select_list(i,2)==1
            resp_sel(i)=2;
        end
        if select_list(i,1)==1 & select_list(i,2)==1
            resp_sel(i)=3;
        end
    end
    
    %Classification of the responding pixels
    test_l=find(resp_sel==1);
    test_t=find(resp_sel==2);
    test_m=find(resp_sel==3);
    test_n=find(resp_sel==0);
    
    %Finding the PG axonal responses during light trials
    traces_PGAxons_light_l=org_traces(resp_period,cond(:,1),test_l);
    traces_PGAxons_light_t=org_traces(resp_period,cond(:,1),test_t);
    traces_PGAxons_light_m=org_traces(resp_period,cond(:,1),test_m);
    traces_PGAxons_light_n=org_traces(resp_period,cond(:,1),test_n);
    
    %Finding the PG axonal responses during vibration trials
    traces_PGAxons_tap_l=org_traces(resp_period,cond(:,2),test_l);
    traces_PGAxons_tap_t=org_traces(resp_period,cond(:,2),test_t);
    traces_PGAxons_tap_m=org_traces(resp_period,cond(:,2),test_m);
    traces_PGAxons_tap_n=org_traces(resp_period,cond(:,2),test_n);
    
    %Calculating the mean light responses
    m_traces_PGAxons_light_l=squeeze(nanmean(mean(traces_PGAxons_light_l,2),1));
    m_traces_PGAxons_light_t=squeeze(nanmean(mean(traces_PGAxons_light_t,2),1));
    m_traces_PGAxons_light_m=squeeze(nanmean(mean(traces_PGAxons_light_m,2),1));
    m_traces_PGAxons_light_n=squeeze(nanmean(mean(traces_PGAxons_light_n,2),1));
    
    %Calculating the mean vibration responses
    m_traces_PGAxons_tap_l=squeeze(nanmean(mean(traces_PGAxons_tap_l,2),1));
    m_traces_PGAxons_tap_t=squeeze(nanmean(mean(traces_PGAxons_tap_t,2),1));
    m_traces_PGAxons_tap_m=squeeze(nanmean(mean(traces_PGAxons_tap_m,2),1));
    m_traces_PGAxons_tap_n=squeeze(nanmean(mean(traces_PGAxons_tap_n,2),1));

    %Regrouping the data
    all_pixels_l=[all_pixels_l;m_traces_PGAxons_light_l;m_traces_PGAxons_light_t;m_traces_PGAxons_light_m];
    all_pixels_t=[all_pixels_t;m_traces_PGAxons_tap_l;m_traces_PGAxons_tap_t;m_traces_PGAxons_tap_m];
    all_pixels_non_l=[all_pixels_non_l;m_traces_PGAxons_light_n];
    all_pixels_non_t=[all_pixels_non_t;m_traces_PGAxons_tap_n];

end

% Making the figure
f2=figure;
f2.Units="centimeters";
f2.Position=[10 15 10 10];
%plotting the other responding pixels
scatter(all_pixels_non_l,all_pixels_non_t,30,gray,'filled','MarkerFaceAlpha',0.5,'MarkerEdgeAlpha',0.5);
hold on
%plotting the excited pixels as a KS Density plot
scatter_kde(all_pixels_l,all_pixels_t,'filled','MarkerSize',30);

xlim([-50 150]);
ylim([-50 150]);
xline(0,'-.k','linewidth', 1.5);
yline(0,'-.k','linewidth', 1.5);
xlabel('Light response (% DF/F)');
ylabel('Vibration response (% DF/F)');
clim([0 0.00067]);
% cb = colorbar();
% cb.Label.String = 'Probability density estimate';
title('PG Axons');
colormap jet;


%for saving as a .svg
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');