%% Plotting the spatial locations of the responding Pallial neurons in an explant (Fig 4D)
%This script generates the normalized spatial locations of the reliably responding Pallial neurons following an electrical PG micro-stimulation (ex-vivo).
%This script also plots the counts of reliable Pallial neurons along the lateral-medial axis of the pallium.
%The indices of the reliable Pallial neurons were obtained using the script: InVivo_PalNeurons_RespondingCells.m
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
%% Finding the normalized positions of the responding Pallial neurons (following a PG stimulation) (Fig. 4D, top panel)
%Note: Both hemisphere were analyzed together for these plots.
close all;

%Threshold for determining reliably activated neurons across trials
alpha=0.1;

%for the reliable neurons
reliable_resp_Cells_Pal=[];
colorcode=[];

%for all Pallial neurons
all_cells=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
    
    %Finding the indices for light responding cells
    acrossTrial_Corr_Pal=Analysis_PG_Stim_Filt.(fish{1}).all.all_cell_avg_corr;
    acrossTrial_Corr_pVal_Pal=Analysis_PG_Stim_Filt.(fish{1}).all.all_cell_corr_pVal;
    
    %select cells that crosses alpha threshold
    idx_reliableCells=find(acrossTrial_Corr_pVal_Pal<=alpha); 

    reliable_Corr=acrossTrial_Corr_Pal(idx_reliableCells);
    colorcode=[colorcode;reliable_Corr];

    %normalized positions of the Pallial neurons
    positions=Pallium_PGStim.(fish{1}).positions_norm_Pal;

    %Finding the positions
    pos_Corr_pal=positions(idx_reliableCells,:);

    reliable_resp_Cells_Pal=[reliable_resp_Cells_Pal;pos_Corr_pal];
    all_cells=[all_cells;positions];
       
end
%color definition
gray=[0.8 0.8 0.8];

%creating the figure
figure();
hold on
scatter((all_cells(:,1)*-1),all_cells(:,2),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
scatter((reliable_resp_Cells_Pal(:,1)*-1),reliable_resp_Cells_Pal(:,2), 50, colorcode,'filled');
hold off
view(360,90); %default view
% view(268.1617,-4.2); %side view
clim([0 0.8]); 
colormap (viridis);
grid off;
axis equal;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
% title('reliable cells');
cb = colorbar();
cb.Label.String = 'Across-trial correlations';
cb.Label.FontSize = 12;
cb.Ticks=[0, 0.8];
cb.TickLabels={'0', '>0.8'};

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Plotting the counts of reliable (high correlation across trials) Pallial neurons along the lateral-medial axis (Fig. 4D, bottom panel)

%Plotting the distribution of responding neurons (Fig. 6B1, 6B2)
%color
green=[0.411764705882353	0.749019607843137	0.380392156862745];

%Defining the parameters
edges=[0:0.01:1];
all_cellsCounts=flip(histcounts(all_cells(:,2),edges));
all_ReliableResp_cellCounts=flip(histcounts(reliable_resp_Cells_Pal(:,1),edges));

%Making the figure for the excited neurons
f3=figure();
f3.Units="centimeters";
f3.Position=[10 15 6 2];
plot(edges(2:end),all_ReliableResp_cellCounts,'Color',green,'LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 20]);
ylabel('Counts of responding neurons');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:20:70]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
