%% Classifying the Pallial neurons following the delivery of a sensory stimulation in vivo (Subfunction)
%This script classifies whether a neuron is "responding" to a sensory stimulation or not.
%Neurons are categorzied as either positively responding (excited) or negatively responding (inhibited) by a stimuli across trials.
%Note a second time window was used to better capture the delayed inhibition.
%Adapted from Ostenrath et al., (2025):  https://doi.org/10.1038/s41467-025-62115-z
%More information on the classification can by found in the Methods of Trinh et al., (2026), https://doi.org/10.1126/science.aec2171

%Input:
%traces: neural data organized as time x trial x neurons %%IMPORTANT that the data is organized this way
%frame_rate: acquisition rate of the recording (in frames).
%n_stim: number of stimulation trials.
%resp_time:the duration of the period (after the stimulus) used to classify whether a cell is responding or not when compared to the baseline (in seconds).

%Output:
%positive_resp_cells: indices of the positively responding (excited) neurons
%negative_resp_cells: indices of the negataively responding (inhibited) neurons

%Author: Anh-Tuan Trinh
%Updated July 2026: For Trinh et al., (2026)
%%
function [positive_resp_cells,negative_resp_cells]=RespondingCells_InVivo_Pallium(traces,frame_rate,n_stim,resp_time)

%Defining the parameters
positive_resp_cells=[];
negative_resp_cells=[];

%Baseline duration
baseline_dur = ceil(5 * frame_rate); %5 seconds was used a baseline period.
%Defining the baseline and response period (in frames)
baseline_period=[1:baseline_dur-2];
resp_period = [baseline_dur+1:baseline_dur+1+floor(resp_time * frame_rate)]; 
resp_period_neg = [baseline_dur+floor((resp_time-1) * frame_rate):baseline_dur-1+floor((resp_time+4) * frame_rate)]; %Should be 5 seconds total

%Defining the data
m_traces_test=squeeze(mean(traces(:,1:n_stim,:),2)); %averaging the data across trials
baseline_vector=m_traces_test(baseline_period,:);
resp_vector = m_traces_test(resp_period,:);
resp_vector2=m_traces_test(resp_period_neg,:); %for the second time window

%Creasting the list of positively and negatively responding neurons
pos_list=zeros([size(m_traces_test,2),1]);
neg_list=zeros([size(m_traces_test,2),1]);

for cell=1:size(m_traces_test,2)%loop over the # of neurons
        %Calculate the mean response for before (pre) and after (post) the stimulation.
        pre=mean(baseline_vector(:,cell));
        pre_std = std(baseline_vector(:,cell),0,1);
        post=mean(resp_vector(:,cell));
        post2=mean(resp_vector2(:,cell)); %for the second time window
        
        %Classifying the neurons as positively or negatively responding
        %For the positively responding neurons
        if post > pre+(2.5*pre_std)
           if post > pre
               pos_list(cell) = 1; 
           elseif post < pre
               neg_list(cell) = 1; 
           end
        %For the negatively responding cells 
        elseif abs(post2) > abs(pre)+(1.5*pre_std)
            if post2 < pre
               neg_list(cell) = 1; 
           end
        end
    
end
%Grouping the data into the lists
positive_resp_cells=find(pos_list==1);
negative_resp_cells=find(neg_list==1);

end

