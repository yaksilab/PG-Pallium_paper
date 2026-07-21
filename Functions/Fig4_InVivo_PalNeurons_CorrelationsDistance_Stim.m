%% Pairwise Correlations as a function of distances for sensory stimulation periods using the Pallial neuronal activity (Function for Fig. 4)
%This script is based on the one used in Bartoszek et al., (2021): https://doi.org/10.1016/j.cub.2021.08.021 
%This script calculates the pairwise Pallial neuron-to-neuron correlations as a function of the spatial distance between them per seperate hemispheres.
%Each section of this script must be run indivudally in proper order.
%Output: spatialCorr structure contains the Pallial neurons' pairwise correlations seperated by hemisphere.
%Adapted from Bartoszek et al., 2021 & Ostenrath et al., 2025
%Note: hemisphereIndex 1 =left/ipsi, 2 =right/contra

%Input: 
% d_path: folder path for data
% s_path: folder path for saved correlations (output)

%Output: spatialCorr structure contains the PG neurons pairwise correlations seperated by hemisphere.
%distShufCorr: Correlations for each distance bin (using the shuffled distances).
%distCorr: Correlations for each distance bin.
%distPosCorr: Correlations for each distance bin (positive correlations only)
%distNegCorr: Correlations for each distance bin (negative correlations only)
%CorrMat: Neuron pair correlation matrix
%Corr_PVal: Neuron pair correlation p-values

%Author: Anh-Tuan Trinh
%Updated July 2026: For Trinh et al., (2026)
function [spatialCorr]=Fig4_InVivo_PalNeurons_CorrelationsDistance_Stim(d_path,s_path);
%% Loading the data
fileName_data = '202606_PalNeurons_LightTapBoth_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

%Loading the previous CorrelationVsDistance analysis file
fileName_spatialCorr = '202606_PalNeurons_SpatialCorr.mat';
data_path=fullfile(d_path,fileName_spatialCorr);
load(data_path);
%% Finding the correlations as a function of distance between neuron pairs
% condition:parameter determining the analyzed time period: 
% 1 = light stimulation period, 2 = vibration stimulation period, 3= simultaneous light+vibration stimulation period
%note: hemisphereIndex 1 =left/ipsi, 2 =right/contra

