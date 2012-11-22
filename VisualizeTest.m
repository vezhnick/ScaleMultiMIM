clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMe\OnlyTrain\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMe\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMe\SemanticLabels\';
TestSetDir = 'd:\MATLAB\im_parser\LabelMe\TestSet\';
GraphDir = 'd:\MATLAB\MultiMIM\GraphBaselineAverTest\';
load IndexTest
load LabelsTest
file_list = dir(ImageDir);

ResultsDir = 'MegaRFZombie';

%feature_names = cell(1);
features_name = 'super_pixels';

%load (['ResultsTest_' ResultsDir '.mat']);
load ('BaselineLabels.mat');
%%
PredLabels = zeros(size(idx_tst));
PredLabels(idx_tst) = labels_tst'+1;

cmap = colormap('lines');
%%
for image_i = test_idx
    
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
   
    Image = imread([TestSetDir curr_name '.jpg']);
           
    features = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    SP = features.superPixels;
    GT = SP * 0;
    Prediction = GT;
    cur_offset = Index{image_i}.offset;
    
        
    limit = length(Labels);
    if(image_i + 1 <= length(Index))
        limit = Index{image_i+1}.offset;
    end
    
    for node = Index{image_i}.offset+1 : limit
        idx = SP == node - cur_offset;
        GT(idx) = Labels(node);        
        Prediction(idx) = PredLabels(node);

    end
    imwrite(Image,  [GraphDir curr_name '.jpg']);
    imwrite(ind2rgb(GT, cmap), [GraphDir curr_name '_gt.png'] );
    imwrite(ind2rgb(Prediction, cmap), [GraphDir curr_name '_pred.png'] );
    
end

