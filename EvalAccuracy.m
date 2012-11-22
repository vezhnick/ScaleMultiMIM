function [per_class_acc, per_pix_acc, per_node_acc] = EvalAccuracy(PredictedLabels, Labels, p_per_sp)
idx_tst = Labels ~= 0;
mass_norm = p_per_sp / sum(p_per_sp(idx_tst));
per_pix_acc = sum((PredictedLabels(idx_tst)+1 == Labels(idx_tst)) .* mass_norm(idx_tst));
per_node_acc = mean(PredictedLabels(idx_tst)+1 == Labels(idx_tst));

%mean((new_labels(Labels ~= 0) == Labels(Labels ~= 0)) .* p_per_sp(Labels ~= 0))
NClasses = max(Labels);
cm = zeros(NClasses,NClasses);

for i = find(idx_tst')
    if(Labels(i) ~= 0 )
        cm(PredictedLabels(i)+1, Labels(i)) = cm(PredictedLabels(i)+1, Labels(i)) + mass_norm(i);
    end
end

for i = 1 : size(cm,1)
    if( sum(cm(:,i)) > 0)
        cm(:,i) = cm(:,i) / sum(cm(:,i));
    end
end

d = diag(cm);

per_class_acc = mean(d(2:end));
