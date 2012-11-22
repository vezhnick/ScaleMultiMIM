clear;
K = 3;
L = 21;

load('Index');

features_names{1} = 'sift_hist_int_';
features_names{2} = 'sift_hist_dial';
features_names{3} = 'dial_text_hist_mr';
features_names{4} = 'dial_color_hist';
features_names{5} = 'int_text_hist_mr';
features_names{6} = 'color_hist';

ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);

%load Neighbourhoods

%%
% for i = 1 : length(features_names)
%    GraphA = BuildGraphsNieghbour('neibh_A', 'Index', ImIdxA, PerImageNeibs, features_names{i}, K, L);
%    GraphB = BuildGraphsNieghbour('neibh_B', 'Index', ImIdxB, PerImageNeibs, features_names{i}, K, L);
%
% %     GraphA = AppendGraphs('A', 'Index','Neibs', ImIdxB,  features_names{i}, K, L)
% %     GraphB = AppendGraphs('B', 'Index','Neibs', ImIdxB,  features_names{i}, K, L)
% end

for i = 1 : length(features_names)-1
    
    GraphA = BuildGraphs('A','Index', ImIdxA, features_names{i}, K, L);    
    GraphB = BuildGraphs('B','Index', ImIdxB, features_names{i}, K, L);
    
%     GraphA = AppendGraphs('A', 'Index','Neibs', ImIdxA, features_names{i}, K, L);
%     GraphB = AppendGraphs('B', 'Index','Neibs', ImIdxA, features_names{i}, K, L);
end

%%
% for i = 1 : length(features_names)
%     i
% %    GraphA = BuildGraphs('A', ImIdxA, features_names{i}, K, L);
% %     GraphA = AppendInImageLinks('A',features_names{i}, ImIdxA, K, L);
% %     GraphB = AppendInImageLinks('B',features_names{i}, ImIdxB, K, L);
% %
%     Graph = AppendInImageLinks('neibs', 'Index', features_names{i}, [1:length(Index)], K, L);
% %    GraphB = AppendInImageLinks('B_full',features_names{i}, [1:length(Index)], K, L);
%
% end
