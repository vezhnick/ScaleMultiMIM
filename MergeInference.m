function InferredLabels = MergeInference(init_file_name, map_file_name, models_in_order)

alpha = 0;

load(init_file_name)

D = ones(TotalSP,1) / TotalSP;

ConsModelIdx = sparse(TotalSP, length(alpha));

unlabelled = ones(TotalSP,1);

start = true;
%%
for i = models_in_order
    disp(num2str(i));
    try        
        load([map_file_name '_' num2str(i) '.mat']);
    catch
        continue;
    end
    
    aggr_idx = results.inferred_labels == results.predicted_labels;
    
    if start
        InferredLabels = results.inferred_labels;
    else
        InferredLabels(aggr_idx & unlabelled) = results.inferred_labels(aggr_idx & unlabelled);
    end
    
    unlabelled(aggr_idx) = 0;

    ConsModelIdx(aggr_idx, i) = 1;
    
    start = false;
    
end

