function tree = GrowTreeFurther(tree, node_idx, to_open_que, running_id, tasks_idx, NF_tests, NThr_tests, MaxDepth)

global Features;
global Labels;


stump.isleaf = true;
stump.probs = [];  

k = 0;

while ~isempty(to_open_que)
        
    cur_node = to_open_que(1);
    D = tree{cur_node}.depth + 1;
    left_idx = (Features(tree{cur_node}.dim,:) <= tree{cur_node}.thr);
    right_idx = ~left_idx;
    
    left_idx = node_idx(cur_node,:) & left_idx;
    node_idx(running_id,:) = left_idx;
    
    right_idx = node_idx(cur_node,:) & right_idx;
    node_idx(running_id+1,:) = right_idx;
    
    if( MaxDepth > tree{cur_node}.depth && sum(node_idx(cur_node,:)) > 50)
        
        left_node = MakeRandomizedSplit(left_idx, tasks_idx, NF_tests, NThr_tests );
        if(left_node.dim == 0)
            left_node = stump;
        else
            to_open_que = [to_open_que running_id]
        end
            
        right_node = MakeRandomizedSplit(right_idx, tasks_idx, NF_tests, NThr_tests);
        
        if(right_node.dim == 0)
            right_node = stump;
        else
            to_open_que = [to_open_que running_id + 1]
        end        
    else              
        left_node = stump;        
        right_node = stump;
    end
    
    left_node.depth = tree{cur_node}.depth + 1;
    right_node.depth = tree{cur_node}.depth + 1;
    
    tree{cur_node}.left_ch = running_id;
    tree{cur_node}.right_ch = running_id+1;
    
    tree{running_id} = left_node;
    tree{running_id+1} = right_node;
    
    running_id = running_id + 2;    
    
    to_open_que = to_open_que(2:end);
    
    k = k + 1;  
    if(to_save && k > steps_to_save)
        save(backup_file_name, 'tree', 'node_idx', 'to_open_que', 'running_id', 'backup_file_name', 'steps_to_save');
        k = 0;
    end
    
end