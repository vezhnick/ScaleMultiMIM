clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Images\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMeDataSet\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMe\SemanticLabels\';
TestSetDir = 'd:\MATLAB\im_parser\LabelMe\TestSet\';
OutputDir = 'd:\MATLAB\im_parser_new\LabelMe\SemanticLabels\spatial_envelope_256x256_static_8outdoorcategories\'

load IndexTest
load LabelsTest
file_list = dir(ImageDir);

ResultsDir = 'ERHF';

%feature_names = cell(1);
features_name = 'super_pixels';

load (['ResultsTest_' ResultsDir '.mat']);
%load ('BaselineLabels.mat');
%%
PredLabels = zeros(size(idx_tst));
PredLabels(idx_tst) = labels_tst'+1;
PredLabels(~idx_tst) = labels_train+1;

%%
tot_pp = 0;
tot_p = 0;
cm = zeros(33,33);
for image_i = train_idx;%test_idx
    %image_i
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
   
    Image = imread([ImageDir curr_name '.jpg']);
           
    features = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    SP = features.superPixels;
    GT = double(S);
    Prediction = GT;
    cur_offset = Index{image_i}.offset;
    
        
    limit = length(Labels);
    if(image_i + 1 <= length(Index))
        limit = Index{image_i+1}.offset;
    end
    
    for node = Index{image_i}.offset+1 : limit
        idx = SP == node - cur_offset;
   
        Prediction(idx) = PredLabels(node);
    end
        
    S =  Prediction;
        save([OutputDir curr_name '.mat'], 'S', 'names');

end


    

