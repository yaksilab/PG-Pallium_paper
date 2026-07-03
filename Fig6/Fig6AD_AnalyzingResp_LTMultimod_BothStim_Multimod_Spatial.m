%% Plotting the spatial distribution of pallial neurons according to their excitatory response selectivity (Fig. 6A-D)
%This script plots the spatial positions of all pallial neurons (in gray) 
% and the neurons classified accordingly to their response selectivity as an overlayed KS Density plot.
%The response selectivity of these pallial neurons were obtained using the script: InVivo_PalNeurons_LightTapBoth_Additivity.m

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
%% Plotting the spatial location of the pallial cells according to their response selectivity
close all;

%Regrouping the position data for each cell type: 1: light Excl, 2: vib Excl, 3: multi-sensory, 4:integrative
for cellType=1:4 %loop across different cell types
    figure();
    hold on;

    for hemi=1:2 %loop across hemisphere
        %Variables for saving the positions
        pos_PosResp_multiSens_Pal=[];
        pos_PosResp_lightExcl_Pal=[];
        pos_PosResp_tapExcl_Pal=[];
        pos_PosResp_integrative_Pal=[];
        all_cells_Pal=[];
        
        for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'} 
        
            %combined stim indices
            PosResp_multiSens_id=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.bothStim.idx_pos_multiSens;
            PosResp_lightExcl_id=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.bothStim.idx_pos_lightExcl;
            PosResp_tapExcl_id= Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.bothStim.idx_pos_tapExcl;
            PosResp_integrative_id=Analysis_PalliumMultiModal_Filt.(fish{1}).Pallium.bothStim.idx_pos_integrative;
        
            %Finding the hemisphere (optional)
            region=PalNeurons.(fish{1}).regionIndex;
            hemi_Pal=PalNeurons.(fish{1}).hemisphereIndex;
            
            %Correcting indices for each hemipshere
            PosResp_multiSens_idx=PosResp_multiSens_id(find(hemi_Pal(PosResp_multiSens_id)==hemi));
            PosResp_lightExcl_idx=PosResp_lightExcl_id(find(hemi_Pal(PosResp_lightExcl_id)==hemi));
            PosResp_tapExcl_idx=PosResp_tapExcl_id(find(hemi_Pal(PosResp_tapExcl_id)==hemi));
            PosResp_integrative_idx=PosResp_integrative_id(find(hemi_Pal(PosResp_integrative_id)==hemi));
        
            %Finding the positions
            positionsPal=PalNeurons.(fish{1}).positions_norm_Pal;
        
            positionsPal_hemi=positionsPal(find(hemi_Pal==hemi),:); %for hemisphere
            
            temp_PosResp_multiSens_pos=positionsPal(PosResp_multiSens_idx,:);
            temp_PosResp_lightExcl_pos=positionsPal(PosResp_lightExcl_idx,:);
            temp_PosResp_tapExcl_pos=positionsPal(PosResp_tapExcl_idx,:);
            temp_PosResp_integrative_pos=positionsPal(PosResp_integrative_idx,:);
        
            all_cells_Pal=[all_cells_Pal;positionsPal_hemi]; %for hemipshere
              
            %Pallium
            pos_PosResp_multiSens_Pal=[pos_PosResp_multiSens_Pal;temp_PosResp_multiSens_pos];
            pos_PosResp_lightExcl_Pal=[pos_PosResp_lightExcl_Pal;temp_PosResp_lightExcl_pos];
            pos_PosResp_tapExcl_Pal=[pos_PosResp_tapExcl_Pal;temp_PosResp_tapExcl_pos];
            pos_PosResp_integrative_Pal=[pos_PosResp_integrative_Pal;temp_PosResp_integrative_pos];
        
        end
                
        %% Plotting the spatial location of the cells (KSDensity plots)
        gray=[0.8 0.8 0.8];
        %ploting the pallial neurons (other responses)
        scatter(all_cells_Pal(:,1),all_cells_Pal(:,2),20,gray,'MarkerFaceAlpha',.6,'MarkerEdgeAlpha',.6);
        
        %for light Excl
        if cellType==1
            scatter_kde(pos_PosResp_lightExcl_Pal(:,1),pos_PosResp_lightExcl_Pal(:,2),'filled','MarkerSize',50);
            caxis([0 7]); %for sensory exlusive
        end
        
        %for vib Excl
        if cellType==2
            scatter_kde(pos_PosResp_tapExcl_Pal(:,1),pos_PosResp_tapExcl_Pal(:,2),'filled','MarkerSize',50);
            caxis([0 7]); %for sensory exlusive
        end
        %for multi-sensory
        if cellType==3
            scatter_kde(pos_PosResp_multiSens_Pal(:,1),pos_PosResp_multiSens_Pal(:,2),'filled','MarkerSize',50);
            caxis([0 10]); %for multisensory
        end
        %for integrative
        if cellType==4
            scatter_kde(pos_PosResp_integrative_Pal(:,1),pos_PosResp_integrative_Pal(:,2),'filled','MarkerSize',50);
            caxis([0 5]); %for integrative
        end
        %Figure parameters      
        view(360,90);
        set(gca, 'ZDir', 'reverse')
        xlim([-0.1 1.05]);
        ylim([0 1]);
        colormap (jet);
        set(gca,'xtick',[],'ytick',[],'ztick',[],'xcolor',[1 1 1],'ycolor',[1 1 1],'zcolor',[1 1 1]);
        
        %for saving as a .svg image file
        set(gcf, 'InvertHardCopy', 'off');
        set(gcf, 'DefaultFigureRenderer', 'painters');
        set(gcf,'renderer','painters');
    
    end
end