function tree = FillTreeByLID(cur_idx, LID, L_weights, tree)


global Labels;

L_table = zeros(33, sum(cur_idx));

for l =  1 : 33
    L_table(l,:) = (Labels(cur_idx) == l)' * L_weights(l);
end
L_table = L_table';
BigProbs = LID(:,cur_idx) * L_table;
size(BigProbs)
k = 1;
for i = 1:length(tree)
    if(tree{i}.isleaf)
        if(sum(BigProbs(k,:) > 0))
            tree{i}.probs = BigProbs(k,:) / sum(BigProbs(k,:));
        else
            tree{i}.probs = zeros(1,33);
        end
        k = k + 1;
    end
end