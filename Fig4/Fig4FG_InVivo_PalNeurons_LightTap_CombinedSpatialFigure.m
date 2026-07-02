%% Plotting the spatial locations of the responding Pallial neurons in vivo (Fig 4F, 4G)
%This script generates the spatial probability density plots for the Pallial neurons.
%This script also plots the counts of responding Pallial neurons along the lateral-medial axis of the pallium.
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
%% Finding the normalized positions of the responding Pallial neurons (for all sensory stimuli) (Fig. 4F, 4G)
close all;
%Color definitions
gray=[0.8 0.8 0.8];

for cellType=1:4 %looping across the different celltypes; 1: light exc, 2: light inh, 3: vib exc, 4: vib inh
    figure();
    hold on
    for hemi=1:2 %looping across each hemisphere
        %Finding the positions of the neurons according to each cell type.
        %for light responding neurons
        positive_resp_cells_light_Pal=[];
        negative_resp_cells_light_Pal=[];
        
        %for Vib responding neurons
        positive_resp_cells_Vib_Pal=[];
        negative_resp_cells_Vib_Pal=[];
        
        %for all Pallial neurons
        all_cells=[];

        %Grouping the data first
        for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
            
            %Defining hemisphere indices
            hemi_Pal=PalNeurons.(fish{1}).hemisphereIndex;       
        
            %Finding the indices for light responding cells    
            idx_positive_resp_cells_light=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.light.positive_resp_cells;
            idx_negative_resp_cells_light=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.light.negative_resp_cells;
                
            idx_PosResp_light=idx_positive_resp_cells_light(find(hemi_Pal(idx_positive_resp_cells_light)==hemi));
            idx_NegResp_light=idx_negative_resp_cells_light(find(hemi_Pal(idx_negative_resp_cells_light)==hemi));
                
            %Finding the indices for Vib responding neurons    
            idx_positive_resp_cells_Vib=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.tap.positive_resp_cells;
            idx_negative_resp_cells_Vib=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.tap.negative_resp_cells;
                    
            idx_PosResp_Vib=idx_positive_resp_cells_Vib(find(hemi_Pal(idx_positive_resp_cells_Vib)==hemi));
            idx_NegResp_Vib=idx_negative_resp_cells_Vib(find(hemi_Pal(idx_negative_resp_cells_Vib)==hemi));
            
            %normalized positions of the Pallial neurons
            positions=PalNeurons.(fish{1}).positions_norm_Pal;
            pos_hemi=positions(find(hemi_Pal==hemi),:); 
        
            %Finding the positions
            pos_PosResp_light_Pal=positions(idx_PosResp_light,:);
            pos_NegResp_light_Pal=positions(idx_NegResp_light,:);        
            positive_resp_cells_light_Pal=[positive_resp_cells_light_Pal;pos_PosResp_light_Pal];
            negative_resp_cells_light_Pal=[negative_resp_cells_light_Pal;pos_NegResp_light_Pal];
        
            pos_PosResp_Vib_Pal=positions(idx_PosResp_Vib,:);
            pos_NegResp_Vib_Pal=positions(idx_NegResp_Vib,:);        
            positive_resp_cells_Vib_Pal=[positive_resp_cells_Vib_Pal;pos_PosResp_Vib_Pal];
            negative_resp_cells_Vib_Pal=[negative_resp_cells_Vib_Pal;pos_NegResp_Vib_Pal];
        
            all_cells=[all_cells;pos_hemi];               
        end

        % Plotting the spatial locations for the light responding neurons (Fig. 6F1, 6F2)
        if cellType==1            
            %Making the figure for the excited neurons
            scatter3(all_cells(:,1),all_cells(:,2),all_cells(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(positive_resp_cells_light_Pal(:,1),positive_resp_cells_light_Pal(:,2),'filled','MarkerSize',50);
            
            xlim([-0.1 1.05]); 
            ylim([0 1]); 
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_positive);
            caxis([0 7]);
            view(360,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Light excited neurons');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end
        
        if cellType==2
            %Making the figure for the inhibited neurons
            scatter3(all_cells(:,1),all_cells(:,2),all_cells(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(negative_resp_cells_light_Pal(:,1),negative_resp_cells_light_Pal(:,2),'filled','MarkerSize',50);
            
            xlim([-0.1 1.05]); 
            ylim([0 1]); 
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_negative);
            caxis([0 7]);
            view(360,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Light inhibited neurons');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end
        
        % Plotting the spatial locations for the Vibration responding neurons  (Fig. 6G1, 6G2)
        if cellType ==3            
            %Making the figure for the excited neurons
            scatter3(all_cells(:,1),all_cells(:,2),all_cells(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(positive_resp_cells_Vib_Pal(:,1),positive_resp_cells_Vib_Pal(:,2),'filled','MarkerSize',50);
            
            xlim([-0.1 1.05]); 
            ylim([0 1]); 
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_positive);
            caxis([0 6]);
            % colorbar;
            view(360,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Vib excited neurons');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end
        
        if cellType==4
            %Making the figure for the inhibited neurons
            scatter3(all_cells(:,1),all_cells(:,2),all_cells(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(negative_resp_cells_Vib_Pal(:,1),negative_resp_cells_Vib_Pal(:,2),'filled','MarkerSize',50);
            
            xlim([-0.1 1.05]); 
            ylim([0 1]); 
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_negative);
            caxis([0 7]);
            view(360,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Vib inhibited neurons');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end
    end
end

%% Plotting the counts of responding Pallial neurons along the lateral-medial axis (for all sensory stimuli) (Fig. 4F,4G)
%Note: Both hemisphere were analyzed together for these plots.
close all;

%for light responding neurons
positive_resp_cells_light_Pal=[];
negative_resp_cells_light_Pal=[];

%for Vib responding neurons
positive_resp_cells_Vib_Pal=[];
negative_resp_cells_Vib_Pal=[];

%for all Pallial neurons
all_cells=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}

    %Finding the indices for light responding neurons
    idx_positive_resp_cells_light=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.light.positive_resp_cells;
    idx_negative_resp_cells_light=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.light.negative_resp_cells;

    %Finding the indices for Vib responding neurons
    idx_positive_resp_cells_Vib=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.tap.positive_resp_cells;
    idx_negative_resp_cells_Vib=Analysis_PalliumMultiModal_Filt.(fish{1}).responding.tap.negative_resp_cells;

    %normalized positions of the Pallial neurons
    positions=PalNeurons.(fish{1}).positions_norm_Pal;
    
    %Finding the positions
    pos_PosResp_light_Pal=positions(idx_positive_resp_cells_light,:);
    pos_NegResp_light_Pal=positions(idx_negative_resp_cells_light,:);

    positive_resp_cells_light_Pal=[positive_resp_cells_light_Pal;pos_PosResp_light_Pal];
    negative_resp_cells_light_Pal=[negative_resp_cells_light_Pal;pos_NegResp_light_Pal];

    pos_PosResp_Vib_Pal=positions(idx_positive_resp_cells_Vib,:);
    pos_NegResp_Vib_Pal=positions(idx_negative_resp_cells_Vib,:);

    positive_resp_cells_Vib_Pal=[positive_resp_cells_Vib_Pal;pos_PosResp_Vib_Pal];
    negative_resp_cells_Vib_Pal=[negative_resp_cells_Vib_Pal;pos_NegResp_Vib_Pal];

    all_cells=[all_cells;positions];     
end


%% Plotting the distribution of light responding neurons (Fig. 4F, 4G left panels)
%Defining the parameters
edges=[0:0.01:1];
all_cellsCounts=flip(histcounts(all_cells(:,2),edges));
all_lightPosResp_cellCounts=flip(histcounts(positive_resp_cells_light_Pal(:,2),edges));
all_lightNegResp_cellCounts=flip(histcounts(negative_resp_cells_light_Pal(:,2),edges));

%Making the figure for the excited neurons
f3=figure();
f3.Units="centimeters";
f3.Position=[10 15 6 2];
plot(edges(2:end),all_lightPosResp_cellCounts,'Color','r','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 40]);
ylabel('Counts of responding neurons');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:50:200]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the inhibited neurons
f4=figure();
f4.Units="centimeters";
f4.Position=[10 15 6 2];
plot(edges(2:end),all_lightNegResp_cellCounts,'Color','b','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 15]);
ylabel('Counts of responding neurons');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:25:50]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Plotting the distribution of the Vibration responding neurons  (Fig. 4F, 4G, right panels)
%Defining the parameters
edges=[0:0.01:1];
all_cellsCounts=flip(histcounts(all_cells(:,2),edges));
all_VibPosResp_cellCounts=flip(histcounts(positive_resp_cells_Vib_Pal(:,2),edges));
all_VibNegResp_cellCounts=flip(histcounts(negative_resp_cells_Vib_Pal(:,2),edges));

%Making the figure for the excited neurons
f5=figure();
f5.Units="centimeters";
f5.Position=[10 15 6 2];
plot(edges(2:end),all_VibPosResp_cellCounts,'Color','r','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 45]);
ylabel('Counts of responding neurons');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:50:200]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the inhibited neurons
f6=figure();
f6.Units="centimeters";
f6.Position=[10 15 6 2];
plot(edges(2:end),all_VibNegResp_cellCounts,'Color','b','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 15]);
ylabel('Counts of responding neurons');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:25:50]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');