%% Plotting the spatial distribution of neurons according to their interaction index (Fig. 6H)
%This script plots the spatial positions of all pallial neurons (in gray) 
% and the neurons classified accordingly to their interaction index as a KS density plot overlayed.
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
%% Analysis starts here - Plotting the spatial location of the cells (for all neurons)
close all;
gray=[0.8 0.8 0.8];


for choice=1:3
    figure();
    hold on;

    for hemi=1:2    
        pos_superAdd_Pal=[];
        pos_depressed_Pal=[];
        pos_subAdd_Pal=[];
        
        all_pos_hemi=[];
        
        for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
        
            id_superAdd=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.idx_superAdd;
            id_depressed=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.idx_depressed;
            id_subAdd=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.additivity.idx_subAdd;
        
            %Finding the hemisphere (optional)
            hemi_Pal=PalNeurons.(fish{1}).hemisphereIndex;
            idx_PalNew=find(hemi_Pal==hemi);
            
            %Correcting indices for hemipsheres (optional)
            idx_superAdd=id_superAdd(find(hemi_Pal(id_superAdd)==hemi));
            idx_depressed=id_depressed(find(hemi_Pal(id_depressed)==hemi));
            idx_subAdd=id_subAdd(find(hemi_Pal(id_subAdd)==hemi));
        
            %Defining the positions
            positionsPal=PalNeurons.(fish{1}).positions_norm_Pal;
            positionsPal_hemi=positionsPal(find(hemi_Pal==hemi),:); %for hemisphere
        
            %Finding the positions
            temp_posSuperAdd_Pal=positionsPal(idx_superAdd,:);
            temp_posDepressed_Pal=positionsPal(idx_depressed,:);
            temp_posSubAdd_Pal=positionsPal(idx_subAdd,:);
               
            pos_superAdd_Pal=[pos_superAdd_Pal;temp_posSuperAdd_Pal];
            pos_depressed_Pal=[pos_depressed_Pal;temp_posDepressed_Pal];
            pos_subAdd_Pal=[pos_subAdd_Pal;temp_posSubAdd_Pal];
        
            all_pos_hemi=[all_pos_hemi;positionsPal_hemi];          
        end
        
        %Plotting the positions of all pallial neurons
        scatter3(all_pos_hemi(:,1),all_pos_hemi(:,2),all_pos_hemi(:,3), 20, gray,'MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6);
                
        %Plotting the positions of the supper-additive neurons
        if choice==1
            scatter_kde(pos_superAdd_Pal(:,1),pos_superAdd_Pal(:,2), 'filled','MarkerSize',50);
        end
        %Plotting the positions of the depressed neurons
        if choice==2
            scatter_kde(pos_depressed_Pal(:,1),pos_depressed_Pal(:,2), 'filled','MarkerSize',50);
        end
        %Plotting the positions of the sub-additive neurons
        if choice==3
            scatter_kde(pos_subAdd_Pal(:,1),pos_subAdd_Pal(:,2), 'filled','MarkerSize',50);
        end
        
        %Plotting parameters
        view(360,90);
        xlim([-0.1 1.05]);
        ylim([0 1]);
        set(gca, 'ZDir', 'reverse')
        grid off;
        set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
        caxis([0 5]); 
        
        colormap jet;
                
        %for saving as svg image file
        set(gcf, 'InvertHardCopy', 'off');
        set(gcf, 'DefaultFigureRenderer', 'painters');
        set(gcf,'renderer','painters');
    
    end
end