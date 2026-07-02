%% Plotting the spatial locations of the responding PG neurons in vivo (Fig 2G, 2H)
%This script generates the spatial probability density plots for the PG responding neurons
%The indices of the responding PG neurons were obtained using the script: InVivo_PGOnly_RespondingCells.m
%Each section of this script must be run indivudally in proper order.
%This script uses the normalized positions of the all detected neurons and normalized positions of the PG neurons.

%Input:
% Data file: 202606_PGNeurons_LightTap_Data.mat
% Analysis file (indices): 202606_PGNeurons_LightTap_Analysis

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
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

%% Plotting the normalized spatial location of all detected neurons 
%Used as a background for the location of the PG neurons
%Color Definition
gray=[0.8 0.8 0.8];

f1=figure(1);
hold on;
for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
  
    pos=PGNeurons.(fish{1}).positions_norm_fish;
         
    %Plotting
    scatter3(pos(:,1),pos(:,2), pos(:,3),20, gray);
end
hold off

%Re-orient the brain
view(360,90);
set(gca, 'ZDir', 'reverse')
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
title('Background of all detected neurons');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');



%% Finding the normalized positions of the responding PG neurons (for all sensory stimuli)
% close all;
for hemi=1:2 %for each brain hemisphere
%for light responding neurons
positive_resp_cells_light=[];
negative_resp_cells_light=[];

%for Vib responding neurons
positive_resp_cells_Vib=[];
negative_resp_cells_Vib=[];

%for all PG neurons
all_cells_PG=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    
    %Defining the region and hemisphere indices
    region=PGNeurons.(fish{1}).regionIndex_PG;
    temp_region=find(region==12);
    hemisphere=PGNeurons.(fish{1}).hemisphereIndex;
    temp_hemi=find(hemisphere==hemi);

    idx_hemiPG=find(ismember(temp_region,temp_hemi)==1);

    %Finding the indices for light responding neurons
    temp_PosResp_light=Analysis_LightTap_Filt.(fish{1}).all.light.positive_resp_cells;
    temp_PosResp_light_PG=ismember(idx_hemiPG,temp_PosResp_light);
    temp_NegResp_light=Analysis_LightTap_Filt.(fish{1}).all.light.negative_resp_cells;
    temp_NegResp_light_PG=ismember(idx_hemiPG,temp_NegResp_light);

    %Finding the indices for Vib responding neurons
    temp_PosResp_Vib=Analysis_LightTap_Filt.(fish{1}).all.tap.positive_resp_cells;
    temp_PosResp_Vib_PG=ismember(idx_hemiPG,temp_PosResp_Vib);
    temp_NegResp_Vib=Analysis_LightTap_Filt.(fish{1}).all.tap.negative_resp_cells;
    temp_NegResp_Vib_PG=ismember(idx_hemiPG,temp_NegResp_Vib);
    
    %normalized positions of the PG neurons
    positions=PGNeurons.(fish{1}).positions_norm_PG;
    positionsPG=positions(idx_hemiPG,:);
    
    %Finding the positions
    temp_positionsPos_light=positionsPG(find(temp_PosResp_light_PG==1),:,:);
    temp_positionsNeg_light=positionsPG(find(temp_NegResp_light_PG==1),:,:);

    positive_resp_cells_light=[positive_resp_cells_light;temp_positionsPos_light];
    negative_resp_cells_light=[negative_resp_cells_light;temp_positionsNeg_light];

    temp_positionsPos_Vib=positionsPG(find(temp_PosResp_Vib_PG==1),:,:);
    temp_positionsNeg_Vib=positionsPG(find(temp_NegResp_Vib_PG==1),:,:);

    positive_resp_cells_Vib=[positive_resp_cells_Vib;temp_positionsPos_Vib];
    negative_resp_cells_Vib=[negative_resp_cells_Vib;temp_positionsNeg_Vib];

    all_cells_PG=[all_cells_PG;positionsPG];     
end


%% Plotting the spatial locations for the light responding neurons (Fig. 2G, 2H, left panels)

%Color definitions
dgray=[0.6 0.6 0.6];

%Making the figure for the excited neurons
figure();
scatter3(all_cells_PG(:,1),all_cells_PG(:,2),all_cells_PG(:,3),35, dgray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
hold on
scatter_kde(positive_resp_cells_light(:,1),positive_resp_cells_light(:,2),'filled','MarkerSize',45);
hold off
xlim([-0.4 2.2]); %for aligning with rest of the brain (making figures)
ylim([-0.2 1.2]); %for aligning with rest of the brain (making figures)
% cb = colorbar();
% cb.Label.String = 'Spatial probability density';
colormap(ColorLegend_positive);
caxis([0 12]);
% colorbar;
view(360,90); %default
set(gca, 'ZDir', 'reverse');
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the inhibited neurons
figure();
scatter3(all_cells_PG(:,1),all_cells_PG(:,2),all_cells_PG(:,3),30, dgray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
hold on
scatter_kde(negative_resp_cells_light(:,1),negative_resp_cells_light(:,2),'filled','MarkerSize',45);
hold off
xlim([-0.4 2.2]); %for aligning with rest of the brain (making figures)
ylim([-0.2 1.2]); %for aligning with rest of the brain (making figures)
% cb = colorbar();
% cb.Label.String = 'Spatial probability density';
colormap(ColorLegend_negative);
caxis([0 12]);
% colorbar;
view(360,90); %default
set(gca, 'ZDir', 'reverse');
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');


%% Plotting the spatial locations for the Vibration responding neurons  (Fig. 2G, 2H, right panels)

%Color definitions
dgray=[0.6 0.6 0.6];

%Making the figure
figure();
scatter3(all_cells_PG(:,1),all_cells_PG(:,2),all_cells_PG(:,3),35, dgray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
hold on
scatter_kde(positive_resp_cells_Vib(:,1),positive_resp_cells_Vib(:,2),'filled','MarkerSize',45);
hold off
xlim([-0.4 2.2]); %for aligning with rest of the brain (making figures)
ylim([-0.2 1.2]); %for aligning with rest of the brain (making figures)
% cb = colorbar();
% cb.Label.String = 'Spatial probability density';
colormap(ColorLegend_positive);
caxis([0 12]);
% colorbar;
view(360,90); %default
set(gca, 'ZDir', 'reverse');
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

figure();
scatter3(all_cells_PG(:,1),all_cells_PG(:,2),all_cells_PG(:,3),30, dgray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
hold on
scatter_kde(negative_resp_cells_Vib(:,1),negative_resp_cells_Vib(:,2),'filled','MarkerSize',45);
hold off
xlim([-0.4 2.2]); %for aligning with rest of the brain (making figures)
ylim([-0.2 1.2]); %for aligning with rest of the brain (making figures)
% cb = colorbar();
% cb.Label.String = 'Spatial probability density';
colormap(ColorLegend_negative);
caxis([0 12]);
% colorbar;
view(360,90); %default
set(gca, 'ZDir', 'reverse');
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

end