function MapReduce_TrainForest()
clear;
global Features;
global Labels;

load TasksAndNeibs 
load FeaturesBig
load Labels
load FeatureGroups

NF_tests = 1;
NThr_tests = 1;
MaxDepth = 100;
NeibsNum = 200;

num_tasks = 5;
seed_images = zeros(10, num_tasks);

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

jobs_string = '''';

for i = 1 : 100    
    
    if(exist( ['./Inits/init_forest' num2str(i) '.mat'] ) == 0);
        tasks_idx = false(num_tasks, length(Labels));
        reject_set = [];
        for task = 1 : num_tasks
            rand_idx = randintrlv(setdiff(1 : max(SPtoImage), reject_set), i * 10);
            for n = 1 : NeibsNum            
                tasks_idx(task, (SPtoImage == Neibs( rand_idx(task) ,n)) ) = true;            
            end
            tasks_idx(task,:) = (Labels ~= 0)' & tasks_idx(task,:);
            reject_set = union(reject_set, Neibs( rand_idx(task) ,1:NeibsNum)  );
        end

        curr_sample = sum(tasks_idx) > 0;

        save(['./Inits/init_forest' num2str(i) '.mat'], 'tasks_idx', 'NF_tests', 'NThr_tests', 'MaxDepth', 'Weights', 'FeatureGroups');
    end
    
    if(exist( ['./Trees/tree_' num2str(i) '.mat'] ) == 0);
        jobs_string = [jobs_string ' ended("job' num2str(i) '") &&'];
        disp(['train ' num2str(i)]);
        system(['bsub -J ' 'job' num2str(i) ' -oo "./Output/%J.out"  -R "rusage[mem=5110]" -W 01:00 ./MAPMakeRandomizedHyperTree ./Inits/init_forest' num2str(i) ' ./Trees/tree_' num2str(i) '.mat ' './Backup/back_tree_' num2str(i) '.mat']);
    else
        disp(['test ' num2str(i)]);
        system(['bsub -J ' 'job_test' num2str(i) ' -oo "./Output/%J.out"  -R "rusage[mem=5110]" -W 01:00 ./MAPTestTree' ' ./Trees/tree_' num2str(i) '.mat' ' ./Pred/prediction_' num2str(i) '.mat']);
    end
    
end

jobs_string = [jobs_string(1:end-2) ' '' '];

system(['bsub -J job_fin -w ' jobs_string ' -W 01:00 ./MapReduce_TrainForest' ]);
