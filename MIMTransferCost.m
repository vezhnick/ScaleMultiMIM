function [TransferCost, InferCost] = MIMTransferCost(Files, suffix, ImIdxTrain, features_names, K, L, alpha, freq, train_labels, transfer_labels)
% suffix = 'A';
% K = 3;
% L = 21;
load(Files.Index);

% ImIdx = 1:2:length(Index);
idx = zeros(1,TotalSP);

for i = ImIdxTrain
    idx(Index{i}.offset+1:Index{i}.offset + Index{i}.tot_sp) = 1;
end

load(Files.ILP);
load(Files.Features);
load(Files.Labels);
%addpath('../GCMex/');
%%
idx = idx == 1;
idx_train = idx;

Labels = Labels(idx);
LabelsFrac = LabelsFrac(idx,:);
p_per_sp = p_per_sp(idx);
ILP = ILP(idx,:);
Features = Features(:,idx);

new_labels = train_labels+1;

%freq(freq == 1) = max(freq);
%%

TotalLabels = size(ILP,2);
%freq = sum(freq + 1) ./ (freq + 1);

%%
Features = Features .* (repmat(p_per_sp', size(Features,1),1));

new_labels = train_labels+1;

WorkOutUnariesReg;
%NewPot = rand(size(NewPot));
NewPot = NewPot .* ILP;

%%
Gr_tot = sparse(TotalSP, TotalSP);
%alpha = [0.2 0.8];
for i = 1 : length(features_names)
    load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix  '.mat']);
    Graph = max(Graph, Graph');
    Gr_tot = Gr_tot + alpha(i + 1) * Graph;
%     load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' 'neibs'  '.mat']);
%     Gr_tot = Gr_tot + alpha(i + 1) * Graph;
end

Gr_tot = Gr_tot(idx,idx);
%Gr_tot(Gr_tot > 0) = 1 - Gr_tot(Gr_tot > 0);
clear 'Graph'


NClasses = size(NewPot, 2);

log_Pot = -log( eps + NewPot);

[junk init] = max(-log_Pot(:,1:end)');

if(alpha(1) == -1)
    Gr_stat = full(median(sum(Gr_tot)));
    alpha_opt = -median(junk - max(junk)) / Gr_stat;
else
    alpha_opt = alpha(1);
end

% return;

TransferCost.Un = 0;
TransferCost.Pa = 0;
TransferCost.Miss = 0;

InferCost.Un = 0;
InferCost.Pa = 0;


for i = 1 : length(train_labels)
    if(ILP(i,transfer_labels(i)+1) == 0)
        TransferCost.Miss = TransferCost.Miss + 1;
    else
        TransferCost.Un = TransferCost.Un + log_Pot(i, transfer_labels(i) + 1) * alpha_opt;
    end
    InferCost.Un = InferCost.Un + log_Pot(i, train_labels(i) + 1)  * alpha_opt;
end

[row col] = find(Gr_tot);

half_idx = row' > col';

for i = find(half_idx)
    InferCost.Pa = InferCost.Pa + (1 - alpha_opt )* Gr_tot(row(i), col(i)) * (train_labels(row(i)) ~= train_labels(col(i)));
    TransferCost.Pa = TransferCost.Pa + (1 - alpha_opt ) * Gr_tot(row(i), col(i)) * (transfer_labels(row(i)) ~= transfer_labels(col(i)));
end

