function node = MakeRandomizedSplit(cur_idx, tasks_idx, NF_tests, NThr_tests)

global Features;
global Labels;
global Weights;
global L_table

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

if(Entr_tot == 0)
    node.dim = 0;
    node.thr = 0;
    return
end

F_test = randintrlv(1:size(Features,1), floor(rand * 100));

MinEntr = 10000000;
min_dt = [0 0];

L = Labels(cur_idx);

for d =  1 : NF_tests
    F = Features(F_test(d),cur_idx);
    
    
    AllF = sort(F);
    Halves = unique((AllF(2:end) + AllF(1:end-1))/2);
    Thr_test = Halves(randintrlv(1:length(Halves), floor(rand * 100)));
    
    for t = 1 : min(length(Thr_test), NThr_tests)
        Entr_tot = 0;
        left_idx = F <= Thr_test(t);
        right_idx = ~left_idx;
        
        %evaluate per task entropy reduction
        actual_tasks = 0;
        for task = 1 : num_tasks
            if(sum(cur_idx & tasks_idx(task,:)) > 0)
                
                left_idx_t = left_idx & tasks_idx(task,cur_idx);
                right_idx_t = right_idx & tasks_idx(task,cur_idx);
                left_entropy = LabelsEntropy(left_idx_t);
                right_entropy = LabelsEntropy(right_idx_t);
                
                Entr = sum(Weights(left_idx_t)) * left_entropy + sum(Weights(right_idx_t)) * right_entropy;
                
                Entr = Entr / sum(Weights(cur_idx & tasks_idx(task,:)));
                actual_tasks = actual_tasks + 1;
                
            else
                Entr = 0;
            end
            Entr_tot = Entr_tot + Entr;
        end
        %Entr
        
        if Entr_tot / actual_tasks < MinEntr
            MinEntr = Entr;
            min_dt = [F_test(d) Thr_test(t)];
        end
        
    end
end

node.dim = min_dt(1);
node.thr = min_dt(2);
node.L = L;
%node.entr = LabelsEntropy(cur_idx);
node.per_task_count = sum(tasks_idx');
node.count = sum(cur_idx);
node.isleaf = false;