%% Pairwise Correlations as a function of distances for spontaneous (ongoing) periods (Subfunction for Fig. 2D)
%This script is based on the one used in Bartoszek et al., (2021): https://doi.org/10.1016/j.cub.2021.08.021 
%This script calculates the pairwise neuron-to-neuron correlations as a function of the spatial distance between them per seperate hemispheres.
%Each section of this script must be run indivudally in proper order.
%Adapted from Bartoszek et al., 2021 & Ostenrath et al., 2025
%Note: hemisphereIndex 1 =left/ipsi, 2 =right/contra

%Output: spatialCorr structure contains the PG neurons pairwise correlations seperated by hemisphere.

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)

function [spatialCorr]=Fig2_InVivo_PGNeurons_CorrelationsDistance_Spontaneous(d_path);
%% Loading the data
fileName_data = '202606_PGNeurons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

%% Finding the correlations as a function of distance between neuron pairs
% period:parameter determining the analyzed time period: 
% 1 = entire ongoing period (8 mins), 2 = spontaneous period 1  (4 mins), 3 = spontaneous period 2 (4 mins later)
%note: hemisphereIndex 1 =left/ipsi, 2 =right/contra

for period =1:3
    for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
    % for fish={'fish1'}
    
        %for normal traces
        frame_rate=PGNeurons.(fish{1}).volume_rate;
        all_traces=PGNeurons.(fish{1}).DFFmovwindow;
        all_pos=PGNeurons.(fish{1}).positions; 
        all_hemisphere=PGNeurons.(fish{1}).hemisphereIndex;
        all_index=PGNeurons.(fish{1}).regionIndex_PG;
    
    
        for region=12
            for hemisphere=1:2
                    %Creating the variables for allocating data
                    all_corr_dist = [];
                    all_corr_dist_shuf = [];
                    all_corr_dist_pos  = [];
                    all_corr_dist_neg = [];

                    %Defining the variables
                    hemi_PG=all_hemisphere(all_index==region);
                    cells = all_traces(find(hemi_PG == hemisphere),:); %for in vivo
                                        
                    pos = all_pos(find(all_hemisphere == hemisphere & all_index==region),:);
                    
                    %K-means for entire period
                    spont_onset0=floor(90*frame_rate);
                    spont_offset0=spont_onset0+floor(480*frame_rate);
    
                    %K-means period 1
                    spont_onset=floor(90*frame_rate);
                    spont_offset=spont_onset+floor(240*frame_rate);
                        
                    %K-means period 2
                    spont_onset2=spont_offset+floor(30*frame_rate);
                    spont_offset2=spont_onset2+floor(240*frame_rate);
    
        
                    %Defining the activity period
                    if period ==1 %K-means for entire period
                        cells=cells(:,spont_onset0:spont_offset0);
                    end
                    if period ==2 %K-means period 1
                        cells=cells(:,spont_onset:spont_offset);
                    end
                    if period == 3 %K-means period 2
                        cells=cells(:,spont_onset2:spont_offset2);
                    end
    
                    %getting the position matrix
                    mat_dist=NaN(size(cells,1),size(cells,1));
                     for cell_one=1:size(pos,1)
                         for cell_two=1:size(pos,1)
                             if cell_one<cell_two
                                    mat_dist(cell_one,cell_two)=sqrt((pos(cell_one,1)-pos(cell_two,1))^2 +(pos(cell_one,2)-pos(cell_two,2))^2+(pos(cell_one,3)-pos(cell_two,3))^2); % recalculate x, y and z beforehand
                             end
                         end
                     end
    
                    %Finding the correlations of the activity matrix
                    [mat_act ,p_r]= corrcoef(cells(:,:)');% obtaining the cell pair correlations
                    %Removing the paired correlations/p-values
                    mat_act=triu(mat_act,1);
                    mat_act(mat_act==0)=nan;
                    p_r=triu(p_r,1);
                    p_r(p_r==0)=nan;
    
                    %Determining the distance bins
                    steps = floor(linspace(0,120,41));
                    h=histcounts(mat_dist,steps);
    
                    %Finding the shuffled distance matrix
                    shuffled_dist=[];
                    for a=1:100 %randomize 100 times/replicates
                        temp=randperm(numel(mat_dist));
                        shuffled_dist=[shuffled_dist;temp];
                    end
                    randomLocations=floor(mean(shuffled_dist,1)); %average over the 100 replicates
    
                    dist_shuf = mat_dist(randomLocations);
                    dist_shuf = reshape(dist_shuf, size(mat_dist));
    
                    new_dist_shuf= discretize(dist_shuf,steps); %separates into bins (defined by steps)
                    new_dist = discretize(mat_dist,steps);
    
    
                    % establishing the matrices
                    mean_corr_values = nan(size(steps,2),1);
                    mean_corr_only_pos = nan(size(steps,2),1); 
                    mean_corr_only_neg = nan(size(steps,2),1); 
    
                    mean_shuf_corr_values = nan(size(steps,2),1);
                    temp=[];
                    %Finding the mean correlations based on distance
                    for bin = 1:size(steps,2)
                        mean_shuf_corr_values(bin) = nanmean(mat_act(find(new_dist_shuf == bin)));
                        mean_corr_values(bin) = nanmean(mat_act(find(new_dist == bin)));
                        %average the last bins (bins >=16)
                        if bin>=16
                            mean_shuf_corr_values(bin) = nanmean(mat_act(find(new_dist_shuf >= bin)));
                        end
                        all_pairs = mat_act(find(new_dist == bin));
                        posit_pair = [];
                        neg_pair = []; 
                        for pair = 1:length(all_pairs)
                            if all_pairs(pair) <= 0
                                neg_pair = [neg_pair; all_pairs(pair)];
                            elseif all_pairs(pair) >= 0
                                posit_pair = [posit_pair; all_pairs(pair)];
                            end
                        end
                        mean_corr_only_pos(bin) = nanmean(posit_pair);
                        mean_corr_only_neg(bin) = nanmean(neg_pair);
                     end
    
                    all_corr_dist_shuf = [all_corr_dist_shuf; mean_shuf_corr_values(2:end)'];
                    all_corr_dist = [all_corr_dist; mean_corr_values(2:end)'];
                    all_corr_dist_pos = [all_corr_dist_pos; mean_corr_only_pos(2:end)'];
                    all_corr_dist_neg = [all_corr_dist_neg; mean_corr_only_neg(2:end)'];
                    
        
                    %Saving
                    if period == 1
                        if hemisphere ==1
            
                            spatialCorr.PG.(fish{1}).leftHemi.spontAll.distShufCorr=all_corr_dist_shuf;
                            spatialCorr.PG.(fish{1}).leftHemi.spontAll.distCorr=all_corr_dist;
                            spatialCorr.PG.(fish{1}).leftHemi.spontAll.distPosCorr=all_corr_dist_pos;
                            spatialCorr.PG.(fish{1}).leftHemi.spontAll.distNegCorr=all_corr_dist_neg;
                            spatialCorr.PG.(fish{1}).leftHemi.spontAll.CorrMat=mat_act;
                            spatialCorr.PG.(fish{1}).leftHemi.spontAll.PVal_Mat=p_r;
            
            
                        else
                            spatialCorr.PG.(fish{1}).rightHemi.spontAll.distShufCorr=all_corr_dist_shuf;
                            spatialCorr.PG.(fish{1}).rightHemi.spontAll.distCorr=all_corr_dist;
                            spatialCorr.PG.(fish{1}).rightHemi.spontAll.distPosCorr=all_corr_dist_pos;
                            spatialCorr.PG.(fish{1}).rightHemi.spontAll.distNegCorr=all_corr_dist_neg;
                            spatialCorr.PG.(fish{1}).rightHemi.spontAll.CorrMat=mat_act;
                            spatialCorr.PG.(fish{1}).rightHemi.spontAll.PVal_Mat=p_r;
            
                        end
                    end
                    if period == 2
                        if hemisphere ==1
            
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.distShufCorr=all_corr_dist_shuf;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.distCorr=all_corr_dist;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.distPosCorr=all_corr_dist_pos;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.distNegCorr=all_corr_dist_neg;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.CorrMat=mat_act;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.PVal_Mat=p_r;
            
            
                        else
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.distShufCorr=all_corr_dist_shuf;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.distCorr=all_corr_dist;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.distPosCorr=all_corr_dist_pos;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.distNegCorr=all_corr_dist_neg;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.CorrMat=mat_act;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.PVal_Mat=p_r;
            
                        end
                    end
                    if period ==3
                        if hemisphere ==1
            
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.distShufCorr=all_corr_dist_shuf;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.distCorr=all_corr_dist;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.distPosCorr=all_corr_dist_pos;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.distNegCorr=all_corr_dist_neg;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.CorrMat=mat_act;
                            spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.PVal_Mat=p_r;
            
            
                        else
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.distShufCorr=all_corr_dist_shuf;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.distCorr=all_corr_dist;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.distPosCorr=all_corr_dist_pos;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.distNegCorr=all_corr_dist_neg;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.CorrMat=mat_act;
                            spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.PVal_Mat=p_r;
            
                        end
                    end
        
                
            end
        end
    end
end

%% Saving
%Note replace the location where you want to save the variables.
 fileName_save='202605_PGNeurons_SpatialCorr'; %Change the name of the file here
 save_path=fullfile(d_path,fileName_save);
 save(save_path,'spatialCorr');
end