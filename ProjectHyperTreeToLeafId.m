function LeafId = ProjectHyperTreeToLeafId(tree)

global Features;
global Labels;
global FeatureGroups;

to_open_que = zeros(1,length(tree));
to_open_que(1) = 1;

node_idx = false(length(tree), length(Labels));
node_idx(1,:) = true;

leafs = false(1, length(tree));

que_cur = 1;
que_end = 1;

left_idx = false(1,length(Labels));
right_idx = left_idx;

w_template = zeros(1,size(Features,1));

while que_cur <= que_end
    que_cur
    cur_node = to_open_que(que_cur);
    if ~tree{cur_node}.isleaf
        
        w = w_template;
        w(FeatureGroups == tree{cur_node}.f_group) = tree{cur_node}.w;
        
        left_idx = (Features' * w' <= tree{cur_node}.thr)';
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

LeafId = sparse(node_idx(leafs,:));