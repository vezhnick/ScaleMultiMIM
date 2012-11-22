
L_c = sparse([1 : sum(idx)], new_labels, ones(1,sum(idx)), sum(idx), 33);
label_agreement = (L_c*L_c') > 0;

lin_idx = sub2ind(size(log_Pot), [1:size(log_Pot,1)], new_labels');

E_c = alpha_opt * log_Pot(lin_idx)' + (1 - alpha_opt) * sum(Gr_tot(~label_agreement));

for im = 1 : length(ImageToSpIdx)
    intern_idx = [ImageToSpIdx{im}.offset + 1: ImageToSpIdx{im}.offset + 1 + ImageToSpIdx{im}.tot_sp];
    sp_labels = new_labels(intern_idx);
    
    labels_diff = setdiff(ImageToSpIdx{im}.labels, sp_labels);
    if ~isempty(labels_diff)
        
        for l = labels_diff'
           
            E_l = log_Pot(intern_idx,l)' + sum(Gr_tot(intern_idx, new_labels ~= l)');
            
            
        end
        
    end
    
end