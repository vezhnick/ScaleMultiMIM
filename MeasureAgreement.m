function [results] =  MeasureAgreement(Files, features_names, ImIdxA, ImIdxB, K,L, alpha)
% K = 3;
% L = 21;

load('Index');
postfix = 'zombie';
%features_names{1} = 'dial_color_hist';
% features_names{1} = 'sift_hist_dial';
% features_names{2} = 'dial_text_hist_mr';
% features_names{4} = 'sift_hist_int_';
% features_names{5} = 'int_text_hist_mr';
% features_names{6} = 'color_hist';

% ImIdxA = 1:2:length(Index);
% ImIdxB = 2:2:length(Index);
% 
% suffix = 'A';
% alpha = [0 1];

[labels_train_A, idx_train_a, freqA] = LearnAndInfer(Files, ['A_' postfix], ImIdxA, features_names, K, L, alpha);
[labels_tst_B idx_tst_a] = MIMPredictBoost(Files, ['A_full_' postfix], ImIdxA, features_names, labels_train_A, K, L, freqA, alpha);


[labels_train_B, idx_train_b, freqB] = LearnAndInfer(Files, ['B_' postfix], ImIdxB, features_names, K, L, alpha);
[labels_tst_A idx_tst_b] = MIMPredictBoost(Files, ['B_full_' postfix], ImIdxB, features_names, labels_train_B, K, L, freqB, alpha);

% [TransferCostA, InferCostA] = MIMTransferCost(Files, ['A_' postfix], ImIdxA, features_names, K, L, alpha, freqA, labels_train_A, labels_tst_A);
% [TransferCostB, InferCostB] = MIMTransferCost(Files, ['B_' postfix], ImIdxB, features_names, K, L, alpha, freqB, labels_train_B, labels_tst_B);

% results.TransferCost.Un = TransferCostA.Un + TransferCostB.Un;
% results.TransferCost.Pa = TransferCostA.Pa + TransferCostB.Pa;
% results.TransferCost.Miss = TransferCostA.Miss + TransferCostB.Miss;
% 
% results.InferCost.Un = InferCostA.Un + InferCostB.Un;
% results.InferCost.Pa = InferCostA.Pa + InferCostB.Pa;

load Labels;
per_node_agreement = mean(labels_train_A == labels_tst_A) + mean(labels_train_B == labels_tst_B);
per_pix_agreement = sum(p_per_sp(idx_train_b).*(labels_train_B == labels_tst_B)) / sum(p_per_sp(idx_train_b)) + ...
    sum(p_per_sp(idx_train_a).*(labels_train_A == labels_tst_A)) / sum(p_per_sp(idx_train_a));

per_node_agreement = per_node_agreement / 2;
per_pix_agreement = per_pix_agreement / 2;

predicted_labels = Labels .* 0;

predicted_labels(idx_tst_b) =labels_tst_A;
predicted_labels(idx_tst_a) =labels_tst_B;

infered_labels = Labels .* 0;

infered_labels(idx_train_a) =labels_train_A;
infered_labels(idx_train_b) =labels_train_B;

%%
idx_tst = Labels ~= 0;
NClasses = max(Labels);
mass_norm = p_per_sp / sum(p_per_sp(idx_tst));
per_pix_acc = sum((predicted_labels(idx_tst)+1 == Labels(idx_tst)) .* mass_norm(idx_tst));
per_node_acc = mean(predicted_labels(idx_tst)+1 == Labels(idx_tst));
%%
%mean((new_labels(Labels ~= 0) == Labels(Labels ~= 0)) .* p_per_sp(Labels ~= 0))
F_score = zeros(1,NClasses);
cm = zeros(NClasses,NClasses);

for i = find(idx_tst)'
    if(Labels(i) ~= 0 )%labels_tr(i) ~= 0)
        %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
        cm(predicted_labels(i)+1, Labels(i)) = cm(predicted_labels(i)+1, Labels(i)) + mass_norm(i);
    end
end

for i = 1 : size(cm,1)
    if( (sum(cm(:,i)) + sum(cm(i,:)) - cm(i,i)) > 0)
        F_score(i) = cm(i,i) / (sum(cm(:,i)) + sum(cm(i,:)) - cm(i,i));
    end
    if( sum(cm(:,i)) > 0)
        cm(:,i) = cm(:,i) / sum(cm(:,i));
    end
end
per_class_acc = mean(diag(cm));
%%

idx_tst = Labels ~= 0;
NClasses = max(Labels);
mass_norm = p_per_sp / sum(p_per_sp(idx_tst));
per_pix_acc_tr = sum((infered_labels(idx_tst)+1 == Labels(idx_tst)) .* mass_norm(idx_tst));
per_node_acc_tr = mean(infered_labels(idx_tst)+1 == Labels(idx_tst));
%%
%mean((new_labels(Labels ~= 0) == Labels(Labels ~= 0)) .* p_per_sp(Labels ~= 0))

cm = zeros(NClasses,NClasses);

for i = find(idx_tst)'
    if(Labels(i) ~= 0 )%labels_tr(i) ~= 0)
        %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
        cm(infered_labels(i)+1, Labels(i)) = cm(infered_labels(i)+1, Labels(i)) + mass_norm(i);
    end
end

for i = 1 : size(cm,1)
    if( sum(cm(:,i)) > 0)
        cm(:,i) = cm(:,i) / sum(cm(:,i));
    end
end
per_class_acc_tr = mean(diag(cm));

%%
%mean((new_labels(Labels ~= 0) == Labels(Labels ~= 0)) .* p_per_sp(Labels ~= 0))

cm = zeros(NClasses,NClasses);
F_score_aggr = zeros(1,NClasses);

for i = find(idx_tst)'
    if(Labels(i) ~= 0 )%labels_tr(i) ~= 0) WRONG! or strange...
        %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
        cm(predicted_labels(i)+1, infered_labels(i)+1) = cm(predicted_labels(i)+1, infered_labels(i)+1) + mass_norm(i);
    end
end

for i = 1 : size(cm,1)
    if( (sum(cm(:,i)) + sum(cm(i,:)) - cm(i,i)) > 0)
        F_score_aggr(i) = cm(i,i) / (sum(cm(:,i)) + sum(cm(i,:)) - cm(i,i));
    end
    if( sum(cm(:,i)) > 0)
        cm(:,i) = cm(:,i) / sum(cm(:,i));
    end
end
per_class_agreement = mean(diag(cm));
%%
results.F_score_aggr = F_score_aggr;
results.F_score = F_score;
results.per_class_agreement = per_class_agreement;
results.per_pix_agreement = per_pix_agreement;
results.per_node_agreement = per_node_agreement;
results.per_pix_acc = per_pix_acc;
results.per_class_acc = per_class_acc;
results.per_pix_acc_tr = per_pix_acc_tr;
results.per_class_acc_tr = per_class_acc_tr;
results.inferred_labels = infered_labels;
results.predicted_labels = predicted_labels;

%fprintf('Total accuracy = %f, average = %f, per node acc = % f \n', per_pix_acc, mean(diag(cm)), per_node_acc);