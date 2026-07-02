%% Plotting the spatial locations of the responding Pallial PG axons in vivo (Fig 3H, 3I)
%This script generates the spatial probability density plots for the PG axonal pixels in the pallium
%This script also plots the counts of responding PG axonal pixels along the lateral-medial axis of the pallium.
%The indices of the responding PG axonal pixels were obtained using the script: InVivo_PGAxons_RespondingPixels.m
%Each section of this script must be run indivudally in proper order.

%Input:
% Data file: 202606_PGAxons_LightTap_Data.mat
% Analysis file (indices): 202606_PGAxons_LightTap_Analysis.mat
%Used the normalized positions of the all detected pixels within the region of interest containing the PG axons (see Fig. 3B)

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path= 'C:\Users\Documents\...\2P_PGAxons';
fileName_data = '202606_PGAxons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_PGAxons';
fileName_analysis = '202606_PGAxons_LightTap_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);

%% Finding the normalized positions of the responding Pallial PG axonal pixels (for all sensory stimuli) (Fig. 3H)
close all;
%Color definitions
gray=[0.8 0.8 0.8];

for cellType=1:4 %looping across the different celltypes; 1: light exc, 2: light inh, 3: vib exc, 4: vib inh
    figure();
    hold on
    for hemi=1:2 %looping across each hemisphere
        %Finding the positions of the neurons according to each cell type.
        %for light responding neurons
        positive_resp_pixels_light_Pal=[];
        negative_resp_pixels_light_Pal=[];
        
        %for Vib responding pixels
        positive_resp_pixels_Vib_Pal=[];
        negative_resp_pixels_Vib_Pal=[];
        
        %for all PG axonal pixels
        all_pixels=[];
        
        %Grouping the data first
        for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
            
            %Defining hemisphere indices
            temp_hemi=PGAxons.(fish{1}).hemisphereIndex;
        
            %Finding the indices for light responding pixels
            id_PosResp_light=Analysis_PGAxons_Filt.(fish{1}).all.light.positive_resp_pixels;
            id_NegResp_light=Analysis_PGAxons_Filt.(fish{1}).all.light.negative_resp_pixels;
        
            idx_PosResp_light=id_PosResp_light(find(temp_hemi(id_PosResp_light)==hemi));
            idx_NegResp_light=id_NegResp_light(find(temp_hemi(id_NegResp_light)==hemi));

            %Finding the indices for Vib responding pixels
            id_PosResp_tap=Analysis_PGAxons_Filt.(fish{1}).all.tap.positive_resp_pixels;
            id_NegResp_tap=Analysis_PGAxons_Filt.(fish{1}).all.tap.negative_resp_pixels;
        
            idx_PosResp_tap=id_PosResp_tap(find(temp_hemi(id_PosResp_tap)==hemi));
            idx_NegResp_tap=id_NegResp_tap(find(temp_hemi(id_NegResp_tap)==hemi));
            
            %normalized positions of the PG axonal pixels
            positions=PGAxons.(fish{1}).bin_positions_norm_fish;
            pos_hemi=positions(find(temp_hemi==hemi),:);
            
            %Finding the positions
            pos_PosResp_light_Pal=positions(idx_PosResp_light,:);
            pos_NegResp_light_Pal=positions(idx_NegResp_light,:);
        
            positive_resp_pixels_light_Pal=[positive_resp_pixels_light_Pal;pos_PosResp_light_Pal];
            negative_resp_pixels_light_Pal=[negative_resp_pixels_light_Pal;pos_NegResp_light_Pal];
        
            pos_PosResp_tap_Pal=positions(idx_PosResp_tap,:);
            pos_NegResp_tap_Pal=positions(idx_NegResp_tap,:);
        
            positive_resp_pixels_Vib_Pal=[positive_resp_pixels_Vib_Pal;pos_PosResp_tap_Pal];
            negative_resp_pixels_Vib_Pal=[negative_resp_pixels_Vib_Pal;pos_NegResp_tap_Pal];
        
            all_pixels=[all_pixels;pos_hemi];
               
        end     
      
        % Plotting the spatial locations for the light responding pixels (Fig. 3H, 3I, left panels)
        if cellType==1     
            %Making the figure for the excited pixels
            scatter3(all_pixels(:,1),all_pixels(:,2),all_pixels(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(positive_resp_pixels_light_Pal(:,1),positive_resp_pixels_light_Pal(:,2),'filled','MarkerSize',50);
            xlim([0 1]);
            ylim([0 1]);
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_positive);
            caxis([0 10.5]);
            view(270,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Light excited pixels');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end
        if cellType==2            
            %Making the figure for the inhibited pixels
            scatter3(all_pixels(:,1),all_pixels(:,2),all_pixels(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(negative_resp_pixels_light_Pal(:,1),negative_resp_pixels_light_Pal(:,2),'filled','MarkerSize',50);
            xlim([0 1]);
            ylim([0 1]);
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_negative);
            caxis([0 14]);
            view(270,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Light inhibited pixels');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end
    
    
        % Plotting the spatial locations for the Vibration responding pixels  (Fig. 3H, 3I, right panels)
        if cellType ==3  
            %Making the figure for excited pixels        
            scatter3(all_pixels(:,1),all_pixels(:,2),all_pixels(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(positive_resp_pixels_Vib_Pal(:,1),positive_resp_pixels_Vib_Pal(:,2),'filled','MarkerSize',50);      
            xlim([0 1]);
            ylim([0 1]);
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_positive);
            caxis([0 12]);
            % colorbar;
            view(270,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Vib excited pixels');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end

        if cellType==4
            %Making the figure for the inhibited neurons   
            scatter3(all_pixels(:,1),all_pixels(:,2),all_pixels(:,3),30, gray,'filled','MarkerFaceAlpha',0.6,'MarkerEdgeAlpha',0.6);
            scatter_kde(negative_resp_pixels_Vib_Pal(:,1),negative_resp_pixels_Vib_Pal(:,2),'filled','MarkerSize',50);
            xlim([0 1]);
            ylim([0 1]);
            % cb = colorbar();
            % cb.Label.String = 'Spatial probability density';
            colormap(ColorLegend_negative);
            caxis([0 14]);
            view(270,90);
            set(gca, 'ZDir', 'reverse')
            grid off;
            set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
            title('Vib inhibited pixels');
            
            %for saving as svg image file
            set(gcf, 'InvertHardCopy', 'off');
            set(gcf, 'DefaultFigureRenderer', 'painters');
            set(gcf,'renderer','painters');
        end
    
    end
end
%% Plotting the counts of responding Pallial PG axonal pixels along the lateral-medial axis (for all sensory stimuli) (Fig. 3H, 3I)
%Note: Both hemisphere were analyzed together for these plots.
close all;

%for light responding pixels
positive_resp_pixels_light_Pal=[];
negative_resp_pixels_light_Pal=[];

%for Vib responding pixels
positive_resp_pixels_Vib_Pal=[];
negative_resp_pixels_Vib_Pal=[];

%for all PG axonal pixels
all_pixels=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}

    %Finding the indices for light responding pixels
    id_PosResp_light=Analysis_PGAxons_Filt.(fish{1}).all.light.positive_resp_pixels;
    id_NegResp_light=Analysis_PGAxons_Filt.(fish{1}).all.light.negative_resp_pixels;


    %Finding the indices for Vib responding pixels
    id_PosResp_tap=Analysis_PGAxons_Filt.(fish{1}).all.tap.positive_resp_pixels;
    id_NegResp_tap=Analysis_PGAxons_Filt.(fish{1}).all.tap.negative_resp_pixels;

    %normalized positions of the PG axonal pixels
    positions=PGAxons.(fish{1}).bin_positions_norm_fish;
    
    %Finding the positions
    pos_PosResp_light_Pal=positions(id_PosResp_light,:);
    pos_NegResp_light_Pal=positions(id_NegResp_light,:);

    positive_resp_pixels_light_Pal=[positive_resp_pixels_light_Pal;pos_PosResp_light_Pal];
    negative_resp_pixels_light_Pal=[negative_resp_pixels_light_Pal;pos_NegResp_light_Pal];

    pos_PosResp_tap_Pal=positions(id_PosResp_tap,:);
    pos_NegResp_tap_Pal=positions(id_NegResp_tap,:);

    positive_resp_pixels_Vib_Pal=[positive_resp_pixels_Vib_Pal;pos_PosResp_tap_Pal];
    negative_resp_pixels_Vib_Pal=[negative_resp_pixels_Vib_Pal;pos_NegResp_tap_Pal];

    all_pixels=[all_pixels;positions];     
end


%% Plotting the distribution of light responding pixels (Fig. 3H, 3I, left panels)
%Defining the parameters
edges=[0:0.01:1];
all_pixelsCounts=flip(histcounts(all_pixels(:,2),edges));
all_lightPosResp_cellCounts=flip(histcounts(positive_resp_pixels_light_Pal(:,2),edges));
all_lightNegResp_cellCounts=flip(histcounts(negative_resp_pixels_light_Pal(:,2),edges));

%Making the figure for the excited pixels
f3=figure();
f3.Units="centimeters";
f3.Position=[10 15 6 2];
plot(edges(2:end),all_lightPosResp_cellCounts,'Color','r','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 200]);
ylabel('Counts of responding pixels');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:50:200]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the inhibited pixels
f4=figure();
f4.Units="centimeters";
f4.Position=[10 15 6 2];
plot(edges(2:end),all_lightNegResp_cellCounts,'Color','b','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 50]);
ylabel('Counts of responding pixels');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:25:50]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Plotting the distribution of the Vibration responding pixels  (Fig. 3H, 3I, right panels)
%Defining the parameters
edges=[0:0.01:1];
all_pixelsCounts=flip(histcounts(all_pixels(:,2),edges));
all_VibPosResp_cellCounts=flip(histcounts(positive_resp_pixels_Vib_Pal(:,2),edges));
all_VibNegResp_cellCounts=flip(histcounts(negative_resp_pixels_Vib_Pal(:,2),edges));

%Making the figure for the excited pixels
f5=figure();
f5.Units="centimeters";
f5.Position=[10 15 6 2];
plot(edges(2:end),all_VibPosResp_cellCounts,'Color','r','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 200]);
ylabel('Counts of responding pixels');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:50:200]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the inhibited pixels
f6=figure();
f6.Units="centimeters";
f6.Position=[10 15 6 2];
plot(edges(2:end),all_VibNegResp_cellCounts,'Color','b','LineWidth',1.5); %raw counts
xlim([0 1.01]);
ylim([0 50]);
ylabel('Counts of responding pixels');
xline(0.5,'-.k','linewidth', 1.5);
box off;
set(gca, 'XTick', [0.1 0.5 0.9],'XTickLabel', {'Lateral', 'Medial', 'Lateral'} );
set(gca, 'YTick', [0:25:50]);

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');