clear;

ImageDir = '..\im_parser\LabelMe\Images\';
DescriptorsDir = '..\im_parser\LabelMe\Data\Descriptors\Global\';
GtDir = '..\im_parser\LabelMe\SemanticLabels\';
file_list = dir(ImageDir);

feature_names = cell(1);
load('Index');

ImIdx = 1:2:length(Index);

descriptor_names{1} = 'coHist';
% descriptor_names{2} = 'SpatialPyr';
descriptor_names{2} = 'tinyIm';
descriptor_names{3} = 'pyramid_200_3';
descriptor_names{4} = 'Gist';

Neibs = zeros(length(Index));

Graph = sparse(TotalSP, TotalSP);

ILP = [];


for image_i = 1 : length(Index)
    
    curr_name = Index{image_i}.name;
    
    for i = 1 : length(descriptor_names)-1
        Index{image_i}.(descriptor_names{i}) = (load([DescriptorsDir descriptor_names{i} '\' curr_name '_' descriptor_names{i} '.mat']));
    end
    i = 4;
    Index{image_i}.(descriptor_names{i}) = load([DescriptorsDir descriptor_names{i} '\' curr_name '_' descriptor_names{i} '.txt']);
    
    Index{image_i}.coHist = Index{image_i}.coHist.coHist';
    Index{image_i}.tinyIm = double(Index{image_i}.tinyIm.tinyIm(:));
    Index{image_i}.(descriptor_names{3}) = double(Index{image_i}.(descriptor_names{3}).pyramid)';
    
end
%%

load('ILP.mat');
predILP = zeros(size(ILP));

TotalLabels = size(ILP,2);

K = 5;
mult = 1;
neibs = zeros(length(Index), K);
for image_i = 1 : length(Index)
    disp(num2str(image_i));
    dist = zeros(length(descriptor_names),length(Index)) -1;
    
    for image_j = 1 : length(Index)
        
        for i = 1 : length(descriptor_names)
            loc_dist = Index{image_i}.(descriptor_names{i}) - Index{image_j}.(descriptor_names{i});
            dist(i, image_j) = norm(loc_dist);
        end
    end
    ranks = zeros(size(dist));
    for i = 1 : size(ranks,1)
        [tmp ranks(i,:)] = sort(dist(i,:));
    end
    
    im_rank = zeros(1, length(ranks));
    for n = 1 : max(ranks(:))
        [r c] = find(ranks == n);
        im_rank(n) = min(c);
    end
    
    im_c = 1;
    for r = unique(im_rank)
        cur_ims = find(im_rank == r);
        Neibs(image_i, im_c : im_c + length(cur_ims)-1) = cur_ims';
        im_c = im_c + length(cur_ims);
    end
    
end
%%
SPtoImage = zeros(TotalSP, 1);

for i = 1 : size(Index,2)
    SPtoImage(Index{i}.offset+1 : Index{i}.offset + Index{i}.tot_sp, :) = i;
end


save('SuperPNiebs.mat', 'Neibs', 'SPtoImage');