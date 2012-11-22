function tree = FillTree(cur_idx, L_weights, tree)

global Features;
global Labels;

to_open_que = zeros(1,length(tree));
to_open_que(1) = 1;

node_idx = false(length(tree), sum(cur_idx));
node_idx(1,:) = true;

leafs = false(1, length(tree));

L_table = zeros(33, sum(cur_idx));

for l =  1 : 33
    L_table(l,:) = (Labels(cur_idx) == l)' * L_weights(l);
end

que_cur = 1;
que_end = 1;

while que_cur <= que_end
    
    cur_node = to_open_que(que_cur);
    if ~tree{cur_node}.isleaf
        left_idx = (Features(tree{cur_node}.dim,cur_idx) <= tree{cur_node}.thr);
        right_idx = ~left_idx;
        
        left_idx = node_idx(cur_node,:) & left_idx;
        node_idx(tree{cur_node}.left_ch,:) = left_idx;
        
        right_idx = node_idx(cur_node,:) & right_idx;
        node_idx(tree{cur_node}.right_ch,:) = right_idx;
        
        if( sum(left_idx) > 0)
            to_open_que(que_end+1) = tree{cur_node}.left_ch;
            que_end = que_end + 1;
        end
        
        if( sum(right_idx) > 0)
            to_open_que(que_end+1) = tree{cur_node}.right_ch;
            que_end = que_end + 1;
        end
        
        %to_open_que = [to_open_que tree{cur_node}.left_ch tree{cur_node}.right_ch];
        
    else
        leafs(cur_node) = true;
    end
    
    que_cur = que_cur + 1;
    
end
%%

for i = 1:length(tree)
    if tree{i}.isleaf
        leafs(i) = true;
    end
end

tot_labels = 33;%max(Labels);
L_table = L_table';
%node_idx = real(node_idx);

BigProbs = node_idx(leafs,:) * L_table;
k = 1;
for i = find(leafs)
    if(sum(BigProbs(k,:) > 0))
        tree{i}.probs = BigProbs(k,:) / sum(BigProbs(k,:));
    else
        tree{i}.probs = zeros(1,33);
    end
    k = k + 1;
end