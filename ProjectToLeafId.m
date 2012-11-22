function LeafId = ProjectToLeafId(tree)

global Features;
global Labels;

to_open_que = zeros(1,length(tree));
to_open_que(1) = 1;

node_idx = false(length(tree), length(Labels));
node_idx(1,:) = true;

leafs = false(1, length(tree));

que_cur = 1;
que_end = 1;

left_idx = false(1,length(Labels));
right_idx = left_idx;

while que_cur <= que_end
    que_cur
    cur_node = to_open_que(que_cur);
    if ~tree{cur_node}.isleaf
        left_idx = false & left_idx;
        right_idx = false & right_idx;
        left_idx(node_idx(cur_node,:)) = (Features(tree{cur_node}.dim,node_idx(cur_node,:)) <= tree{cur_node}.thr);
        right_idx(node_idx(cur_node,:)) = ~left_idx(node_idx(cur_node,:));
        
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

LeafId = node_idx(leafs,:);