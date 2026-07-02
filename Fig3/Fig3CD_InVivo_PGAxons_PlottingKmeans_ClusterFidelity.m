%% Plots the spatial position and the neural activity traces of the pallial PG axons for an example fish (Fig. 3C, 3D)
%This scripts plots the neural activity traces for all the axonal pixels belonging to the same K-means cluster as a heatmap.
%This script also plots the spatial location of the PG axons and color-codes them by their respective K-means cluster identities.
%This script needs to be run by individual section.
%NOTE: the example fish used in the manuscript was fish #8.

%Input:
% Data file: 202606_PGAxons_LightTap_Data.mat
% Analysis file: 202606_PGAxons_AnalysisKmeans.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path= 'C:\Users\Documents\...\2P_PGAxons'; 
fileName_data = '202606_PGAxons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_PGAxons';
fileName_analysis = '202606_PGAxons_AnalysisKmeans.mat';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);

%% Viewing the spontaneous ongoing activity of PG axons
close all;

%Loading the example fish (for example: fish1, fish2, etc.)
fish={'fish8'};
c=8; %fish number %%remember to change %%

map_sixcolors =[0.835294117647059	0.243137254901961	0.309803921568627 %for 6 colours
0.196078431372549	0.533333333333333	0.741176470588235
0.901960784313726	0.960784313725490	0.596078431372549
0.400000000000000	0.760784313725490	0.647058823529412
1	0.835294117647059	0.423529411764706
0.956862745098039	0.427450980392157	0.262745098039216];

% Vieweing the mean activity per cluster
n_clusters=6;
frame_rate=PGAxons.(fish{1}).volume_rate;

%defining the spont period
spont_onset=floor(90*frame_rate); %ommitted the first 90s
spont_offset=spont_onset+floor(480*frame_rate); %for analyzed the following 8 minutes

%organizing the data
traces_PGAxons=PGAxons.(fish{1}).DFFmovwindow_filt;

positions_Axons=PGAxons.(fish{1}).bin_positions_org;

%Getting the final traces for the figure
data_traces=traces_PGAxons(:,spont_onset:spont_offset);

IDX_b_spont=KmeansIdx_spontAll{c,1};

%% Heatmap figure (clusters identities and traces) (Fig. 3C)
% plotting the axonal activity by cluster 
clust_ind=IDX_b_spont;
data_t=data_traces; %selecting data for plotting traces

pos_subplot=nan(n_clusters,1);
for a=1:size(pos_subplot,1)
    temp=(100/n_clusters/100)-0.05;
    temp=temp*a;
    pos_subplot(a,1)=temp;
end

subplot_sizeY=0.000095; %for smaller clusters %default

%Label figure
f9=figure(); %cluster colors only
ax(3)=subplot ('position', [0.2, pos_subplot(end), 0.1,subplot_sizeY*sum(clust_ind==1)]); imagesc(clust_ind(clust_ind==1,:)), colormap (ax(3),map_sixcolors(1,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(4)=subplot ('position', [0.2, pos_subplot(5), 0.1,subplot_sizeY*sum(clust_ind==2)]); imagesc(clust_ind(clust_ind==2,:)), colormap (ax(4),map_sixcolors(2,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(5)=subplot ('position', [0.2, pos_subplot(4), 0.1,subplot_sizeY*sum(clust_ind==3)]); imagesc(clust_ind(clust_ind==3,:)), colormap (ax(5),map_sixcolors(3,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(6)=subplot ('position', [0.2, pos_subplot(3), 0.1,subplot_sizeY*sum(clust_ind==4)]); imagesc(clust_ind(clust_ind==4,:)), colormap (ax(6),map_sixcolors(4,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(7)=subplot ('position', [0.2, pos_subplot(2), 0.1,subplot_sizeY*sum(clust_ind==5)]); imagesc(clust_ind(clust_ind==5,:)), colormap (ax(7),map_sixcolors(5,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(8)=subplot ('position', [0.2, pos_subplot(1), 0.1,subplot_sizeY*sum(clust_ind==6)]); imagesc(clust_ind(clust_ind==6,:)), colormap (ax(8),map_sixcolors(6,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;

sgtitle('Spontaneous DF/F Labels only for each cluster');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

f10=figure(); 
subplot ('position', [0.2, pos_subplot(end), 0.5,subplot_sizeY*sum(clust_ind==1)]), imagesc(data_t(clust_ind==1,:)), caxis([-30 60]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(5), 0.5,subplot_sizeY*sum(clust_ind==2)]), imagesc(data_t(clust_ind==2,:)), caxis([-30 60]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(4), 0.5,subplot_sizeY*sum(clust_ind==3)]), imagesc(data_t(clust_ind==3,:)), caxis([-30 60]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(3), 0.5,subplot_sizeY*sum(clust_ind==4)]), imagesc(data_t(clust_ind==4,:)), caxis([-30 60]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(2), 0.5,subplot_sizeY*sum(clust_ind==5)]), imagesc(data_t(clust_ind==5,:)), caxis([-30 60]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(1), 0.5,subplot_sizeY*sum(clust_ind==6)]), imagesc(data_t(clust_ind==6,:)), caxis([-30 60]); %colorbar, set(gca,'XTick',[]), set(gca,'YTick',[]),box off;

xt = get(gca, 'XTick');
xtnew = linspace(min(xt), max(xt), 8);   % New 'XTick' Values %for spontaneous
ticks_seconds=xt/frame_rate;
xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks
colormap (beachVibes_Axons);
sgtitle('PG axonal traces');
% colorbar;

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Plotting the spatial location (Fig. 3D)
%Dorsal view (default)
ax3=figure();
scatter3(positions_Axons(:,1),positions_Axons(:,2),positions_Axons(:,3), 35, IDX_b_spont, 'filled')
axis equal;
caxis ([1 n_clusters]);
%Re-orient the brain
view(-90,90); %standard 2D orientation
set(gca, 'ZDir', 'reverse')
colormap (ax3(1),map_sixcolors);
grid off;
% set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);

% %for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
