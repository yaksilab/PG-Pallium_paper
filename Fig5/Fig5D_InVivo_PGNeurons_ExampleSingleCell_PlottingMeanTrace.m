%% Example neural traces of the PG neurons during sensory stimulation (Fig. 5D)
%This script plots the mean neural responses for the example PG neurons during light and vibration stimulation.
%Six example cells were used in the manuscript, but any of them can be plotted. 
%Overlayed the position of the scatter data points with a kernel density probability estimate. 
%Each section of this script must be run indivudally in proper order.

%Input:
% Data file: 202606_PGNeurons_LightTap_Data.mat
% Analysis file (indices): 202606_PGNeurons_LightTap_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated July 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path='C:\Users\Documents\...\2P_PGNeurons'; 
fileName_data = '202606_PGNeurons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_PGNeurons';
fileName_analysis = '202606_PGNeurons_LightTap_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);
%% Plotting the example neural traces (used in the manuscript)

close all;

f=1;
for fish={'fish2','fish6','fish8','fish9','fish11'} %Can change the fish number here to visualize data from other fish

%Defining the parameters
frame_rate=PGNeurons.(fish{1}).volume_rate;
cond=PGNeurons.(fish{1}).stim_cond;

idx_lightExcl=Analysis_LightTap_Filt.(fish{1}).PG.both.idx_pos_lightExcl;
idx_vibExcl=Analysis_LightTap_Filt.(fish{1}).PG.both.idx_pos_tapExcl;
idx_multiSens=Analysis_LightTap_Filt.(fish{1}).PG.both.idx_pos_multiSens;

%NOTE: the cell indice is called as follows: example idx_lightExcl=idx_lightExcl(cell#);
if f==1
    eg_idx_lightExcl=NaN;
    eg_idx_vibExcl=idx_vibExcl(10);
    eg_idx_multiSens=NaN;
end

if f==2
    eg_idx_lightExcl=NaN;
    eg_idx_vibExcl=NaN;
    eg_idx_multiSens=idx_multiSens(2);
end

if f==3
    eg_idx_lightExcl=idx_lightExcl(19);
    eg_idx_vibExcl=NaN;
    eg_idx_multiSens=NaN;
end

if f==4
    eg_idx_lightExcl=idx_lightExcl(2);
    eg_idx_vibExcl=idx_vibExcl(4);
    eg_idx_multiSens=NaN;
end

if f==5
    eg_idx_lightExcl=NaN;
    eg_idx_vibExcl=NaN;
    eg_idx_multiSens=idx_multiSens(9);
end

%defining the response period
resp_on=1;
resp_off=floor(15*frame_rate);
stim_onset=ceil(5*frame_rate);

%defining the neural data
data=PGNeurons.(fish{1}).TrialDFF_filt;
data_PG=data(resp_on:resp_off,:,:);

    for condition=1:3 %for either light excl, vib excl, multi-sensory
        if condition==1
            resp_select=eg_idx_lightExcl;
        elseif condition==2
            resp_select=eg_idx_vibExcl;        
        elseif condition==3
            resp_select=eg_idx_multiSens;
        end
        
        if ~isnan(resp_select)
        %Defining the neural data
        data_light=data_PG(:,cond(:,1),resp_select)';
        data_vib=data_PG(:,cond(:,2),resp_select)';
        
        %Getting the single-trial traces
        data_light_filt=nan(size(data_light));
        data_vib_filt=nan(size(data_light));
        for c=1:size(data_light,1)
            %Smoothing the traces
            data_light_filt(c,:)=smoothdata(data_light(c,:),'gaussian', floor(5*frame_rate));
            data_vib_filt(c,:)=smoothdata(data_vib(c,:),'gaussian', floor(5*frame_rate));
        end
        
        %Averaging and smoothing the traces
        m_data_light=mean(data_light,1);
        m_data_vib=mean(data_vib,1);
        
        m_data_light_filt=smoothdata(m_data_light,'gaussian', floor(3*frame_rate));
        m_data_vib_filt=smoothdata(m_data_vib,'gaussian', floor(3*frame_rate));
        
        %Color Definition
        orange=[0.945098039215686	0.352941176470588	0.160784313725490];
        light_orange=[1	0.63	0.49 0.35];
        teal=[0	0.654901960784314	0.615686274509804];
        light_teal=[0.125000000000000	0.88	0.78 0.35];
        
        
        figure();
        hold on
        for a=1:size(data_light,1)
            plot(data_light_filt(a,:),'LineWidth',0.6667,'color',light_orange);
            plot(data_vib_filt(a,:),'LineWidth',0.6667,'color',light_teal);
        end
        plot(m_data_light_filt,'LineWidth',2.5,'Color',orange);
        plot(m_data_vib_filt,'LineWidth',2.5,'Color',teal);
        xline(stim_onset,'-.k');
        ylim([-30 75]);
        
        %Figure parameters
        ylabel('DF/F');
        xlabel('Time (s)');
        xt = get(gca, 'XTick');
        xtnew = linspace(min(xt), max(xt), 5);   % New 'XTick' Values
        ticks_seconds=(xt/frame_rate);
        xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
        set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks
        
        %for saving as svg image file
        set(gcf, 'InvertHardCopy', 'off');
        set(gcf, 'DefaultFigureRenderer', 'painters');
        set(gcf,'renderer','painters');
        else
            continue
        end
    end
f=f+1;
end

