%% Spatial location of the sensory selective Pallium neurons (Fig. 5C)
%This script plots the spatial location of the Pallial neurons color-coded by sensory response selectivity.
%Each section of this script must be run in order.

%Input:
% Dataset: 202606_PalNeurons_LightTapBoth_Data.mat
% Analysis file: 202606_PalNeurons_LightTapBoth_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path_PalNeurons='C:\Users\Documents\...\2P_InVivo_PalNeurons'; 
a_path_PalNeurons='C:\Users\Documents\...\2P_InVivo_PalNeurons'; 


%Pallial Neurons
fileName_PalNeurons = '202606_PalNeurons_LightTapBoth_Data.mat';
data_path3=fullfile(d_path_PalNeurons,fileName_PalNeurons);
load(data_path3);

fileName_PalNeurons = '202606_PalNeurons_LightTapBoth_Analysis.mat';
analysis_path3=fullfile(a_path_PalNeurons,fileName_PalNeurons);
load(analysis_path3);
%% Plotting the spatial locations of the Pallial neurons (Fig. 5C)

%Defining the colors
gray=[0.8 0.8 0.8];
orange=[0.945098039215686	0.352941176470588	0.160784313725490];
teal=[0	0.654901960784314	0.615686274509804];
purple=[0.321568627450980	0.188235294117647	0.486274509803922];

%Making the figure
figure();
hold on;
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
    %Defining the parameters
    
    %Defining the indices for response selective cells
    PosResp_multiSens_idx=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.idx_pos_multiSens;
    PosResp_lightExcl_idx=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.idx_pos_lightExcl;
    PosResp_tapExcl_idx=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.idx_pos_tapExcl;

    %Defining the positions
    pos=PalNeurons.(fish{1}).positions_norm_Pal;
    
    %Finding the positions
    temp_PosResp_multiSens=pos(PosResp_multiSens_idx,:,:);
    temp_PosResp_lightExcl=pos(PosResp_lightExcl_idx,:,:);
    temp_PosResp_tapExcl=pos(PosResp_tapExcl_idx,:,:);
     
    %Plotting
    scatter3(pos(:,1),pos(:,2), pos(:,3),20, gray);
    %light exclusive
    scatter3(temp_PosResp_lightExcl(:,1),temp_PosResp_lightExcl(:,2),temp_PosResp_lightExcl(:,3), 40, orange, 'filled');
    %tap exclusive
    scatter3(temp_PosResp_tapExcl(:,1),temp_PosResp_tapExcl(:,2),temp_PosResp_tapExcl(:,3), 40, teal, 'filled');
    %multisens
    scatter3(temp_PosResp_multiSens(:,1),temp_PosResp_multiSens(:,2),temp_PosResp_multiSens(:,3), 40, purple, 'filled');


end
hold off

%Figure parameters
view(360,90);
xlim([-0.1 1.05]);
set(gca, 'ZDir', 'reverse')
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
% title('Sensory Exclusive and MultiSensory cells');
% legend('NonResp','LightExcl','VibExcl','MultiSensory');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');