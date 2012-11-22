function probs = TreePredict(Features, Labels, tree)


to_open_que = 1;

node_idx = false(length(tree), length(Labels));
node_idx(1,:) = true;

leafs = false(1, length(tree));


while ~isempty(to_open_que)
    
    cur_node = to_open_que(1);
    if ~tree{cur_node}.isleaf
        left_idx = (Features(tree{cur_node}.dim,:) <= tree{cur_node}.thr);
        right_idx = ~left_idx;

        left_idx = node_idx(cur_node,:) & left_idx;
        node_idx(tree{cur_node}.left_ch,:) = left_idx;

        right_idx = node_idx(cur_node,:) & right_idx;
        node_idx(tree{cur_node}.right_ch,:) = right_idx;
        
        if( sum(left_idx) > 0)
            to_open_que = [to_open_que tree{cur_node}.left_ch];
        end
        
        if( sum(right_idx) > 0)
            to_open_que = [ to_open_que tree{cur_node}.right_ch];
        end
        
    else
        leafs(cur_node) = true;
    end
    
    to_open_que = to_open_que(2:end);
    
end
%%
tot_labels = max(Labels);
probs = zeros(length(Labels),33);

for i = find(leafs)
    
    probs(node_idx(i,:),:) = repmat(tree{i}.probs, sum(node_idx(i,:)), 1);
    
end