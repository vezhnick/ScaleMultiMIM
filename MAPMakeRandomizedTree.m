function MAPMakeRandomizedTree(init_file_name, output_file_name, backup_file_name)

global Features;
global Labels;
global Weights;
%load SuperPNiebs
load TasksAndNeibs
load FeaturesBig
load Labels

load(init_file_name);

tree = MakeRandomizedTree(tasks_idx, NF_tests, NThr_tests, MaxDepth, backup_file_name, 250);

save(output_file_name, 'tree');