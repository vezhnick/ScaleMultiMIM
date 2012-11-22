clear;
K = 3;
L = 21;

load('Index');

features_names{1} = 'sift_hist_dial';
features_names{2} = 'sift_hist_int_';
features_names{3} = 'int_text_hist_mr';
%features_names{1} = 'dial_color_hist';
% features_names{2} = 'sift_hist_dial';
% features_names{3} = 'dial_text_hist_mr';
% 
% features_names{5} = 'int_text_hist_mr';




ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);

postfix = 'skeleton';

suffix = 'A_full';

Skeleton = sparse(TotalSP, TotalSP);

for i = 1 : length(features_names)
    
    load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix  '.mat']);
    Graph = max(Graph, Graph');
    Skeleton = Skeleton + (Graph > 0);
%     load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' 'neibs'  '.mat']);
%     Gr_tot = Gr_tot + alpha(i + 1) * Graph;
end

Skeleton = Skeleton > 0;

for i = 1 :length(features_names)
%     load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix  '.mat']);
%     Skeleton = Graph > 0;
    disp([features_names{i} ' _ ' suffix]);
    GraphA = BuildGraphsOnSkeleton(suffix, postfix, 'Index.mat', Skeleton, features_names{i}, K, L);
end

suffix = 'B_full';

Skeleton = sparse(TotalSP, TotalSP);

for i = 1 : length(features_names)
    load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix  '.mat']);
    Graph = max(Graph, Graph');
    Skeleton = Skeleton + Graph > 0;
%     load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' 'neibs'  '.mat']);
%     Gr_tot = Gr_tot + alpha(i + 1) * Graph;
end

Skeleton = Skeleton > 0;

for i = 1 :length(features_names)
       
%     load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix  '.mat']);
%     Skeleton = Graph > 0;
    disp([features_names{i} ' _ ' suffix]);
    GraphB = BuildGraphsOnSkeleton(suffix, postfix, 'Index.mat', Skeleton, features_names{i}, K, L);
end