%MIM predict test - full framework use, with selecting alpha from results
%of EA evaluation

clear;
DoComputeAll = 1;    
close all

ResultsDir = 'ERHF_PPix'

%%
if DoComputeAll
    K = 3;
    L = 21;
    

    results = REDU_MeasureAgreement(['./Results/' ResultsDir '/init_file_2f.mat'], ['./Results/' ResultsDir '/output'], ones(1,33))
    load (['./Results/' ResultsDir '/init_file_2f.mat']);
        
    load('IndexTest');
    
    
    [max_val max_idx] = max(results.tot_per_class_aggr)
    %max_idx = 5544;
    load(['./Results/' ResultsDir '/output_' num2str(max_idx) '.mat']);
    labels_train = results.inferred_labels;
    freq = results.F_score * 0;
    for i = 1 : length(freq)
        freq(i) = 1 + sum(labels_train == i + 1);
    end
    
    idx_train = zeros(1, Index{end}.offset + Index{end}.tot_sp);
    idx_train(1: length(labels_train)) = 1;
    idx_train = idx_train == 1;
    
    save('MIMPredictTest_UnitTestData.mat');
else
    load('MIMPredictTest_UnitTestData.mat');
end
%%
Files.Index = 'IndexTest';
Files.Features = 'ERHF_FeaturesTest';
Files.ILP = 'ILPTest';
Files.Labels = 'LabelsTest';
Files.predILP = 'PredILPTest';

% load Labels

% labels_train = Labels(idx_train_b)-1;
% labels_train(labels_train < 0) = 16;

%alpha = [0.2600    0.0000    1.0000         0];
%train_idx = train_idx(1:2:end);
alpha{max_idx}'

[labels_tst idx_tst] = MIMPredictBoost(Files, 'TrainTest_full_zombie', train_idx, features_names, labels_train, K, L, freq, alpha{max_idx}');

save(['ResultsTest_' ResultsDir '.mat'], 'labels_tst', 'labels_train', 'idx_tst');