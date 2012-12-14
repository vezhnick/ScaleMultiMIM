%Learn and Infer test
addpath('../GCMex/');
clear;
K = 3;
L = 21;

Files.Index = 'Index';
Files.Features = 'ERHF_Features';%'FeaturesBig';%
Files.ILP = 'ILP';
Files.Labels = 'Labels';
Files.predILP = 'PredILP';

load('Index');

    features_names{1} = 'sift_hist_int_';
    features_names{2} = 'sift_hist_dial';
    features_names{3} = 'color_hist';
    features_names{4} = 'dial_color_hist';
    features_names{5} = 'int_text_hist_mr';
    features_names{6} = 'dial_text_hist_mr';

ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);

alpha = [ 0.9 0 0.2 0.4 0.4 0 0];

[new_labels, idx_train, freq] = LearnAndInferOneConstraing(Files, 'A_zombie', ImIdxA, features_names, K, L, alpha); %_skeleton
