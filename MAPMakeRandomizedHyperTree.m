function MAPMakeRandomizedHyperTree(init_file_name, output_file_name, backup_file_name)

global Features;
global Labels;
global Weights;
global FeatureGroups
%load SuperPNiebs
load TasksAndNeibs
load FeaturesBig
load Labels


load(init_file_name);

tree = MakeRandomizedHyperTree(tasks_idx, MaxDepth, backup_file_name);

save(output_file_name, 'tree');