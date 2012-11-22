%MIM predict test
addpath('../GCMex/');
clear;
DoComputeAll = 1;
ResultsDir = 'Hist_tmp';
close all

%%
if DoComputeAll
    K = 3;
    L = 21;
    Files.Index = 'Index';
    Files.Features = 'FeaturesHist';
    Files.ILP = 'ILP';
    Files.Labels = 'Labels';
    Files.predILP = 'PredILP';
    
    features_names{1} = 'sift_hist_int_';
    features_names{2} = 'sift_hist_dial';
    features_names{3} = 'color_hist';
    features_names{4} = 'dial_color_hist';
    features_names{5} = 'int_text_hist_mr';
    features_names{6} = 'dial_text_hist_mr';

    load (Files.Index);
    
    ImIdxA = 1:2:length(Index);
    ImIdxB = 2:2:length(Index);
    
    alpha = [0.8 0 0.8 0 0 0.1 0.1 ]

    %results = REDU_MeasureAgreement(['.\Results\' ResultsDir '\init_file_2f.mat'], ['.\Results\' ResultsDir '\output'], ones(1,33))
    results =  MeasureAgreement(Files, features_names, ImIdxA, ImIdxB, K,L, alpha)
    %load (['.\Results\' ResultsDir '\init_file_2f.mat']);
        
    labels_train = results.inferred_labels;
    freq = results.F_score * 0;
    for i = 1 : length(freq)
        freq(i) = 1 + sum(labels_train == i + 1);
    end
    %%
    load IndexTest
    idx_train = zeros(1, Index{end}.offset + Index{end}.tot_sp);
    idx_train(1: length(labels_train)) = 1;
    idx_train = idx_train == 1;
    %%
    save('MIMPredictTest3_UnitTestData.mat');
else
    load('MIMPredictTest3_UnitTestData.mat');
end
%%
Files.Index = 'IndexTest';
Files.Features = 'FeaturesHistTest';
Files.ILP = 'ILPTest';
Files.Labels = 'LabelsTest';
Files.predILP = 'PredILPTest';

% load Labels

% labels_train = Labels(idx_train_b)-1;
% labels_train(labels_train < 0) = 16;

%alpha = [0.2600    0.0000    1.0000         0];
%train_idx = train_idx(1:2:end);

[labels_tst idx_tst] = MIMPredictBoost(Files, 'TrainTest_full_zombie', train_idx, features_names, labels_train, K, L, freq, alpha);

save(['ResultsTest_' ResultsDir '.mat'], 'labels_tst', 'idx_tst');