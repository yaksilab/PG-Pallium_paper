%% Determining the responding and reliable neurons following sensory stimulation (subfunction)
%This script examines the neural responses of individual neurons and determines whether they respond following a stimulation or not.
%This scipt also evaluates the single-cell correlations across trials (reliability of the neuron's response across trials).
%Each section of this script must be run indivudally in proper order.
%Required subfunction: 
% RespondingCells_InVivo.m
% trial_trial_correl_singleCell_inVivo.m

%Inputs: 
% Data varible202606_PGNeurons_LightTap_Data.mat
%Outputs: 
% Analysis_LightTap_Filt: Structure containing the indices for light and vibration responding cells and the single-cell across trials correlations.
 
%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
function [Analysis_LightTap_Filt]=Fig2_InVivo_PGNeurons_RespondingCells(d_path,s_path);
%% Loading the data
fileName_data = '202606_PGNeurons_LightTap_Data.mat';
data_path=fullfile(d_path,fileName_data);
load(data_path);

%% Finding the responding cells
for choice =1:2
    for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'}
        %Defining the parameters
        cond=PGNeurons.(fish{1}).stim_cond(:,choice); %Stimulus condition index

        frame_rate=PGNeurons.(fish{1}).volume_rate; %recording frame rate
        stim_onset=ceil(5*frame_rate); %stimulus onset

        %Defining the neural activity traces
        org_traces=PGNeurons.(fish{1}).TrialDFF_filt;
        traces=org_traces(:,cond,:);

        %% Finding the responding cells
        n_stim=size(traces,2); %number of stimulus presentation
        response_time=5; %baseline duration
        [positive_resp_cells,negative_resp_cells]=RespondingCells_InVivo_V2(traces,frame_rate,n_stim,response_time);

        all_resp_cells=[positive_resp_cells;negative_resp_cells];

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
        Analysis_LightTap_Filt.(fish{1}).all.light.all_cell_avg_corr=all_cell_avg_corr;
        Analysis_LightTap_Filt.(fish{1}).all.light.all_cell_pVal=all_cell_pVal;
        Analysis_LightTap_Filt.(fish{1}).all.light.positive_resp_cells=positive_resp_cells;
        Analysis_LightTap_Filt.(fish{1}).all.light.negative_resp_cells=negative_resp_cells;
        end

        if choice ==2
        Analysis_LightTap_Filt.(fish{1}).all.tap.all_cell_avg_corr=all_cell_avg_corr;
        Analysis_LightTap_Filt.(fish{1}).all.tap.all_cell_pVal=all_cell_pVal;
        Analysis_LightTap_Filt.(fish{1}).all.tap.positive_resp_cells=positive_resp_cells;
        Analysis_LightTap_Filt.(fish{1}).all.tap.negative_resp_cells=negative_resp_cells;
        end
    end
end

%% Saving
%Note replace the location where you want to save the variables.
 fileName_save='202605_PGNeurons_LightTap_Analysis'; %Change the name of the file here
 save_path=fullfile(s_path,fileName_save);
 save(save_path,'Analysis_LightTap_Filt');
end