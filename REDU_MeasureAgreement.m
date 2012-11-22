function summary = REDU_MeasureAgreement(init_file_name, map_file_name, freq)

alpha = 1;
load(init_file_name)

alpha;

summary.tot_per_pix_aggr = zeros(1, length(alpha)) + NaN;
summary.tot_per_node_aggr = zeros(1, length(alpha)) + NaN;
summary.tot_per_pix_acc = zeros(1, length(alpha)) + NaN;
summary.tot_per_pix_acc_tr = zeros(1, length(alpha)) + NaN;
summary.tot_per_class_acc = zeros(1, length(alpha)) + NaN;
summary.tot_per_class_aggr = zeros(1, length(alpha)) + NaN;
summary.transfer_cost = zeros(1, length(alpha)) + NaN;
summary.infer_cost = zeros(1, length(alpha)) + NaN;
summary.f_score = zeros(1, length(alpha)) + NaN;
summary.agreement_entropy = zeros(1, length(alpha)) + NaN;
summary.miss = zeros(1,length(alpha)) + NaN;
summary.tot_per_class_acc_tr = zeros(1,length(alpha)) + NaN;

idx_a = zeros(1,TotalSP);
agreement_indicator = idx_a;

for i = ImIdxA
    idx_a(Index{i}.offset+1:Index{i}.offset + Index{i}.tot_sp) = 1;
end

idx_b = ~idx_a;
load Labels;
%%
for i = 1 : length(alpha)
    %disp(num2str(i));
    try
        
        load([map_file_name '_' num2str(i) '.mat']);
        %per_pix_agreement, per_node_agreement, per_pix_acc, per_class_accs
    catch
        continue;
    end
    summary.tot_per_pix_aggr(i) = results.per_pix_agreement;
    summary.tot_per_node_aggr(i) = results.per_node_agreement;
    summary.tot_per_pix_acc(i) = results.per_pix_acc;
    summary.tot_per_pix_acc_tr(i) = results.per_pix_acc_tr;
    summary.tot_per_class_acc(i) = results.per_class_acc;%KLdivergence_emp2hist(results.inferred_labels+1, freq);%entropy(results.inferred_labels);%results.per_class_acc;%
    summary.tot_per_class_aggr(i) = results.per_class_agreement;
    summary.tot_per_class_acc_tr(i) = results.per_class_acc_tr;
%    [summary.tot_ik_lz(i), trash] = calc_lz_ik(results.inferred_labels(1:2:end), results.predicted_labels(1:2:end));
    
    aggr_idx = results.inferred_labels == results.predicted_labels;
    agreement_indicator(aggr_idx) = 1;
%    summary.agreement_entropy(i) =
%    entropy(results.inferred_labels(aggr_idx));
    summary.f_score(i) = mean(results.F_score_aggr);
%    summary.transfer_cost(i) = results.TransferCost.Un + results.TransferCost.Pa;% / alpha{i}(1);
%    summary.miss(i) = results.TransferCost.Miss;% * alpha{i}(1);
%    summary.infer_cost(i) = results.InferCost.Pa + results.InferCost.Un;%results.per_pix_agreement * entropy(results.inferred_labels);% results.per_class_agreement;

end

summary.agreement_indicator = agreement_indicator;

% figure, plot(summary.tot_per_pix_aggr)
% hold on
% plot(summary.tot_per_pix_acc, 'r')
% figure, plot(summary.tot_per_class_aggr );
% hold on
% plot(summary.tot_per_class_acc, 'r');
% hold off