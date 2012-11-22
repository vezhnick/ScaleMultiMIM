function tree = MakeRandomizedHyperTree(tasks_idx, MaxDepth, backup_file_name)

global Features;
global Labels;
global Weights;
global FeatureGroups;

start_time = clock;
start_time = start_time(end-1) + 60*start_time(end-2) + 24 * 60 * start_time(end-3);

to_save = false;
if(nargin >= 3)
    to_save = true;
end

if( to_save && exist(backup_file_name))
    load(backup_file_name);
else
    to_open_que = 1;

    tree = cell(0);

    running_id = 2;

    node_idx = false(2000, length(Labels));
    if(size(tasks_idx,1) > 1)
        node_idx(1,:) = sum(tasks_idx) > 0;
    else
        node_idx(1,:) = tasks_idx;
    end

    tree{1} = MakeRandomizedHyperSplit(node_idx(1,:), tasks_idx);

    tree{1}.depth = 0;
end

stump.isleaf = true;
stump.probs = [];  

k = 0;

w_template = zeros(1,size(Features,1));

while ~isempty(to_open_que)
        
    cur_node = to_open_que(1);
    D = tree{cur_node}.depth + 1;
    
    w = w_template;
    w(FeatureGroups == tree{cur_node}.f_group) = tree{cur_node}.w;
    
    left_idx = (Features' * w' <= tree{cur_node}.thr)';
    right_idx = ~left_idx;
    
    left_idx = node_idx(cur_node,:) & left_idx;
    node_idx(running_id,:) = left_idx;
    
    right_idx = node_idx(cur_node,:) & right_idx;
    node_idx(running_id+1,:) = right_idx;
    
    per_task_mass = zeros(1,size(tasks_idx,1));
    
    for t = 1 : size(tasks_idx,1)
        per_task_mass(t) = sum(node_idx(cur_node,:) & tasks_idx(t,:));
    end
    
    if( MaxDepth > tree{cur_node}.depth && max(per_task_mass) > 20)%sum(node_idx(cur_node,:)) > 20)
                
        if(sum(left_idx) <= 20)
            left_node = stump;
            left_node.count = sum(left_idx);
        else
            left_node = MakeRandomizedHyperSplit(left_idx, tasks_idx );
            to_open_que = [to_open_que running_id];
        end                  
        
        if(sum(right_idx) <= 20)
            right_node = stump;
            right_node.count = sum(right_idx);
        else
            right_node = MakeRandomizedHyperSplit(right_idx, tasks_idx);
            to_open_que = [to_open_que running_id + 1];
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
    disp(['tree length = ' num2str(length(tree)) ' nodes count = ' num2str(max(per_task_mass))]);
    k = k + 1;
    time_now = clock;
    time_now = time_now(end-1) + 60*time_now(end-2) + 24 * 60 * time_now(end-3);
    time_diff= time_now - start_time;
    if(to_save && time_diff > 50)
        save(backup_file_name, 'tree', 'node_idx', 'to_open_que', 'running_id', 'backup_file_name');
        k = 0;
        a = I_want_to_make_error;
    end
end