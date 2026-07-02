%% Plots the spatial position and the neural activity traces of the PG neurons for an example fish (Fig. 2B, 2C)
%This scripts plots the neural activity traces for all the neurons belonging to the same K-means cluster as a heatmap.
%This script also plots the spatial location of the PG neurons and color-codes them by their respective K-means cluster identities.
%This script needs to be run by individual section.
%The variable regionIndex=12 for PG.
%Note: The example fish used for the manuscript was fish1.

%Input:
% Data file: 202606_PGNeurons_LightTap_Data.mat
% Analysis file: 202606_PGNeurons_AnalysisKmeans.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (d_path and a_path) here:
d_path= 'C:\Users\Documents\...\2P_PGNeurons'; 
fileName_data = '202606_PGNeurons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

a_path='C:\Users\Documents\...\2P_PGNeurons'; 
fileName_analysis = '202606_PGNeurons_AnalysisKmeans.mat';
analysis_path=fullfile(a_path,fileName_analysis);
load(analysis_path);

%% Viewing the spontaneous ongoing activity of PG neurons
close all;

%Loading the example fish (for example: fish1, fish2, etc.)
fish={'fish1'};
c=1; %fish number %%remember to change %%

% Defining the colormap
cmap =[1	0.835294117647059	0.423529411764706 %for 6 colours
0.400000000000000	0.760784313725490	0.647058823529412
0.901960784313726	0.960784313725490	0.596078431372549
0.196078431372549	0.533333333333333	0.741176470588235
0.956862745098039	0.427450980392157	0.262745098039216
0.835294117647059	0.243137254901961	0.309803921568627];

% Vieweing the mean activity per cluster
n_clusters=6;
frame_rate=PGNeurons.(fish{1}).volume_rate;
region=PGNeurons.(fish{1}).regionIndex_PG; %index for brain regions

%defining the spont period
spont_onset=floor(90*frame_rate); %ommitted the first 90s
spont_offset=spont_onset+floor(480*frame_rate); %for analyzed the following 8 minutes

%organizing the data
traces_PG=PGNeurons.(fish{1}).DFFmovwindow_filt;

positions_PG=PGNeurons.(fish{1}).positions;
positions_PG=positions_PG(find(region==12),:);

%Getting the final traces for the figure
data_traces=traces_PG(:,spont_onset:spont_offset);

IDX_b_spont=KmeansIdx_spontAll{c,1};

%% Heatmap figure (clusters identities) (Fig. 2B)
% plotting the neuron activity by cluster 
clust_ind=IDX_b_spont;
data_t=data_traces; %selecting data for plotting traces

pos_subplot=nan(n_clusters,1);
for a=1:size(pos_subplot,1)
    temp=(100/n_clusters/100)-0.05;
    temp=temp*a;
    pos_subplot(a,1)=temp;
end

subplot_sizeY=0.00075; %for smaller clusters %default

