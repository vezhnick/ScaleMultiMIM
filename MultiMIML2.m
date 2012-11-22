clear;
K = 3;
L = 21;

load('Index');

features_names{1} = 'gist_int';

ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);

suffix = 'A';
alpha = [0 0 1 1 0 0];

load Neighbourhoods

%%
for i = 1 : length(features_names)
%    GraphA = BuildGraphsL2('A', 'Index', ImIdxA, features_names{i}, K, L);
%    GraphB = BuildGraphsL2('B', 'Index', ImIdxB, features_names{i}, K, L);
            
    GraphA = AppendGraphsL2('A', 'Index','Neibs', ImIdxB,  features_names{i}, K, L)
    GraphB = AppendGraphsL2('B', 'Index','Neibs', ImIdxB,  features_names{i}, K, L)
end

% for i = 1 : length(features_names)
%    GraphA = BuildGraphs('A', ImIdxA, features_names{i}, K, L);
%    GraphB = BuildGraphs('B', ImIdxB, features_names{i}, K, L);
%             
% %     GraphA = AppendGraphs('A', 'Index','Neibs', ImIdxA, features_names{i}, K, L)
% %     GraphB = AppendGraphs('B', 'Index','Neibs', ImIdxA, features_names{i}, K, L)
% end

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
