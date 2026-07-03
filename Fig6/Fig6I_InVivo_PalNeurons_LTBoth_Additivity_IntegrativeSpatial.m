%% Interaction index classification of the integrative neurons plotted in space (Fig. 6I)
%This script plots the spatial locations of the  the previously identified integrative neurons 
% classified using their response characteristics (using their interaction index).
%The interaction index i.e., the indices of the classified Pallial neurons were obtained using the script: InVivo_PalNeurons_LightTapBoth_Additivity.m
%Each section of this script must be run indivudally in proper order.
%Legend for interaction index: -1 = depressed neuron, 0 = sub-Additive neuron, 2 = supper-additive neuron

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
%% Plotting the spatial location of the cells (for integrative neurons)

%Color definitions
gray=[0.8 0.8 0.8];
dred=[0.635294117647059	0.0784313725490196	0.184313725490196];
blue= [0.301960784313725	0.745098039215686	0.933333333333333];
gold=[0.9294    0.6941    0.1255];


%Variable definitions
%Combined positions of integrative neurons across animals
all_pos=[];
pos_superAdd_Pal=[];
pos_depressed_Pal=[];
pos_subAdd_Pal=[];

%
figure();
hold on;
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'} 


    idx_posResp_Multimod_New=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.bothStim.idx_pos_integrative;

    interact_code=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.interact_code;
    idx_superAdd=idx_posResp_Multimod_New(find(interact_code(idx_posResp_Multimod_New)==2));
    idx_depressed=idx_posResp_Multimod_New(find(interact_code(idx_posResp_Multimod_New)==-1));
    idx_subAdd=idx_posResp_Multimod_New(find(interact_code(idx_posResp_Multimod_New)==0));

    positionsPal=PalNeurons.(fish{1}).positions_norm_Pal;

    %Finding the positions
    temp_posSuperAdd_Pal=positionsPal(idx_superAdd,:);
    temp_posDepressed_Pal=positionsPal(idx_depressed,:);
    temp_posSubAdd_Pal=positionsPal(idx_subAdd,:);
    
    pos_superAdd_Pal=[pos_superAdd_Pal;temp_posSuperAdd_Pal];
    pos_depressed_Pal=[pos_depressed_Pal;temp_posDepressed_Pal];
    pos_subAdd_Pal=[pos_subAdd_Pal;temp_posSubAdd_Pal];

    all_pos=[all_pos;positionsPal];

end

%Plotting the positions of all pallial neurons
scatter3(all_pos(:,1),all_pos(:,2),all_pos(:,3), 20, gray,'MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6);

%Plotting the positions of the supper-additive neurons
scatter3(pos_superAdd_Pal(:,1),pos_superAdd_Pal(:,2),pos_superAdd_Pal(:,3), 40, gold, 'filled');

%Plotting the positions of the depressed neurons
scatter3(pos_depressed_Pal(:,1),pos_depressed_Pal(:,2),pos_depressed_Pal(:,3), 40, blue, 'filled');

%Plotting the positions of the sub-additive neurons
scatter3(pos_subAdd_Pal(:,1),pos_subAdd_Pal(:,2),pos_subAdd_Pal(:,3), 40, dred, 'filled');

hold off

view(360,90);
xlim([-0.1 1.05]);
ylim([0 1]);
set(gca, 'ZDir', 'reverse')
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
% legend('NonResp','Supper-Additive','Depressed','Sub-Additive');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
