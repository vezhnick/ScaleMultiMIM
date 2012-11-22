function [L_out, P_out, i_out, fixed_out] = BoostLI(init_file_name, map_file_name, L, P, fixed)


if nargin >3
    alpha = 0;
    L_tmp = L;
    load(init_file_name)
    L = L_tmp;
else
    load(init_file_name)
end

D = ones(TotalSP,1) / TotalSP;

if nargin < 3
    L = sparse(TotalSP,33);
    P = sparse(TotalSP,33);
    fixed = false(TotalSP,1);
end


max_acc = 0;

%%
for i = 1 : length(alpha)
    %disp(num2str(i));
    try
        load([map_file_name '_' num2str(i) '.mat']);
    catch
        continue;
    end
    
    aggr_idx = results.inferred_labels == results.predicted_labels;
    
    L_c = sparse([1 : TotalSP], results.inferred_labels+1, ones(1,TotalSP), TotalSP, 33);
    P_c = sparse([1 : TotalSP], results.predicted_labels+1, ones(1,TotalSP), TotalSP, 33);
    if ( sum(fixed) > 0)
        L_c(fixed | ~aggr_idx,:) = L(fixed | ~aggr_idx,:);
        P_c(fixed | ~aggr_idx,:) = P(fixed | ~aggr_idx,:);
    end
        
    cm = L_c'*P_c;
    %cm = cm';
    numrows = size(cm,1);
    cm = spdiags (sum (cm,2), 0, numrows, numrows) \ cm ;
    
    if(max_acc < mean(diag(cm)))
        max_acc = mean(diag(cm))
        L_out = L_c;
        P_out = P_c;
        i_out = i;
        fixed_out = fixed | aggr_idx;
    end
    
end


