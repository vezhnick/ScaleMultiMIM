%Learn and Infer test
addpath('../GCMex/');
clear;
K = 3;
L = 21;

Files.Index = 'Index';
Files.Features = 'FeaturesBig';%'ERHF_Features';
Files.ILP = 'ILP';
Files.Labels = 'Labels';
Files.predILP = 'PredILP';

load('Index');

%features_names{1} = 'color_hist';
features_names{1} = 'sift_hist_int_';
% features_names{2} = 'dial_text_hist_mr';
% features_names{3} = 'sift_hist_int_';
%features_names{1} = 'int_text_hist_mr';
% features_names{6} = 'color_hist';

ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);

alpha = [ 0.8 1];

[new_labels, idx_train, freq] = LearnAndInferOneConstraing(Files, 'A_zombie', ImIdxA, features_names, K, L, alpha); %_skeleton
