function Graph = AppendGraphs(suffix, IndexFile, NeibFile, ImIdxA, features_name, K, L)

%ImageDir = 'e:\MATLAB\im_parser\LabelMe\Images\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMeDataSet\SemanticLabels\';
%file_list = dir(ImageDir);

%feature_names = cell(1);
%features_name = 'sift_hist_dial';
%features_name = 'dial_color_hist';
%features_name = 'dial_text_hist_mr';

load(IndexFile);
%load(['Graph_' features_name '_' num2str(K) '_' num2str(L) '_' suffix  '.mat'], 'Graph', 'K', 'L');
load(NeibFile);
% 
% ImIdx = 1:2:length(Index);
% idx = zeros(1,TotalSP);
% 
% for i = ImIdx
%     idx(Index{i}.offset+1:Index{i}.offset + Index{i}.tot_sp) = 1;
% end

Graph = sparse(TotalSP, TotalSP);

for image_i = ImIdxA %1 : length(Index)
    
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
    
    %features = cell(size(feature_names));
    
    features = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    features = features.desc;
    
    norm = sum(features);
    features = features ./ repmat(norm, size(features,1), 1);
    
    im_j_neib = zeros(size(features,2), TotalSP) + 10000;
    for image_j = PerImageNeibs(image_i,:)
        disp(['image_i = ' num2str(image_i) '; image_j = ' num2str(image_j)]);
        
        if(image_i == image_j)
            continue;
        end
        
%         if( isempty(intersect(Index{image_i}.labels, Index{image_j}.labels)) )
%             continue;
%         end
        
        j_name = Index{image_j}.name;
        
        load( [GtDir j_name '.mat']);
        
        features_j = load( [ DescriptorsDir features_name '\' j_name '.mat']);
        features_j = features_j.desc;
        
        norm = sum(features_j);
        features_j = features_j ./ repmat(norm, size(features_j,1), 1);
                
        for i = 1 : size(features,2)
            neibs = zeros(1, size(features_j,2));
            for j = 1  : size(features_j,2)
                loc_dist = features(:,i) - features_j(:,j);
%                 if(sum(loc_dist.^2) == 0)
%                     j = j;
%                 end
                neibs(j) = 0.5 * sum(((loc_dist).^2) ./ (features(:,i) + features_j(:,j) + eps));
%                 if(neibs(j) == 0 )
%                     j = j;
%                 end
            end
            
            [val idx] = sort(neibs);
            im_j_neib(i, idx(1:K) + Index{image_j}.offset) = val(1:K);
            
        end
        
    end
    for i = 1 : size(features,2)
        [val idx] = sort(im_j_neib(i,:));
        %Graph(i + Index{image_i}.offset, :) = 0;
        Graph(i + Index{image_i}.offset, idx(1:L)) = 1 - val(1:L);
    end
    
end

save(['Graph_' features_name '_' num2str(K) '_' num2str(L) '_' suffix  '_full.mat'], 'Graph', 'K', 'L')