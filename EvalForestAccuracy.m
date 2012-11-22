% to be parameters
clear;

load LabelsTest

dir = './Pred/';
NClasses = 33;


Probs = zeros(length(Labels), NClasses);

for i = 1 : 200
    
    if exist( [dir 'prediction_' num2str(i) '.mat'] );
        disp(i);
        load ([dir 'prediction_' num2str(i) '.mat']);
        PredProbs(isnan(PredProbs)) = 0;
        Probs = Probs + PredProbs;
        
    end
end

[tmp PredLabels] = max(Probs');
PredLabels = PredLabels';

tst_idx = false(1, length(Labels));
tst_idx(79601 : end) = true;


mass_norm = p_per_sp / sum(p_per_sp(tst_idx' & Labels > 0));

%per_pix_acc = sum((new_labels(Labels ~= 0)+1 == Labels(Labels ~= 0)) .* mass_norm(Labels ~= 0));

sum( (Labels(tst_idx' & Labels > 0) == PredLabels(tst_idx' & Labels > 0)) .* mass_norm(tst_idx' & Labels > 0))
%%
cm = zeros(NClasses,NClasses);

for i = find(tst_idx)
    if(Labels(i) ~= 0 )%labels_tr(i) ~= 0)
        %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
        cm(PredLabels(i), Labels(i)) = cm(PredLabels(i), Labels(i)) + mass_norm(i);
    end
end

for i = 1 : size(cm,1)
    if( sum(cm(:,i)) > 0)
        cm(:,i) = cm(:,i) / sum(cm(:,i));
    end
end

%%
actualL = unique(Labels(tst_idx));
actualL = actualL(2:end);
d = diag(cm);

mean(d(actualL))