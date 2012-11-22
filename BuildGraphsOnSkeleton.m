function Graph = BuildGraphsOnSkeleton(suffix, postfix, IndexFile, Skeleton, features_name, K, L)
%ImageDir = 'e:\MATLAB\im_parser\LabelMe\Images\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMeDataSet\SemanticLabels\';
%file_list = dir(ImageDir);

%feature_names = cell(1);
%features_name = 'sift_hist_dial';
%features_name = 'dial_color_hist';
%features_name = 'dial_text_hist_mr';

load(IndexFile);

%
% ImIdx = 1:2:length(Index);
% idx = zeros(1,TotalSP);
%
% for i = ImIdx
%     idx(Index{i}.offset+1:Index{i}.offset + Index{i}.tot_sp) = 1;
% end

Features = [];


for image_i = 1 : length(Index)
    
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
    
    features = cell(size(features_name));
    
    features = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    features = features.desc;
    
    UnPotSmall = features;
    
    if(isempty(Features))
        Features = zeros(size(UnPotSmall,1), TotalSP);
    end
    
    Features(:,Index{image_i}.offset + 1 : Index{image_i}.offset + size(UnPotSmall,2)) = UnPotSmall;
end


Graph = sparse(TotalSP, TotalSP);
[row col] = find(Skeleton);

for k = 1 : length(row)
    %disp(num2str(k / length(row)));
    i = row(k);
    j = col(k);
    
    features_i = Features(:, i) / sum(Features(:, i));
    
    
    features_j = Features(:, j) / sum(Features(:, j));
    
    loc_dist = features_i - features_j;
    
    Graph(i,j) = 1 - 0.5 * sum(((loc_dist).^2) ./ (features_i + features_j + eps));
    %distances(j,i) = Graph(i,j);
end

% for i = 1 : TotalSP
%     disp(num2str(i / TotalSP));
%     j_idx = row(col == i);
% %    j_idx = j_idx(j_idx > i);
%     distances = zeros(1, TotalSP);
%     for j = j_idx
%         features_i = Features(:, i) / sum(Features(:, i));
%
%
%         features_j = Features(:, j) / sum(Features(:, j));
%
%         loc_dist = features_i - features_j;
%
%         distances(j) = 1 - 0.5 * sum(((loc_dist).^2) ./ (features_i + features_j + eps));
%         %distances(j,i) = Graph(i,j);
%
%     end
%
%     Graph(i,:) = distances;
% end

save(['Graph_' features_name '_' num2str(K) '_' num2str(L) '_' suffix  '_' postfix '.mat'], 'Graph', 'K', 'L')