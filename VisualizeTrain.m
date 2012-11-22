clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMe\OnlyTrain\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMe\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMe\SemanticLabels\';
TestSetDir = 'd:\MATLAB\im_parser\LabelMe\TestSet\';
GraphDir = 'd:\MATLAB\MultiMIM\GraphBestTrain\';
load IndexTest
load Labels
file_list = dir(ImageDir);

ResultsDir = 'MegaRFZombie'

%feature_names = cell(1);
features_name = 'super_pixels';

load (['ResultsTest_' ResultsDir '.mat']);

PredLabels = zeros(size(idx_tst));
PredLabels(idx_tst) = labels_tst+1;

cmap = colormap('lines');


results = REDU_MeasureAgreement(['.\Results\' ResultsDir '\init_file_2f.mat'], ['.\Results\' ResultsDir '\output'], ones(1,33))
load (['.\Results\' ResultsDir '\init_file_2f.mat']);

load('IndexTest');


[max_val max_idx] = max(results.tot_per_class_aggr);
load(['.\Results\' ResultsDir '\output_' num2str(max_idx) '.mat']);
labels_train_inf = results.inferred_labels;
labels_train_pred = results.predicted_labels;
%%
for image_i = train_idx
    
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
   
    Image = imread([ImageDir curr_name '.jpg']);
           
    features = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    SP = features.superPixels;
    GT = SP * 0;
    Inferrence = GT;
    Prediction = GT;
    cur_offset = Index{image_i}.offset;
    
        
    limit = length(Labels);
    if(image_i + 1 <= length(Index))
        limit = Index{image_i+1}.offset;
    end
    
    for node = Index{image_i}.offset+1 : limit
        idx = SP == node - cur_offset;
        GT(idx) = Labels(node);        
        Prediction(idx) = labels_train_pred(node)+1;
        Inferrence(idx) = labels_train_inf(node)+1;

    end
    imwrite(Image,  [GraphDir curr_name '.jpg']);
    imwrite(ind2rgb(GT, cmap), [GraphDir curr_name '_gt.png'] );
    imwrite(ind2rgb(Inferrence, cmap), [GraphDir curr_name '_infer.png'] );
    imwrite(ind2rgb(Prediction, cmap), [GraphDir curr_name '_pred.png'] );
    
end

