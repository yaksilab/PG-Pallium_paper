%% Determining the responding and reliable axonal pixels following sensory stimulation (Function for Fig.3)
%This script examines the neural responses of individual neurons and determines whether they respond following a stimulation or not.
%This scipt also evaluates the single-cell correlations across trials (reliability of the neuron's response across trials).
%Each section of this script must be run indivudally in proper order.
%Required subfunction: 
% RespondingCells_InVivo.m
% trial_trial_correl_singleCell_inVivo.m

%Input:
% d_path: file path to the location of the data file.
% s_path: file path to the location of the save file.

%Outputs: 
% Analysis_LightTap_Filt: Structure containing the indices for light and vibration responding cells and the single-cell across trials correlations.
%all_pixel_avg_corr: average correlation for individual PG Axonal pixels across trials
%all_cell_pVal: p-values of the average correlation for individual pixels across trials
%positive_resp_pixels: pixel indices for positively responding (excited) pixels
%negative_resp_pixels: pixel indices for negatively responding (inhibited) pixels

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)

function [Analysis_PGAxons_Filt]=Fig3_InVivo_PGAxons_RespondingPixels(d_path,s_path);
%% Loading the data
fileName_data = '202606_PGAxons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

%% Finding the responding cells
for choice =1:2
    for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11','fish12'}
        %Defining the parameters
        cond=PGAxons.(fish{1}).stim_cond(:,choice); %Stimulus condition index

        frame_rate=PGAxons.(fish{1}).volume_rate; %recording frame rate
        stim_onset=ceil(5*frame_rate); %stimulus onset

        %Defining the neural activity traces
        org_traces=PGAxons.(fish{1}).TrialDFF_filt;
        traces=org_traces(:,cond,:);

        %% Finding the responding cells
        n_stim=size(traces,2); %number of stimulus presentation
        response_time=5; %baseline duration
        [positive_resp_pixels,negative_resp_pixels]=RespondingCells_InVivo(traces,frame_rate,n_stim,response_time);

        all_resp_pixels=[positive_resp_pixels;negative_resp_pixels];

        %% Finding the reliable cells
        %Defining the variables
        all_cell_avg_corr=[];
        all_cell_pVal=[];
        for i=1:size(traces,3) %loop over # of neurons

            [trial_corr_cell,pVal]=AT_trial_trial_correl_singleCell_inVivo(traces,frame_rate,i,n_stim,response_time);

            %finding the average correlation
            corrected_matrix =  trial_corr_cell; 
            corrected_pVal=pVal;
            for j = 1:size(trial_corr_cell,1)
                corrected_matrix(j, j:end) = nan; 
                pVal(j, j:end) = nan;
            end

            avg_corr=mean(corrected_matrix,'all','omitnan');
            all_cell_avg_corr=[all_cell_avg_corr;avg_corr];

            avg_pVal=mean(corrected_pVal,'all','omitnan');
            all_cell_pVal=[all_cell_pVal;avg_pVal];
        end

        %% For saving as a variable
        if choice ==1
        Analysis_PGAxons_Filt.(fish{1}).all.light.all_cell_avg_corr=all_cell_avg_corr;
        Analysis_PGAxons_Filt.(fish{1}).all.light.all_cell_pVal=all_cell_pVal;
        Analysis_PGAxons_Filt.(fish{1}).all.light.positive_resp_pixels=positive_resp_pixels;
        Analysis_PGAxons_Filt.(fish{1}).all.light.negative_resp_pixels=negative_resp_pixels;
        end

        if choice ==2
        Analysis_PGAxons_Filt.(fish{1}).all.tap.all_cell_avg_corr=all_cell_avg_corr;
        Analysis_PGAxons_Filt.(fish{1}).all.tap.all_cell_pVal=all_cell_pVal;
        Analysis_PGAxons_Filt.(fish{1}).all.tap.positive_resp_pixels=positive_resp_pixels;
        Analysis_PGAxons_Filt.(fish{1}).all.tap.negative_resp_pixels=negative_resp_pixels;
        end
    end
end

%% Saving
%Note replace the location where you want to save the variables.
 fileName_save='202605_PGAxons_LightTap_Analysis'; %Change the name of the file here
 save_path=fullfile(s_path,fileName_save);
 save(save_path,'Analysis_PGAxons_Filt');
end