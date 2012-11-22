%MIM predict test
addpath('../GCMex/');
clear;
DoComputeAll = 1;
if DoComputeAll
    K = 3;
    L = 21;
    
    Files.Index = 'Index';
    Files.Features = 'Features';%'HNRF_Features';
    Files.ILP = 'ILP';
    Files.Labels = 'Labels';
    Files.predILP = 'PredILP';
    
    load('Index');
    
%     features_names{3} = 'sift_hist_dial';
%     features_names{4} = 'sift_hist_left';
%     features_names{5} = 'sift_hist_right';
%     features_names{6} = 'sift_hist_top';
%     features_names{7} = 'sift_hist_bottom';
%     features_names{8} = 'sift_hist_int_';
    %features_names{1} = 'dial_color_hist';
%    features_names{1} = 'gist_int';

features_names{1} = 'sift_hist_int_';
features_names{2} = 'sift_hist_dial';
% features_names{3} = 'color_hist';
% features_names{4} = 'dial_color_hist';
% features_names{5} = 'int_text_hist_mr';
% features_names{6} = 'dial_text_hist_mr';


%    features_names{3} = 'sift_hist_dial';
%     features_names{4} = 'sift_hist_left';
%     features_names{5} = 'sift_hist_right';
%     features_names{6} = 'sift_hist_top';
%     features_names{3} = 'sift_hist_bottom';
%    features_names{3} = 'sift_hist_int_';
    %features_names{1} = 'int_text_hist_mr';
    % features_names{6} = 'color_hist';
    
    ImIdxA = 1:2:length(Index);
    ImIdxB = 2:2:length(Index);
    
    alpha = [ 0.8 0.5 0.5];%0.9 0.1 ];
    
    [labels_train, idx_train_b, freq] = LearnAndInfer(Files, 'A_zombie', ImIdxA, features_names, K, L, alpha);
    save('MIMPredict_UnitTestData.mat');
else
    load('MIMPredict_UnitTestData.mat');
end
%%

load Labels
% 
% labels_train = Labels(idx_train_b)-1;
% labels_train(labels_train < 0) = 16;

%alpha = [ 0.24 .5 .5 0 ];

[labels_tst idx_tst_b] = MIMPredictBoost(Files, 'A_full_zombie', ImIdxA, features_names, labels_train, K, L, freq, alpha);
