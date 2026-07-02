%% Plotting the spatial locations of the responding Pallial neurons in an explant (Fig 4B)
%This script generates the spatial probability density plots for the responding Pallial neurons following an electrical PG micro-stimulation (ex-vivo).
%This script also plots the counts of responding Pallial neurons along the lateral-medial axis of the pallium.
%The indices of the responding Pallial neurons were obtained using the script: InVivo_PalNeurons_RespondingCells.m
%Each section of this script must be run indivudally in proper order.

%Input:
% Data file: 202606_PalNeurons_PGStim_Data.mat
% Analysis file (indices): 202606_PalNeurons_PGStim_Analysis.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path='C:\Users\Documents\...\2P_ExVivo_PalNeurons'; 
fileName_data = '202606_PalNeurons_PGStim_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_ExVivo_PalNeurons'; 
fileName_analysis = '202606_PalNeurons_PGStim_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);
%% Finding the normalized positions of the responding Pallial neurons (for all PG stim trials) (Fig. 4B)
%Note: Both hemisphere were analyzed together for these plots.
close all;

%for responding neurons
positive_resp_cells_Pal=[];
negative_resp_cells_Pal=[];

%for all Pallial neurons
all_cells=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
    
    %Finding the indices for the responding cells following PG stimulation
    idx_positive_resp_cells=Analysis_PG_Stim_Filt.(fish{1}).all.positive_resp_cells;
    idx_negative_resp_cells=Analysis_PG_Stim_Filt.(fish{1}).all.negative_resp_cells;
    
    %normalized positions of the Pallial neurons
    positions=Pallium_PGStim.(fish{1}).positions_norm_Pal;

    %Finding the positions
    pos_PosResp_Pal=positions(idx_positive_resp_cells,:);
    pos_NegResp_Pal=positions(idx_negative_resp_cells,:);

    positive_resp_cells_Pal=[positive_resp_cells_Pal;pos_PosResp_Pal];
    negative_resp_cells_Pal=[negative_resp_cells_Pal;pos_NegResp_Pal];

    all_cells=[all_cells;positions];
       
end


%Plotting the spatial locations for the responding neurons (Fig. 6B1, 6B2, top panels)

%Color definitions
gray=[0.8 0.8 0.8];

%Making the figure for the excited neurons
%Note: X-axis is multiplied by -1 to keep the ipsilateral side on the right side
figure();
scatter((all_cells(:,1)*-1),all_cells(:,2),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
hold on
scatter_kde((positive_resp_cells_Pal(:,1)*-1),positive_resp_cells_Pal(:,2),'filled','MarkerSize',50);
hold off
xlim([0 1]); 
ylim([0 1]); 
axis equal;
% cb = colorbar();
% cb.Label.String = 'Spatial probability density';
colormap(ColorLegend_positive);
caxis([0 3]);
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
title('Excited neurons');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the inhibited neurons
figure();
scatter((all_cells(:,1)*-1),all_cells(:,2),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
hold on
scatter_kde((negative_resp_cells_Pal(:,1)*-1),negative_resp_cells_Pal(:,2),'filled','MarkerSize',50);
hold off
xlim([0 1]); 
ylim([0 1]); 
axis equal;
% cb = colorbar();
% cb.Label.String = 'Spatial probability density';
colormap(ColorLegend_negative);
caxis([0 4]);
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
title('Inhibited neurons');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');




%% Plotting the counts of responding Pallial neurons along the lateral-medial axis (Fig. 4B)

%Plotting the distribution of responding neurons
%Defining the parameters
edges=[0:0.01:1];
all_cellsCounts=flip(histcounts(all_cells(:,2),edges));
all_PosResp_cellCounts=flip(histcounts(positive_resp_cells_Pal(:,1),edges));
all_NegResp_cellCounts=flip(histcounts(negative_resp_cells_Pal(:,1),edges));

%Making the figure for the excited neurons
f3=figure();
f3.Units="centimeters";
f3.Position=[10 15 6 2];
plot(edges(2:end),all_PosResp_cellCounts,'Color','r','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 70]);
ylabel('Counts of responding neurons');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:20:70]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the inhibited neurons
f4=figure();
f4.Units="centimeters";
f4.Position=[10 15 6 2];
plot(edges(2:end),all_NegResp_cellCounts,'Color','b','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 25]);
ylabel('Counts of responding neurons');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:10:25]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

