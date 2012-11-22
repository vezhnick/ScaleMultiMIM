function [new_labels idx_tst] = MIMPredict(Files, suffix, ImIdxTrain, features_names, train_labels, K, L, freq, alpha)
% suffix = 'A';
% K = 3;
% L = 21;
RF = true;
load(Files.Index);

idx_train = zeros(1,TotalSP);

for i = ImIdxTrain
    idx_train(Index{i}.offset+1:Index{i}.offset + Index{i}.tot_sp) = 1;
end
idx_train = idx_train == 1;
idx_tst = ~idx_train;

load(Files.predILP);
load(Files.ILP);
load(Files.Features);
load(Files.Labels);

% load('ILP');
% load('Features');
% 
% load('Labels');

TotalLabels = size(ILP,2);

Gr_tot = sparse(TotalSP, TotalSP);

for i = 1 : length(features_names)
    load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix  '.mat']);
    Graph = max(Graph, Graph');
    Gr_tot = Gr_tot + alpha(i+1) * Graph;
%     load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' Files.NeibsSuff '.mat']);
%     Graph = max(Graph, Graph');
%     Gr_tot = Gr_tot + alpha(i+1) * Graph;
end
clear 'Graph'

% train_labels = Labels(idx_train)-1;
% train_labels(train_labels < 0) = 16;
if ~RF
    Features = Features .* (repmat(p_per_sp', size(Features,1),1));
    WorkOutUnariesPrediction;
else
    WorkOutUnariesPredictionRF;
end

% load RF_probs
% NewPot = PredPot;

%%
ILPfull = ILP;
ILPfull(idx_tst,:) = predILP(idx_tst,:);
% ILP_crazy = ILPfull *0;
% ILP_crazy(:,[6 17 28 32]) = ILPfull(:,[6 17 28 32]);
NewPot = NewPot .* ILPfull;


NClasses = size(NewPot, 2);
labelCost = single(ones(NClasses,NClasses));
labelCost = labelCost - eye(length(labelCost));


%%
log_Pot = -log( eps + NewPot);

[junk init] = max(-log_Pot');
[junk trash] = max(-log_Pot(idx_train,:)');

if(alpha(1) == -1)
    Gr_stat = full(median(sum(Gr_tot(idx_train,idx_train))));
    alpha_opt = -median(junk - max(junk)) / Gr_stat
else
    alpha_opt = alpha(1);
end

%%
num_idx_train = find(idx_train);

for i = 1: length(train_labels)
    log_Pot(num_idx_train(i),:) = 1000;
    log_Pot(num_idx_train(i),train_labels(i) + 1) = 0;
    init(num_idx_train(i)) = train_labels(i)+1;
end
%%
%[my_labels E Eafter] = GCMex(init, single(full(log_Pot / alpha_opt)'), Gr_tot, labelCost(1:end,1:end),1);
%%my_labels = active_alpha_mex(  'init',  Gr_tot, sparse(log_Pot / alpha_opt));
new_labels = init'-1;
[new_labels E Eafter] = GCMex(init-1, single(full(log_Pot * alpha_opt)'), (1 - alpha_opt) * Gr_tot, labelCost(1:end,1:end),1);
%%


mass_norm = p_per_sp;% / sum(p_per_sp(idx_tst));
per_pix_acc = sum((new_labels(idx_tst)+1 == Labels(idx_tst)) .* mass_norm(idx_tst));
per_node_acc = mean(new_labels(idx_tst)+1 == Labels(idx_tst));

%mean((new_labels(Labels ~= 0) == Labels(Labels ~= 0)) .* p_per_sp(Labels ~= 0))

cm = zeros(NClasses,NClasses);
cm_frac = zeros(NClasses, NClasses);

for i = find(idx_tst)
    if(Labels(i) ~= 0 )%labels_tr(i) ~= 0)
        %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
        for j = 1 : NClasses
            cm_frac(new_labels(i)+1, j) = cm(new_labels(i)+1, j) + mass_norm(i) * LabelsFrac(i,j);
        end
        cm(new_labels(i)+1, Labels(i)) = cm(new_labels(i)+1, Labels(i)) + mass_norm(i);
    end
end

for i = 1 : size(cm,1)
    if( sum(cm_frac(:,i)) > 0)
        cm_frac(:,i) = cm_frac(:,i) / sum(cm_frac(:,i));
    end
    if( sum(cm(:,i)) > 0)
        cm(:,i) = cm(:,i) / sum(cm(:,i));
    end
end

actualL = unique(Labels(idx_tst));
actualL = actualL(2:end);
d = diag(cm_frac);

mean(d(2:end))

fprintf('Total accuracy = %f, average = %f, per node acc = % f \n', per_pix_acc, mean(d(actualL)), per_node_acc);
new_labels = new_labels(idx_tst);