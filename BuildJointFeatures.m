clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Images\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMeDataSet\SemanticLabels\';
file_list = dir(ImageDir);

suffix = '';

%feature_names = cell(1);
features_names{1} = 'dial_color_hist';
features_names{2} = 'color_hist';
features_names{3} = 'sift_hist_dial';
features_names{4} = 'sift_hist_left';
features_names{5} = 'sift_hist_right';
features_names{6} = 'sift_hist_top';
features_names{7} = 'sift_hist_bottom';
features_names{8} = 'sift_hist_int_';
features_names{9} = 'dial_text_hist_mr';
features_names{10} = 'int_text_hist_mr';
features_names{11} = 'left_text_hist_mr';
features_names{12} = 'right_text_hist_mr';
features_names{13} = 'top_text_hist_mr';
features_names{14} = 'bottom_text_hist_mr';
% features_names{15} = 'absolute_mask';
% features_names{16} = 'bottom_height';
% features_names{17} = 'top_height';
% features_names{18} = 'bb_extent';
% features_names{19} = 'pixel_area';
% features_names{20} = 'color_thumb_mask';
% features_names{21} = 'gist_int';
% features_names{22} = 'color_std';
% features_names{23} = 'color_thumb';
% features_names{24} = 'mean_color';
% features_names{25} = 'centered_mask';
% features_names{26} = 'centered_mask_sp';
% 

load(['Index' suffix]);

Graph = sparse(TotalSP, TotalSP);

Features = [];

FeatureGroups = [];


for image_i = 1 : length(Index)
    image_i
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
    
    features = cell(size(features_names));
    cur_F_size = 0;
    for i = 1 : length(features)
        features{i} = load( [ DescriptorsDir features_names{i} '\' curr_name '.mat']);
        features{i} = features{i}.desc;
        FeatureGroups(cur_F_size + 1 : cur_F_size + size(features{i},1)) = i;
        cur_F_size = cur_F_size + size(features{i},1);
          disp(features_names{i});
          size(features{i})
    end
    
    UnPotSmall = features{1};
    for i = 2:length(features)
        UnPotSmall = cat(1,UnPotSmall, features{i});
    end
    if(isempty(Features))
        Features = sparse(size(UnPotSmall,1), TotalSP);
    end
    Features(:,Index{image_i}.offset + 1 : Index{image_i}.offset + size(UnPotSmall,2)) = UnPotSmall;
end
%Features = cat(1, Features, ones(1, size(Features, 2)));
save(['Features' suffix 'Big.mat'], 'Features');
%save(['FeatureGroups' suffix '.mat'], 'FeatureGroups');