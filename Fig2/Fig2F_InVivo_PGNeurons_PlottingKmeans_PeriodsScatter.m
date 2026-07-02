%% Analyzing the pairwise correlations between two spontaneous periods (Fig. 2F)
%This scripts plots the pairwise neuron-to-neuron correlations for 2 different spontaneous (ongoing) activity periods as a function of the 2 periods.
%This is for all PG neurons in all fish (N=11). 
%Adapted from Bartoszek et al. (2021):https://doi.org/10.1016/j.cub.2021.08.021 
%This script needs to be run by individual section.
%The period is seperated by 30s.

%Input:
% Analysis file: 202606_PGNeurons_SpatialCorr.mat.mat

%Author: Anh-Tuan Trinh
%Updated June 2026: For Trinh et al., (2026)
%% Loading the data
%Remember to manually change the data path (a_path) here:
a_path='C:\Users\Documents\...\2P_PGNeurons'; 
fileName_data = '202606_PGNeurons_SpatialCorr.mat';
data_path=fullfile(a_path,fileName_data);
load(data_path);
%% Finding the correlations
alpha = 0.05; %Significance threhsold for p-values (used to determine which Corr is included)
all_vectors={};
all_vectors_shuffled={};

for fish={'fish1','fish2','fish3','fish4','fish5','fish6','fish7','fish8','fish9','fish10','fish11'} %for LightTap
    all_pairs_Corr=[];
    all_pairs_pVal=[];
    
    temp_corr1=spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.CorrMat;
    temp_corr2=spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.CorrMat;
    temp_corr3=spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.CorrMat;
    temp_corr4=spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.CorrMat;

    temp_pVal1=spatialCorr.PG.(fish{1}).leftHemi.spontPeriod1.PVal_Mat;
    temp_pVal2=spatialCorr.PG.(fish{1}).leftHemi.spontPeriod2.PVal_Mat;
    temp_pVal3=spatialCorr.PG.(fish{1}).rightHemi.spontPeriod1.PVal_Mat;
    temp_pVal4=spatialCorr.PG.(fish{1}).rightHemi.spontPeriod2.PVal_Mat;
    
    %Finding the combined Correlation vector
    temp_corr1=temp_corr1(:);
    vectorCorr1=(temp_corr1(~isnan(temp_corr1)));
    
    temp_corr2=temp_corr2(:);
    vectorCorr2=(temp_corr2(~isnan(temp_corr2)));
    
    temp_corr3=temp_corr3(:);
    vectorCorr3=(temp_corr3(~isnan(temp_corr3)));
    
    temp_corr4=temp_corr4(:);
    vectorCorr4=(temp_corr4(~isnan(temp_corr4)));

    vectorCorr_period1=[vectorCorr1;vectorCorr3];
    vectorCorr_period2=[vectorCorr2;vectorCorr4];
    all_pairs_Corr=[vectorCorr_period1,vectorCorr_period2];

    %Finding the combined p-value vector
    temp_pVal1=temp_pVal1(:);
    vector_pVal1=(temp_pVal1(~isnan(temp_pVal1)));
    
    temp_pVal2=temp_pVal2(:);
    vector_pVal2=(temp_pVal2(~isnan(temp_pVal2)));
    
    temp_pVal3=temp_pVal3(:);
    vector_pVal3=(temp_pVal3(~isnan(temp_pVal3)));
    
    temp_pVal4=temp_pVal4(:);
    vector_pVal4=(temp_pVal4(~isnan(temp_pVal4)));

    vectorpVal_period1=[vector_pVal1;vector_pVal3];
    vectorpVal_period2=[vector_pVal2;vector_pVal4];

    all_pairs_pVal=[vectorpVal_period1,vectorpVal_period2];
    
    %Finding the significant correlations only
    significantCorr_ind=zeros(size(all_pairs_pVal,1),1);
    for a=1:size(all_pairs_pVal,1)
        temp=all_pairs_pVal(a,:)<alpha;
        if sum(temp)==2
            significantCorr_ind(a,1)=1;
        end

    end
    highCorr_ind=find(significantCorr_ind==1);
    all_pairs_SignificantCorr=all_pairs_Corr(highCorr_ind,:);
    
    %for random shuffling of the pairs
    shuffled_ind=randperm(size(all_pairs_SignificantCorr,1))';
    shuffled_ind2=randperm(size(all_pairs_SignificantCorr,1))';
    all_pairs_shuffled=[all_pairs_SignificantCorr(shuffled_ind,1),all_pairs_SignificantCorr(shuffled_ind2,2)];

    all_vectors=[all_vectors;all_pairs_SignificantCorr];
    all_vectors_shuffled=[all_vectors_shuffled;all_pairs_shuffled];

end

%% Plotting the scatter plot (overlaid with KS Density probability)
%Parameter definition
gray=[0.8 0.8 0.8];
diagonal_line=linspace(-1,1);

corr_period1=[];
corr_period2=[];

%Making the figure
f1=figure();
f1.Position=[500 200 525 600];
hold on
for b=1:size(all_vectors,1) %number of fish
    data=all_vectors{b,1};
    data_shufl=all_vectors_shuffled{b,1};
    scatter(data_shufl(:,1),data_shufl(:,2),20,gray);
    % scatter_kde(data(:,1),data(:,2),'filled','MarkerSize',20);
    corr_period1=[corr_period1;data(:,1)];
    corr_period2=[corr_period2;data(:,2)];
end
scatter_kde(corr_period1(:,1),corr_period2(:,1),'filled','MarkerSize',20);
plot(diagonal_line,diagonal_line, '--k'); %add straight line
hold off
caxis([0 5]);
colormap jet;
xlim([-1 1]);
ylim([-1 1]);
xticks(-1:0.5:1);
yticks(-1:0.5:1);
xlabel('Correlations period 1');
ylabel('Correlations period 2');
legend('Shuffled','Data');

%for saving as svg image file
set(gcf, 'InvertHardCopy', 'off');
set(gcf, 'DefaultFigureRenderer', 'painters');
set(gcf,'renderer','painters');