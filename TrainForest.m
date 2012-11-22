% to be parameters
clear;
% global Features;
global Labels;
global Weights;
global FeatureGroups;

load SuperPNiebs
load FeaturesBig
load Labels
load FeatureGroups

NF_tests = 10;
NThr_tests = 20;
MaxDepth = 10;
NumNeibs = 200;

num_tasks = 10;

forest = cell(0);

L_weights = zeros(1,33);
for l = 1 : length(L_weights)
L_weights(l) = sum(Labels == l);
end
L_weights = sum(L_weights) ./ L_weights;

non_zero_Labels = Labels;
non_zero_Labels(Labels == 0) = 16;

Weights = L_weights(non_zero_Labels);
Weights(Labels == 0) = 0;
Weights = Weights * sum(Labels ~= 0) / sum(Weights);
Weights = Weights';

for i = 1 : 50    
    
    tasks_idx = false(num_tasks, length(Labels));
    reject_set = [];
    for task = 1 : num_tasks
        rand_idx = randintrlv(setdiff(1 : max(SPtoImage), reject_set), i * 10);
        for n = 1 : NumNeibs            
            tasks_idx(task, SPtoImage == Neibs( rand_idx(task) ,n) ) = true;            
        end
        reject_set = union(reject_set, Neibs( rand_idx(task) ,1:NumNeibs)  );
    end
    
    curr_sample = sum(tasks_idx) > 0;
    
    forest{i} = MakeRandomizedHyperTree(tasks_idx, MaxDepth, ['backup' num2str(i)]);

%    tree_new = FillTree(Features, Labels, tree); 
    
    save(['ForestTst_progress' num2str(i) '.mat'], 'forest');
    
end

save('ForestTst.mat', 'forest');