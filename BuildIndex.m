
file_list = dir(ImageDir);

%feature_names = cell(1);
features_name = 'super_pixels';

Index = cell(1, length(file_list)-2);

TotalSP = 0;

for image_i = 3 : 1 : length(file_list)
    
    curr_name = file_list(image_i).name(1:end-4);
    
    load( [GtDir curr_name '.mat']);
    im_labels = unique(S(:));
    im_labels = im_labels(2:end);
    
    %features = cell(size(feature_names));
            
    features = load( [ DescriptorsDir features_name '\' curr_name '.mat']);
    SP = features.superPixels;
    Index{image_i-2}.name = curr_name;
    Index{image_i-2}.offset = TotalSP;
    Index{image_i-2}.labels = im_labels;
    Index{image_i-2}.tot_sp = max(SP(:));
    TotalSP = TotalSP + max(SP(:));
    
end

save('Index.mat', 'Index', 'TotalSP');