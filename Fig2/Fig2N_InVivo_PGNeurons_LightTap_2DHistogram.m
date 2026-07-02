%% Plotting the 2D histograms for the responses selectivity of the PG neurons (Fig. 2L)
%This script plots the spatial positions of the excited PG neurons following Light and Vibration as a 2D histogram.
%The indices of the responding PG neurons were obtained using the script: InVivo_PGOnly_RespondingCells.m
%Each section of this script must be run indivudally in proper order.

%Input:
% Data file: 202606_PGNeurons_LightTap_Data.mat
% Analysis file (indices): 202606_PGNeurons_LightTap_Analysis

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path= 'C:\Users\Documents\...\2P_PGNeurons'; 
fileName_data = '202606_PGNeurons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_PGNeurons'; 
fileName_analysis = '202606_PGNeurons_LightTap_Analysis';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);
%% Finding the normalized positions of the responding PG neurons (for all sensory stimuli)

%for light responding neurons
positive_resp_cells_light=[];

%for Vib responding neurons
positive_resp_cells_Vib=[];

%for all PG neurons
all_cells_PG=[];

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    %Finding the indices for light responding neurons
    temp_PosResp_light_PG=Analysis_LightTap_Filt.(fish{1}).all.light.positive_resp_cells;

    %Finding the indices for Vib responding neurons
    temp_PosResp_Vib_PG=Analysis_LightTap_Filt.(fish{1}).all.tap.positive_resp_cells;
    
    %normalized positions of the PG neurons
    positionsPG=PGNeurons.(fish{1}).positions_norm_PG;
    
    %Finding the positions
    temp_positionsPos_light=positionsPG(temp_PosResp_light_PG,:,:);
    positive_resp_cells_light=[positive_resp_cells_light;temp_positionsPos_light];

    temp_positionsPos_Vib=positionsPG(temp_PosResp_Vib_PG,:,:);
    positive_resp_cells_Vib=[positive_resp_cells_Vib;temp_positionsPos_Vib];

    all_cells_PG=[all_cells_PG;positionsPG];
       
end


%% 2D Histogram for individual stimuli responding cells
%Defining the spatial position coodinates
x1 = positive_resp_cells_light(:,1);
y1 = positive_resp_cells_light(:,2);

x2 = positive_resp_cells_Vib(:,1);
y2 = positive_resp_cells_Vib(:,2);

% Define the number of bins for X and Y (for the histogram)
num_bins_x = 30;
num_bins_y = 30;

% Create the 2D histogram
binCounts_light=hist3([y1 x1], 'CDataMode', 'auto', 'Edges', {linspace(0, 1, num_bins_y), linspace(0, 1, num_bins_x)});
binCounts_Vib=hist3([y2 x2], 'CDataMode', 'auto', 'Edges', {linspace(0, 1, num_bins_y), linspace(0, 1, num_bins_x)});

%Filter the histogram
binCounts_light=imgaussfilt(binCounts_light,0.85,'FilterSize',3);
binCounts_Vib=imgaussfilt(binCounts_Vib,0.85,'FilterSize',3);

%Making the figure for the light responding cells
f1=figure();
f1.Units="centimeters";
f1.Position=[10 15 5 8.75];
imagesc(binCounts_light);
%Figure parameters
set(gca,'YDir','normal');
colorbar;
colormap hot;
clim([0 4]);
title('Light');

% %for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Making the figure for the Vib responding cells
f2=figure();
f2.Units="centimeters";
f2.Position=[10 15 5 8.75];
imagesc(binCounts_Vib);
%Figure parameters
set(gca,'YDir','normal');
colorbar;
colormap hot;
clim([0 4]);
title('Vibration');

% %for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% 2D Histogram (difference)
%Defining the spatial position coodinates
x1 = positive_resp_cells_light(:,1);
y1 = positive_resp_cells_light(:,2);

x2 = positive_resp_cells_Vib(:,1);
y2 = positive_resp_cells_Vib(:,2);

% Define the number of bins for X and Y (for the histogram)
num_bins_x = 30;
num_bins_y = 30;

% Create the 2D histogram
n_light=hist3([y1 x1], 'CDataMode', 'auto', 'Edges', {linspace(0, 1, num_bins_y), linspace(0, 1, num_bins_x)});
n_Vib=hist3([y2 x2], 'CDataMode', 'auto', 'Edges', {linspace(0, 1, num_bins_y), linspace(0, 1, num_bins_x)});

%Normalized by the max # of responding cells per modality
n_light=n_light/size(positive_resp_cells_light,1);
n_Vib=n_Vib/size(positive_resp_cells_Vib,1);

%Filter the histogram
n_light_filt=imgaussfilt(n_light,0.85,'FilterSize',3); %filter
n_tap_filt=imgaussfilt(n_Vib,0.85,'FilterSize',3);

%Finding the differences of the bin counts (per stim modality)
n_diff_filt=n_light_filt-n_tap_filt;

