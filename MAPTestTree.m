function MAPTestTree(tree_file, output_file_name)

global Features;
global Labels;
global FeatureGroups;


%load SuperPNiebsTest
load TasksAndNeibsTest
load FeaturesTestBig
load LabelsTest
load IndexTest
load L_weights
load FeatureGroups

% L_weights = ones(1,33);
tree = 1;
load(tree_file);

NumNeibs = 200;

PredProbs = zeros(length(Labels),33);

if(exist([tree_file(1:end-4) '_LID.mat']))
    load ([tree_file(1:end-4) '_LID.mat']);
else
    LeafId = ProjectHyperTreeToLeafId(tree);
    save([tree_file(1:end-4) '_LID.mat'], 'LeafId', '-v7.3');
end

for im = test_idx
    im
    neibs_idx = false(1, length(Labels));
    
    for n = 1 : NumNeibs%size(Neibs,2)
        neibs_idx(SPtoImage == Neibs( im - min(test_idx) + 1 ,n) ) = true;
        %neibs_idx(SPtoImage == Neibs( im,n) ) = true;
    end
    tree = FillTreeByLID(neibs_idx, LeafId, L_weights, tree);  
    %tree = FillTree(neibs_idx, L_weights, tree);

    probs = HyperTreePredict(Features(:, SPtoImage == im), Labels(SPtoImage == im), tree);
    
    PredProbs(SPtoImage == im, :) = probs;
    
end

save(output_file_name, 'PredProbs');