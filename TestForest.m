%to be parameters
clear;
load SuperPNiebsTest
load FeaturesTestBig
load LabelsTest
load ForestTst_progress47
load IndexTest
%%
num_tasks = 10;
seed_images = zeros(10, num_tasks);
PredLabels = Labels .* 0;
% forest = cell(0);

for im = test_idx
    im
    neibs_idx = false(1, length(Labels));
    
    for n = 1 : 200%size(Neibs,2)
        neibs_idx(SPtoImage == Neibs( im  ,n) ) = true;
    end
    
    
    %     forest{i} = MakeRandomizedTree(Features(:,curr_sample), Labels(curr_sample), tasks_idx(:,curr_sample), NF_tests, NThr_tests, MaxDepth);
    
    for t = 1 : length(forest)
        forest{t} = FillTree(Features(:,neibs_idx), Labels(neibs_idx), forest{t});
        %forest{t} = FillTree(Features, Labels, forest{t});
    end
    %%
    probs = zeros(sum(SPtoImage == im),33);

    for t = 1 : length(forest)
        probs = probs + TreePredict(Features(:, SPtoImage == im), Labels(SPtoImage == im), forest{t});
    end
    
    [trash res] = max(probs');
    PredLabels(SPtoImage == im) = res';
    mean(Labels(PredLabels > 0 & Labels > 0) == PredLabels(PredLabels > 0 & Labels > 0))
    
end