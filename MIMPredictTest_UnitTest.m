%MIM predict test

clear;
DoComputeAll = 1;
Files.Index = 'IndexTest';
Files.Features = 'ERHF_FeaturesTest';
Files.ILP = 'ILPTest';
Files.Labels = 'LabelsTest';
Files.predILP = 'PredILPTest';
%%
if DoComputeAll
    K = 3;
    L = 21;
    
    load('IndexTest');
    
%     features_names{3} = 'sift_hist_dial';
%     features_names{4} = 'sift_hist_left';
%     features_names{5} = 'sift_hist_right';
%     features_names{6} = 'sift_hist_top';
%     features_names{7} = 'sift_hist_bottom';
%     features_names{8} = 'sift_hist_int_';
    %features_names{1} = 'dial_color_hist';
    
    features_names{1} = 'sift_hist_int_';
    features_names{2} = 'sift_hist_dial';
    features_names{3} = 'color_hist';
    features_names{4} = 'dial_color_hist';
    features_names{5} = 'int_text_hist_mr';
    features_names{6} = 'dial_text_hist_mr';


%    features_names{3} = 'sift_hist_dial';
%     features_names{4} = 'sift_hist_left';
%     features_names{5} = 'sift_hist_right';
%     features_names{6} = 'sift_hist_top';
%     features_names{3} = 'sift_hist_bottom';
%    features_names{3} = 'sift_hist_int_';
    %features_names{1} = 'int_text_hist_mr';
    % features_names{6} = 'color_hist';
%     
%     features_names{1} = 'sift_hist_int_';
%     features_names{2} = 'color_hist';
    
    ImIdxA = train_idx;
    ImIdxB = test_idx;
    
    alpha = [-1 0.5 0.5 0.5 0.5 0.5 0.5];
    
    [labels_train, idx_train, freq] = LearnAndInfer(Files,'TrainTest_zombie', train_idx, features_names, K, L, alpha);
    
    save('MIMPredictTest_UnitTestData.mat');
else
    load('MIMPredictTest_UnitTestData.mat');
end
%%
Files.predILP = 'PredILPTest';

% load Labels

% labels_train = Labels(idx_train_b)-1;
% labels_train(labels_train < 0) = 16;

%alpha = [0.2600    0.0000    1.0000         0];
%train_idx = train_idx(1:2:end);

[labels_tst idx_tst] = MIMPredictBoost(Files, 'TrainTest_full_zombie', train_idx, features_names, labels_train, K, L, freq, alpha);

save(['ResultsTest_LF_full.mat'], 'labels_tst', 'idx_tst');