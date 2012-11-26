
per_class_miss = zeros(1,33);

for im = 1 : length(ImageToSpIdx)
    intern_idx = [ImageToSpIdx{im}.offset + 1: ImageToSpIdx{im}.offset + ImageToSpIdx{im}.tot_sp];
    sp_labels = new_labels(intern_idx)+1;
    
    labels_diff = setdiff(ImageToSpIdx{im}.labels, sp_labels);
    if ~isempty(labels_diff)
        
        labels_diff;
        per_class_miss(labels_diff) = per_class_miss(labels_diff) + 1;

        
    end
    
end