%Making the figure (difference histogram)
f3=figure();
f3.Units="centimeters";
f3.Position=[10 15 5 8.75];
imagesc(n_diff_filt);
%Figure parameters
set(gca,'YDir','normal');
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
box off;
colorbar;
clim([-0.005 0.005]);
colormap (Colormap_LightTap);
% title('Difference');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Finding the normalized positions of the responding PG neurons (for all sensory stimuli)
close all;
%for light responding neurons
voxel_resp_cells_light={};

%for Vib responding neurons
voxel_resp_cells_Vib={};

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    %Defining the indices for light and vib responding pixels
    temp_PosResp_light_PG=Analysis_LightTap_Filt.(fish{1}).all.light.positive_resp_cells;
    temp_PosResp_Vib_PG=Analysis_LightTap_Filt.(fish{1}).all.tap.positive_resp_cells;
    
    %normalized positions of the PG neurons
    positionsPG=PGNeurons.(fish{1}).positions_norm_PG;
    
    %Finding the positions
    temp_positionsPos_light=positionsPG(temp_PosResp_light_PG,:,:);
    temp_positionsPos_Vib=positionsPG(temp_PosResp_Vib_PG,:,:); 

    %Defining the spatial position coordinates
    x1 = temp_positionsPos_light(:,1);
    y1 = temp_positionsPos_light(:,2);
    
    x2 = temp_positionsPos_Vib(:,1);
    y2 = temp_positionsPos_Vib(:,2);
    
    %Define the number of bins for X and Y (for the histogram)
    num_bins_x = 30;
    num_bins_y = 30;
    
    %Finding the counts for each voxel (spatial bin)
    binCounts_light=hist3([y1 x1], 'CDataMode', 'auto', 'Edges', {linspace(0, 1, num_bins_y), linspace(0, 1, num_bins_x)});
    binCounts_Vib=hist3([y2 x2], 'CDataMode', 'auto', 'Edges', {linspace(0, 1, num_bins_y), linspace(0, 1, num_bins_x)});
    
    %Filter the spatial bins
    binCounts_light_filt=imgaussfilt(binCounts_light,0.85,'FilterSize',3);
    binCounts_Vib_filt=imgaussfilt(binCounts_Vib,0.85,'FilterSize',3);

    voxel_resp_cells_light=[voxel_resp_cells_light;binCounts_light_filt];
    voxel_resp_cells_Vib=[voxel_resp_cells_Vib;binCounts_Vib_filt];

end

%Significance analysis of individual spatial bins (voxels) across fish
%Defining the variables
voxel_signif_balanced=NaN(num_bins_x,num_bins_y);
voxel_signif_light=NaN(num_bins_x,num_bins_y);
voxel_signif_vib=NaN(num_bins_x,num_bins_y);

%Loop across each spatial bin (voxel)
for voxel_row=1:num_bins_x
        for voxel_col=1:num_bins_y
            voxel_l=[];
            voxel_v=[];
            for f=1:size(voxel_resp_cells_light,1)
                temp_light=voxel_resp_cells_light{f,1};
                temp_vib=voxel_resp_cells_Vib{f,1};

                temp_voxel_l=temp_light(voxel_row,voxel_col);
                temp_voxel_v=temp_vib(voxel_row,voxel_col);

                voxel_l=[voxel_l;temp_voxel_l];
                voxel_v=[voxel_v;temp_voxel_v];                

            end
            %Signed-rank test for each spatial bin across all fish
            p_balanced=signrank(voxel_l,voxel_v,'alpha',0.05,'tail','both');
            voxel_signif_balanced(voxel_row,voxel_col)=p_balanced;

            p_left=signrank(voxel_l,voxel_v,'alpha',0.05,'tail','left');
            voxel_signif_light(voxel_row,voxel_col)=p_left;

            p_right=signrank(voxel_l,voxel_v,'alpha',0.05,'tail','right');
            voxel_signif_vib(voxel_row,voxel_col)=p_right;

        end
end

%Making the figure
%Defining the color
orange=[0	0.500000000000000	0.500000000000000];
teal=[1	0.269531250000000	0];

%Defining the significance masks
sig_light = voxel_signif_light  < 0.05; %mask for light Excl
sig_vib = voxel_signif_vib  < 0.05; %mask for vib Excl

%Plotting the figure
f3=figure();
f3.Units="centimeters";
f3.Position=[10 15 5 8.75];
imagesc(voxel_signif_balanced);                   % base layer
colormap(bone);               % grayscale for all values
hold on

%Overlay significant cells in orange (light) / teal (vib)
[hx, hy] = find(sig_light);
plot(hy, hx, 's', 'MarkerSize', 12, ...
     'MarkerFaceColor', orange, 'MarkerEdgeColor', orange);
set(gca,'YDir','normal');
[hx, hy] = find(sig_vib);
plot(hy, hx, 's', 'MarkerSize', 12, ...
     'MarkerFaceColor', teal, 'MarkerEdgeColor', teal);
set(gca,'YDir','normal');

%Figure parameters
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
box off;
colorbar;

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');