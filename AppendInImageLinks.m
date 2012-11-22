function Graph = AppendInImageLinks(suffix, IndexFile, features_name, ImIdx, K, L)
%ImageDir = 'e:\MATLAB\im_parser\LabelMe\Images\';
%clear
DescriptorsDir = 'e:\MATLAB\im_parser\LabelMe\Data\Descriptors\SP_Desc_k200\';
GtDir = 'e:\MATLAB\im_parser\LabelMe\SemanticLabels\';

% K = 3;
% L = 21;
% suffix = 'A';
% features_name = 'sift_hist_dial';
%features_name = 'dial_color_hist';
SpAdjDir = 'sp_adjacency';

%load(['Graph_' features_name '_' num2str(K) '_' num2str(L) '_' suffix  '.mat'], 'Graph', 'K', 'L');


load(IndexFile);
Graph = sparse(TotalSP, TotalSP);
% 
%ImIdx = 1:length(Index);
% idx = zeros(1,TotalSP);
% 
% for i = ImIdx
%     idx(Index{i}.offset+1:Index{i}.offset + Index{i}.tot_sp) = 1;
% end

%Graph = sparse(TotalSP, TotalSP);

for image_i = 1: length(ImIdx) %1 : length(Index)
    
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
    
    %features = cell(size(feature_names));
    
    load( [ DescriptorsDir SpAdjDir '\' curr_name '.mat']);
    
    features = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    features = features.desc;

    
    offset = Index{image_i}.offset;
    for j = 1 : length(adjPairs)
        u = adjPairs(j,1);
        v = adjPairs(j,2);
        loc_dist = features(:,v) - features(:,u);

        simm = 0.5 * sum(((loc_dist).^2) ./ (features(:,u) + features(:,v) + eps));
        
        Graph(offset + u, offset + v) = 1-simm;
        Graph(offset + v, offset + u) = 1-simm;
    end
    
end

save(['Graph_' features_name '_' num2str(K) '_' num2str(L) '_' suffix  '.mat'], 'Graph', 'K', 'L')