function entr = LabelsEntropy(cur_idx)

global L_table;
global Weights;
global Labels;

entr = 0;

if(isempty(Labels))
    return;
end
norm = sum(Weights(cur_idx));
if norm > 0
    p = L_table(:,cur_idx) * Weights(cur_idx) / norm;
else
    return;
end

p = p(p>0);

entr = -p(p>0)' * log(p);
