%supervised test
clear;

Files.Index = 'IndexTest';
Files.Features = 'ERHF_FeaturesTest';
Files.ILP = 'ILPTest';
Files.Labels = 'LabelsTest';
Files.predILP = 'PredILPTest';
%Files.NeibsSuff = 'TrainTest_neibs_zombie';

K = 3;
L = 21;

load('IndexTest');
ImIdxA = train_idx;
ImIdxB = test_idx;

features_names{1} = 'sift_hist_int_';
features_names{2} = 'sift_hist_dial';
%features_names{3} = 'int_text_hist_mr';

TotalTrainSP = 0;
for i = train_idx
    TotalTrainSP = TotalTrainSP + Index{i}.tot_sp;
end
load (Files.Labels);

labels_train = Labels(1:TotalTrainSP);
labels_train(labels_train == 0) = 16;

alpha = [ 0.8    0.5    0.5  ];

[labels_tst idx_tst] = MIMPredictBoost(Files, 'TrainTest_full', train_idx, features_names, labels_train-1, K, L, 1, alpha);

save(['ResultsTest_Supervised.mat'], 'labels_tst', 'idx_tst');