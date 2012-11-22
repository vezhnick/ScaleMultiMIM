clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Images\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMeDataSet\SemanticLabels\';
file_list = dir(ImageDir);
suffix = 'Test';
%feature_names = cell(1);
features_name = 'super_pixels';

load(['Index' suffix]);

LabelsFrac = [];
Labels = zeros(TotalSP, 1);
p_per_sp = Labels;

for image_i = 1 : length(Index)
    
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
    
    %features = cell(size(feature_names));
    
    SpMap = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    SpMap = SpMap.superPixels;
    
    if isempty(LabelsFrac)
        LabelsFrac = zeros(TotalSP, length(names));
    end
    
    
    
    for i = 1 : max(SpMap(:))
        A = S(SpMap == i);
        n = histc(A, [0.5:1:33.5]);
    
        LabelsFrac(Index{image_i}.offset + i, :) = n(1:end-1) / sum(n);
        if(max(n) == 0)
            Labels(Index{image_i}.offset + i) = 0;
        else
            true_l = find(n == max(n));
            Labels(Index{image_i}.offset + i) = true_l(1);
        end
        p_per_sp(Index{image_i}.offset + i) = length(A);
    end
    
end

save(['Labels' suffix '.mat'],'Labels', 'LabelsFrac', 'p_per_sp');