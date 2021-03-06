function summary = REDU_MeasureAgreementPatrick(init_file_name, map_file_name, freq)

alpha = 1;
load(init_file_name)

%constructing inverted index;

InvIndex = zeros(1,TotalSP);

for im = 1 : length(Index)
    InvIndex( Index{im}.offset + 1 : Index{im}.offset + Index{im}.tot_sp) = im;
end


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
summary.patrick_base = zeros(1,length(alpha)) + NaN;

%%
for i = 1 : length(alpha)
    disp(num2str(i));
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
    
    aggr_idx = ~results.inferred_labels == results.predicted_labels;
    
    summary.f_score(i) = mean(results.F_score_aggr);
    summary.patrick_base(i) = 0;
    
    for sp = 1 : TotalSP
        if ismember(results.inferred_labels(sp), Index{InvIndex(sp)}.labels)
            summary.patrick_base(i) = summary.patrick_base(i) + 1;
        end
    end
    
    summary.patrick_base(i) = summary.patrick_base(i) / TotalSP;
    
end

% figure, plot(summary.tot_per_pix_aggr)
% hold on
% plot(summary.tot_per_pix_acc, 'r')
% figure, plot(summary.tot_per_class_aggr );
% hold on
% plot(summary.tot_per_class_acc, 'r');
% hold off