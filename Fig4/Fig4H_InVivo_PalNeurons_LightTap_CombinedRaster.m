%% Plotting the activity traces of responding Pallial neurons as a heatmap (Fig. 4H)
%This script plots the neural activity traces for the responding Pallial neurons.
%The indices of the responding Pallial neurons were obtained using the script: InVivo_PalNeurons_RespondingCells.m
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
%% Getting the activity traces for all responding neurons according to sensory stimulation 
%Defining the parameters
data_PosResp_light=[];
data_NegResp_light=[];

data_PosResp_Vib=[];
data_NegResp_Vib=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
    for cellType=1:2
        if cellType==1
            idx_positive_resp_cells_light=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.light.positive_resp_cells;
            idx_negative_resp_cells_light=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.light.negative_resp_cells;
           
            stim_light=PalNeurons.(fish{1}).stim_cond(:,1);          
            traces=PalNeurons.(fish{1}).TrialDFF_filt(:,stim_light,:);
        
            temp_PosResp_traces=traces(:,:,idx_positive_resp_cells_light);
            temp_PosResp_traces=squeeze(mean(temp_PosResp_traces,2));
            
            temp_NegResp_traces=traces(:,:,idx_negative_resp_cells_light);
            temp_NegResp_traces=squeeze(mean(temp_NegResp_traces,2));
        
            data_PosResp_light=[data_PosResp_light;temp_PosResp_traces'];
            data_NegResp_light=[data_NegResp_light;temp_NegResp_traces'];
        end

        if cellType==2
            idx_positive_resp_cells_tap=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.tap.positive_resp_cells;
            idx_negative_resp_cells_tap=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.tap.negative_resp_cells;
            
            stim_tap=PalNeurons.(fish{1}).stim_cond(:,2);          
            traces=PalNeurons.(fish{1}).TrialDFF_filt(:,stim_tap,:);
        
            temp_PosResp_traces=traces(:,:,idx_positive_resp_cells_tap);
            temp_PosResp_traces=squeeze(mean(temp_PosResp_traces,2));
            
            temp_NegResp_traces=traces(:,:,idx_negative_resp_cells_tap);
            temp_NegResp_traces=squeeze(mean(temp_NegResp_traces,2));
        
            data_PosResp_Vib=[data_PosResp_Vib;temp_PosResp_traces'];
            data_NegResp_Vib=[data_NegResp_Vib;temp_NegResp_traces'];
        end

    end
end
    

%% Visualizing data - using rastermap
%Based on the codes published in Stringer et al., 2025
%cellType = determining the datasets:
%1-excited neurons following light
%2-excited neurons following Vib
%3-inhibited neurons following light
%4-inhibited neurons following Vib

close all;
for cellType=1:4
%% Sorting the neurons using Rastermap
%Adapted from Stringer et al., 2025
%Initialize data
frame_rate=PalNeurons.fish1.volume_rate;
resp_time=floor(15*frame_rate);
stim_onset=ceil(5*frame_rate);

if cellType ==1
    raster_traces=data_PosResp_light;
end

if cellType ==2
    raster_traces=data_PosResp_Vib;
end

if cellType ==3
    raster_traces=data_NegResp_light;
end

if cellType ==4
    raster_traces=data_NegResp_Vib;
end

data0=raster_traces;
raster_traces=raster_traces(:,1:resp_time);

%Initializing the main Rastermap function
%parameters for Rastermap
% isort1 = sorting along first dimension (n_samples) of matrix (neurons)
% isort2 = sorting along the second dimension (time)
% iclustup1 = the upscaled cluster index
% Sm = convolved sorted data
% iclust = cluster index before upscaling
% iPC = number of principle components
% input data has to be in neurons x time

if size(raster_traces,1)<size(raster_traces,2)
    if size (raster_traces,1)<100
        ops.iPC =1:size(raster_traces,1);
    elseif size(raster_traces,2)<100
        ops.iPC =1:size(raster_traces,2);
    else
        ops.iPC =1:100;
    end
elseif size(raster_traces,2)<100
    ops.iPC =1:size(raster_traces,2);
else
    ops.iPC =1:100;  
end

ops.nC= 5; %number of clusters
ops.isort = []; %default is []
ops.useGPU =0; % if use GPU, set to 1
ops.upsamp =100; %upscaling factor, default is 100
ops.sigUp =1;

%Running the rastermap
[isort1, ~, ~, ~, ~] = mapTmap(raster_traces,ops); %full function (sorts time first than the neurons).

    
%% Figure for responding cells (positive and negative)
%Defining the parameters
frame_rate=PalNeurons.fish1.volume_rate;
stim_onset=ceil(5*frame_rate);

resp_off=ceil(25 * frame_rate);
data=data0(:,1:resp_off); %Plotting only the responding period

pos_subplot=0.1;
subplot_sizeY=0.0004;

%Ploting the heamtmap figure for the neuronal activity trace
f9=figure(); 
subplot ('position', [0.2, pos_subplot(1), 0.5,subplot_sizeY*size(data,1)]); imagesc(data(isort1,:)), caxis([-15 30]); xline(stim_onset,'-.k','linewidth', 1.5); %set(gca,'XTick',[]), set(gca,'YTick',[]),box off;

xt = get(gca, 'XTick');
xtnew = linspace(min(xt), max(xt), 7);   % New 'XTick' Values
ticks_seconds=(xt/frame_rate);
xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks
colormap (beachVibes);
% sgtitle('Pallial neuron traces');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
%% Plotting the mean traces for all responding neurons

%Calculating the mean and standard error of the mean
avg_traces=mean(data,1,"omitnan");
sem_traces=std(data,0,1,"omitnan")/sqrt(length(data));

%Making the figure
figure();
if cellType <=2
    %for positive responses
    shadedErrorBar(1:size(avg_traces,2),avg_traces,sem_traces,'lineprops', 'r');
    xlim([0 90]);
    ylim([-2 30]);
else
    %for negative responses
    shadedErrorBar(1:size(avg_traces,2),avg_traces,sem_traces,'lineprops', 'b');
    xlim([0 90]);
    ylim([-15 5]);
end

xline(stim_onset,'-.k','linewidth', 1.5);
xt = get(gca, 'XTick');
xtnew = linspace(min(xt), max(xt), 10);   % New 'XTick' Values
ticks_seconds=xt/frame_rate;
xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks

%for saving as a .svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
end