%Label figure
f9=figure(); %cluster colors only
ax(3)=subplot ('position', [0.2, pos_subplot(end), 0.1,subplot_sizeY*sum(clust_ind==1)]); imagesc(clust_ind(clust_ind==1,:)), colormap (ax(3),cmap(1,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(4)=subplot ('position', [0.2, pos_subplot(5), 0.1,subplot_sizeY*sum(clust_ind==2)]); imagesc(clust_ind(clust_ind==2,:)), colormap (ax(4),cmap(2,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(5)=subplot ('position', [0.2, pos_subplot(4), 0.1,subplot_sizeY*sum(clust_ind==3)]); imagesc(clust_ind(clust_ind==3,:)), colormap (ax(5),cmap(3,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(6)=subplot ('position', [0.2, pos_subplot(3), 0.1,subplot_sizeY*sum(clust_ind==4)]); imagesc(clust_ind(clust_ind==4,:)), colormap (ax(6),cmap(4,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(7)=subplot ('position', [0.2, pos_subplot(2), 0.1,subplot_sizeY*sum(clust_ind==5)]); imagesc(clust_ind(clust_ind==5,:)), colormap (ax(7),cmap(5,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
ax(8)=subplot ('position', [0.2, pos_subplot(1), 0.1,subplot_sizeY*sum(clust_ind==6)]); imagesc(clust_ind(clust_ind==6,:)), colormap (ax(8),cmap(6,:)); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;

sgtitle('Spontaneous DF/F Labels only for each cluster');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');
%% Heatmap figure (traces) (Fig. 2B)
f10=figure(); 
subplot ('position', [0.2, pos_subplot(end), 0.5,subplot_sizeY*sum(clust_ind==1)]), imagesc(data_t(clust_ind==1,:)), caxis([-20 40]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(5), 0.5,subplot_sizeY*sum(clust_ind==2)]), imagesc(data_t(clust_ind==2,:)), caxis([-20 40]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(4), 0.5,subplot_sizeY*sum(clust_ind==3)]), imagesc(data_t(clust_ind==3,:)), caxis([-20 40]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(3), 0.5,subplot_sizeY*sum(clust_ind==4)]), imagesc(data_t(clust_ind==4,:)), caxis([-20 40]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(2), 0.5,subplot_sizeY*sum(clust_ind==5)]), imagesc(data_t(clust_ind==5,:)), caxis([-20 40]); set(gca,'XTick',[]), set(gca,'YTick',[]),box off;
subplot ('position', [0.2, pos_subplot(1), 0.5,subplot_sizeY*sum(clust_ind==6)]), imagesc(data_t(clust_ind==6,:)), caxis([-20 40]); %colorbar, set(gca,'XTick',[]), set(gca,'YTick',[]),box off;

xt = get(gca, 'XTick');
xtnew = linspace(min(xt), max(xt), 8);   % New 'XTick' Values %for spontaneous
ticks_seconds=xt/frame_rate;
xtlbl = linspace(ticks_seconds(1), ticks_seconds(end), numel(xtnew)); % New 'XTickLabel' Vector
set(gca, 'XTick',xtnew, 'XTickLabel',xtlbl) % Label Ticks
colormap (beachVibes);
sgtitle('PG neuron traces');
% colorbar;

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Plotting the spatial location (Fig. 2C)
%Dorsal view (default)
close all;
f11=figure();
scatter3(positions_PG(:,1),positions_PG(:,2),positions_PG(:,3), 45, IDX_b_spont(:), 'filled')
axis equal;
caxis ([1 n_clusters]);

%Re-orient the brain
view(-90,90); %standard 2D orientation
set(gca, 'ZDir', 'reverse')
colormap (f11(1),cmap);
grid off;
% set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
% %for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%Side-view (horizontal view)
f12=figure();
scatter3(positions_PG(:,1),positions_PG(:,2),positions_PG(:,3), 55, IDX_b_spont, 'filled')
axis equal;
caxis ([1 n_clusters]);
% %Re-orient the brain
view(-88, 10); % old side-view
set(gca, 'ZDir', 'reverse')
colormap (f12(1),cmap);
grid off;
% set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);

% %for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Making the rotating video of the recontsructed PG neurons in 3D space (movie S2)
% close all;
%Color Definition
gray=[0.8 0.8 0.8];

%Creating the orginal figure/orientation
ax5=figure();
scatter3(positions_PG(:,1),positions_PG(:,2),positions_PG(:,3), 50, IDX_b_spont, 'filled')
hold on

%Creating the 3D legend (medial-lateral and anterior-posterior axis)
%Defining the orientation of the brain
L = 1.5; %length of the arrow
arrow_width=17;
origin = [295 200 20];
dirs = [ arrow_width  0  0; -arrow_width  0  0; 0  0  arrow_width; 0  0 -arrow_width];
names = {'Anterior','Posterior','Ventral','Dorsal'};
colors = lines(6);

%Drawing the arrows
for k = 1:4 %loop over arrows/directions
    quiver3(origin(1),origin(2),origin(3), ...
            dirs(k,1)*L,dirs(k,2)*L,dirs(k,3)*L, ...
            'Color','k', 'LineWidth',1.75, 'MaxHeadSize',1.1);
end

%Label the arrow tips with a small offset to the text
offset = 0.1 * L;  %fraction of arrow length
for k = 1:4 %loop over arrows/directions
    tip = origin+dirs(k,:) * L;
    pos = tip + offset * dirs(k,:);   % move label slightly beyond tip
    text(pos(1), pos(2), pos(3), names{k}, ...
         'Color', 'k', ...
         'FontWeight','bold', ...
         'FontSize', 10, ...
         'HorizontalAlignment','center', ...
         'VerticalAlignment','middle', ...
         'Interpreter','none', ...
         'BackgroundColor','none');    % set to 'white' for boxed labels
end

%Making the Midline divider (thin grey sheet)
%Defining the coordinates of the sheet
Y = [160 160 160 160];
X = [200 320 320 200];
Z = [0 0 70 70];

%Creating the divider
patch(X, Y, Z, gray, 'FaceAlpha', 0.6, 'EdgeColor', 'none');
text(X(3), Y(1), Z(1), 'Midline', 'FontSize', 12, 'FontWeight', 'bold');
axis equal;
caxis ([1 n_clusters]);

%figure settings
view(-90,90);
set(gca, 'ZDir', 'reverse')
colormap (ax5(1),cmap);
grid off;
set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);

%Making the movie
frame(1:30)=getframe(gcf);
for az = 1:350
    view(90+az, 90+(az/4));
    set(gca, 'ZDir', 'reverse')
    drawnow;
    frame(30+az) = getframe(gcf);
end
frame_endRotation=size(frame,2);
frame(frame_endRotation:(frame_endRotation+15))=getframe(gcf); %Adding a few more frames at the end of the rotation.

%for saving as a svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');

%% Saving the movie 
myWriter = VideoWriter('movie_S2_PGNeurons_fish1_Spont','MPEG-4');  %class to write the video stufff
myWriter.Quality=95;
myWriter.FrameRate = 15;

% Open the video write, write movie and close the file
open(myWriter);
writeVideo(myWriter, frame);
close(myWriter);
