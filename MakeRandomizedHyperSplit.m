function node = MakeRandomizedHyperSplit(cur_idx, tasks_idx)

global Features;
global Labels;
global Weights;
global L_table;
global FeatureGroups;

L_table = zeros( 33, length(Labels) );

for l =  1 : 33
    L_table(l,:) = (Labels == l)';
end
L_table = real(L_table);

num_tasks = size(tasks_idx,1);
Entr_tot = 0;
actual_tasks = 0;
for task = 1 : num_tasks
    Entr = 0;
    if(sum(cur_idx & tasks_idx(task,:)) > 0)        
        
        Entr = LabelsEntropy(cur_idx & tasks_idx(task,:));        
        actual_tasks = actual_tasks + 1;
        
    else
        Entr = 0;
    end
    
    Entr_tot = Entr_tot + Entr;    
end

node.entr = Entr_tot;
w_template = zeros(1,size(Features,1));

left_idx = cur_idx & false;
right_idx = left_idx;



while (sum(left_idx) == 0) || (sum(right_idx) == 0)
    
    F_gr = randintrlv(1:max(FeatureGroups), floor(rand * 100));
    
    f_max = max(sum(Features(FeatureGroups == F_gr(1), cur_idx).^2));

    node.f_group = F_gr(1);
    
    node.w = 2*rand(1, sum(FeatureGroups == node.f_group))-1;
    
    node.thr = rand * f_max(1);
    
    w = w_template;
    w(FeatureGroups == node.f_group) = node.w;
    
    left_idx = (Features' * w' <= node.thr)';
    right_idx = ~left_idx;
    
    left_idx = cur_idx & left_idx;
    
    right_idx = cur_idx & right_idx;
end

%F_test = randintrlv(1:size(Features,1), floor(rand * 100));

L = Labels(cur_idx);

node.L = L;
%node.entr = LabelsEntropy(cur_idx);
% node.per_task_count = sum(tasks_idx');
node.count = sum(cur_idx);
node.isleaf = false;