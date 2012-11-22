clear;
K = 3;
L = 25;

load('IndexTest');

features_names{1} = 'sift_hist_int_';
features_names{2} = 'sift_hist_dial';
% features_names{3} = 'dial_text_hist_mr';
% features_names{4} = 'int_text_hist_mr';
% features_names{5} = 'dial_color_hist';
% features_names{6} = 'color_hist';

%
for i = 1 : length(features_names)
    i

    buff = BuildGraphs('TrainTest', 'IndexTest', train_idx, features_names{i}, K, L);    

    buff = AppendGraphs('TrainTest', 'IndexTest', 'NeibsTest', test_idx, features_names{i}, K, L);
end


%%
% for i = 1 : length(features_names)
%     i
%     Graph = AppendInImageLinks('TrainTest_neibs', 'IndexTest', features_names{i}, 1:length(Index), K, L);    
% end
