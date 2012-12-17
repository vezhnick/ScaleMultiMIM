
%L_c = sparse([1 : sum(idx)], new_labels, ones(1,sum(idx)), sum(idx), 33);

Gr_c = Gr_tot;

for l = 1:33
    sp_l = new_labels == l;
    Gr_c(sp_l,sp_l) = 0;
end


%label_agreement = (L_c*L_c') > 0;

lin_idx = sub2ind(size(log_Pot), [1:size(log_Pot,1)], new_labels');

E_c = alpha_opt * log_Pot(lin_idx) - 1.05 * Ksi(lin_idx)+ (1 - alpha_opt) * sum(Gr_c);

%fixed_labels = [1:33] < k;

missed = 0;
for im = 1 : length(ImageToSpIdx)
    intern_idx = [ImageToSpIdx{im}.offset + 1: ImageToSpIdx{im}.offset + ImageToSpIdx{im}.tot_sp];
    sp_labels = new_labels(intern_idx);
    
    labels_diff = setdiff(ImageToSpIdx{im}.labels, sp_labels);
    
    if ~isempty(labels_diff)
        missed = missed+1;
    end
    
    for l = labels_diff'
        
        E_l = alpha_opt * log_Pot(intern_idx,l)' + (1 - alpha_opt) * sum(Gr_tot(intern_idx, new_labels ~= l)');
        
        E_d = E_l - E_c(intern_idx);
        [val min_id] = min(E_d);
        Ksi(intern_idx, l) = val;
        new_labels(ImageToSpIdx{im}.offset + min_id) = l;
        
    end
   
end

disp(['images with bad constraint' num2str(missed)]);