for condition =1:3
    for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10'}
        %for normal traces
        frame_rate=PalNeurons.(fish{1}).volume_rate;
        all_traces=PalNeurons.(fish{1}).DFFmovwindow_filt;
        all_pos=PalNeurons.(fish{1}).positions; 
        idx_hemi_Pal=PalNeurons.(fish{1}).hemisphereIndex;
        stim_onset=PalNeurons.(fish{1}).stim_onset;
        stim_cond=PalNeurons.(fish{1}).stim_cond;
    
        for hemisphere=1:2
                all_corr_dist = [];
                all_corr_dist_shuf = [];
                all_corr_dist_pos  = [];
                all_corr_dist_neg = [];
      
                neurons = all_traces(idx_hemi_Pal,:); %for in vivo
                pos = all_pos(idx_hemi_Pal,:);
                
                %stim_period for light
                light_period=[];
                light_cond=stim_cond(:,1);
                for x=light_cond(1):light_cond(end)
                    temp=stim_onset(x)-floor(1*frame_rate):stim_onset(x)+floor(55*frame_rate);
                    light_period=[light_period,temp];
                end
    
                %stim_period for vib
                vib_period=[];
                vib_cond=stim_cond(:,2);
                for x=vib_cond(1):vib_cond(end)
                    temp=stim_onset(x)-floor(1*frame_rate):stim_onset(x)+floor(55*frame_rate);
                    vib_period=[vib_period,temp];
                end

                %stim_period for combined light + vib
                lightVib_period=[];
                lightVib_cond=stim_cond(:,3);
                for x=lightVib_cond(1):lightVib_cond(end)
                    temp=stim_onset(x)-floor(1*frame_rate):stim_onset(x)+floor(55*frame_rate);
                    lightVib_period=[lightVib_period,temp];
                end
    
                %Defining the activity period
                if condition ==1 %%for light stim data
                    neurons=neurons(:,light_period);
                end
                if condition ==2 %for tap stim data
                    neurons=neurons(:,vib_period);
                end

                if condition ==3 %for tap stim data
                    neurons=neurons(:,lightVib_period);
                end

                %getting the position matrix
                mat_dist=NaN(size(neurons,1),size(neurons,1));
                 for neuron_one=1:size(pos,1)
                     for neuron_two=1:size(pos,1)
                         if neuron_one<neuron_two
                                mat_dist(neuron_one,neuron_two)=sqrt((pos(neuron_one,1)-pos(neuron_two,1))^2 +(pos(neuron_one,2)-pos(neuron_two,2))^2+(pos(neuron_one,3)-pos(neuron_two,3))^2); % recalculate x, y and z beforehand
                         end
                     end
                 end

                % getting the activity matrix
                [mat_act ,p_r]= corrcoef(neurons(:,:)');% obtaining the cell pair correlations
                %Removing the paired correlations/p-values
                mat_act=triu(mat_act,1);
                mat_act(mat_act==0)=nan;
                p_r=triu(p_r,1);
                p_r(p_r==0)=nan;

                %Determining the distance bins
                steps = floor(linspace(0,200,51));
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
                    %average the last bins (bins >=21)
                    if bin>=21
                        mean_shuf_corr_values(bin) = nanmean(mat_act(find(new_dist_shuf >= 21)));
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
                if condition == 1
                    if hemisphere ==1
        
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.distShufCorr=all_corr_dist_shuf;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.distCorr=all_corr_dist;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.distPosCorr=all_corr_dist_pos;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.distNegCorr=all_corr_dist_neg;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.CorrMat=mat_act;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.LStim.PVal_Mat=p_r;
        
        
                    else
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.distShufCorr=all_corr_dist_shuf;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.distCorr=all_corr_dist;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.distPosCorr=all_corr_dist_pos;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.distNegCorr=all_corr_dist_neg;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.CorrMat=mat_act;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.LStim.PVal_Mat=p_r;
        
                    end
                end
                if condition == 2
                    if hemisphere ==1
        
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.distShufCorr=all_corr_dist_shuf;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.distCorr=all_corr_dist;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.distPosCorr=all_corr_dist_pos;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.distNegCorr=all_corr_dist_neg;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.CorrMat=mat_act;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.TStim.PVal_Mat=p_r;
        
        
                    else
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.distShufCorr=all_corr_dist_shuf;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.distCorr=all_corr_dist;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.distPosCorr=all_corr_dist_pos;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.distNegCorr=all_corr_dist_neg;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.CorrMat=mat_act;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.TStim.PVal_Mat=p_r;
        
                    end
                end

                if condition == 3
                    if hemisphere ==1
        
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.Both.distShufCorr=all_corr_dist_shuf;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.Both.distCorr=all_corr_dist;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.Both.distPosCorr=all_corr_dist_pos;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.Both.distNegCorr=all_corr_dist_neg;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.Both.CorrMat=mat_act;
                        spatialCorr.PalNeurons.(fish{1}).leftHemi.Both.PVal_Mat=p_r;
        
        
                    else
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.Both.distShufCorr=all_corr_dist_shuf;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.Both.distCorr=all_corr_dist;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.Both.distPosCorr=all_corr_dist_pos;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.Both.distNegCorr=all_corr_dist_neg;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.Both.CorrMat=mat_act;
                        spatialCorr.PalNeurons.(fish{1}).rightHemi.Both.PVal_Mat=p_r;
        
                    end
                end
                                
        end
  
    end
end

%% Saving
%Note replace the location where you want to save the variables.
 fileName_save='202605_PalNeurons_SpatialCorr'; %Change the name of the file here
 save_path=fullfile(s_path,fileName_save);
 save(save_path,'spatialCorr');
end