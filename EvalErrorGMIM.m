clear;
ImageDir = 'd:\MATLAB\im_parser\LabelMe\OnlyTrain\';
DescriptorsDir = 'd:\MATLAB\im_parser\LabelMe\Data\Descriptors\SP_Desc_k200\';
GtDir = 'd:\MATLAB\im_parser\LabelMe\SemanticLabels\';
TestSetDir = 'd:\MATLAB\im_parser\LabelMe\TestSet\';
load IndexTest
load LabelsTest
file_list = dir(ImageDir);

ResultsDir = 'Supervised';

%feature_names = cell(1);
features_name = 'super_pixels';

load (['ResultsTest_' ResultsDir '.mat']);
%load ('BaselineLabels.mat');
%%
PredLabels = zeros(size(idx_tst));
PredLabels(idx_tst) = labels_tst'+1;

rand('seed',10)
%Labels(Labels == 0) = 34;
%cmap = generate_colours(33);
%cmap(34,:) = 0;
%%
tot_pp = 0;
tot_p = 0;
cm = zeros(33,33);
for image_i = test_idx
    %image_i
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
   
    Image = imread([TestSetDir curr_name '.jpg']);
           
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
        GT(idx) = Labels(node);        
        Prediction(idx) = PredLabels(node);
    end
        
    GT = double(S(:));
    Prediction = Prediction(:);

    
    for i = find(GT ~= 0)'        
        cm(Prediction(i), GT(i)) = cm(Prediction(i), GT(i)) + 1;
    end
    
    
    tot_pp = tot_pp + sum(Prediction(GT ~= 0) ~= GT(GT ~= 0));
    tot_p = tot_p + sum(GT ~= 0);

end

    for i = 1 : size(cm,1)
        if( sum(cm(:,i)) > 0)
            cm(:,i) = cm(:,i) / sum(cm(:,i));
        end
    end
    
    mean(diag(cm))
    1 - tot_pp / tot_p
    
    save(['CM_' ResultsDir, '.mat'], 'cm', 'tot_p', 'tot_pp');