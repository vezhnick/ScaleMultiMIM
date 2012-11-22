function [new_labels, idx_train, freq] = LearnAndInferOneConstraing(Files, suffix, ImIdxTrain, features_names, K, L, alpha)
% suffix = 'A';
% K = 3;
% L = 21;
RF = false;
load(Files.Index);

% ImIdx = 1:2:length(Index);
idx = zeros(1,TotalSP);
ImageToSpIdx = cell(1, length(ImIdxTrain));
k = 1;
for i = ImIdxTrain
    idx(Index{i}.offset+1:Index{i}.offset + Index{i}.tot_sp) = 1;
    ImageToSpIdx{k}.labels = Index{i}.labels;
    ImageToSpIdx{k}.offset = sum(idx(1:Index{i}.offset));
    ImageToSpIdx{k}.tot_sp = Index{i}.tot_sp;
    k = k + 1;
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


%%
freq = zeros(1,max(Labels))+1;
%ILP(1,:) = 0;
new_labels = Labels .* 0;
for i = 1 : length(Labels)
    cur_lbs = find(ILP(i,:) > 0);
    if(length(cur_lbs)> 0)
        cur_lbs = randintrlv(cur_lbs, i+2);
        new_labels(i) = cur_lbs(1);
        freq(cur_lbs(1)) = freq(cur_lbs(1)) + p_per_sp(i);
    else
        new_labels(i) = ceil(max(Labels) * rand());
    end
end

%freq(freq == 1) = max(freq);
%%

TotalLabels = size(ILP,2);
%freq = sum(freq + 1) ./ (freq + 1);

%%
if ~RF
    %Features = Features .* (repmat(p_per_sp', size(Features,1),1));
    Features = bsxfun(@times,Features,p_per_sp');
    WorkOutUnariesReg;
else
    WorkOutUnariesRF;
end

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

tst = sum(Gr_tot ~= 0);


NClasses = size(NewPot, 2);
labelCost = single(ones(NClasses,NClasses));
labelCost = labelCost - eye(length(labelCost));
%%

%NewPot(:,1) = 0;
log_Pot = -log( eps + NewPot);

[junk init] = max(-log_Pot(:,1:end)');

if(alpha(1) == -1)
    Gr_stat = full(median(sum(Gr_tot)));%full(median(sum(Gr_tot)));
    alpha_opt = -median(junk - max(junk)) / Gr_stat
    alpha_opt = 1 / (1 + alpha_opt)
else
    alpha_opt = alpha(1);
end

new_labels = init'-1;
%return;
[new_labels E Eafter] = GCMex(init-1, single(full(log_Pot * alpha_opt)'), (1 - alpha_opt) * Gr_tot, labelCost(1:end,1:end),1);

%%
for k = 1 : 10
    new_labels = new_labels + 1;
    if ~RF        
        WorkOutUnariesReg;
    else
        WorkOutUnariesRF;
    end
    
    NewPot = NewPot .* ILP;
    log_Pot = -log( eps + NewPot);
    
    
    [junk init] = max(-log_Pot(:,1:end)');
    if(alpha(1) == -1)
        Gr_stat = full(median(sum(Gr_tot)));
        alpha_opt = -median(junk - max(junk)) / Gr_stat;
    else
        alpha_opt = alpha(1);
    end
    
    %log_Pot = log_Pot;
    
    WorkOutConstraintAddendums;
    
    my_labels = new_labels;
    [new_labels E Eafter] = GCMex(new_labels-1, single(full(log_Pot * alpha_opt)' - 1.05 * Ksi'), (1 - alpha_opt) * Gr_tot, labelCost(1:end,1:end),1);
    %new_labels = active_alpha_mex(  'init',  Gr_tot, sparse(log_Pot / alpha_opt));
    clear active_alpha_mex
    %%
    mass_norm = p_per_sp / sum(p_per_sp(Labels~=0));
    per_pix_acc = sum((new_labels(Labels ~= 0)+1 == Labels(Labels ~= 0)) .* mass_norm(Labels ~= 0));
    per_node_acc = mean(new_labels(Labels ~= 0)+1 == Labels(Labels ~= 0));
    
    %mean((new_labels(Labels ~= 0) == Labels(Labels ~= 0)) .* p_per_sp(Labels ~= 0))
    
    cm = zeros(NClasses,NClasses);
    
    for i = 1 : length(Labels)
        if(Labels(i) ~= 0 )%labels_tr(i) ~= 0)
        %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
        cm(new_labels(i)+1, Labels(i)) = cm(new_labels(i)+1, Labels(i)) + mass_norm(i);
        end
    end
    
    for i = 1 : size(cm,1)
        if( sum(cm(:,i)) > 0)
            cm(:,i) = cm(:,i) / sum(cm(:,i));
        end
    end
    fprintf('Step %d, total accuracy = %f, average = %f, per node acc = %f \n, Energy = %f, Energy after = %f \n', ...
        k, per_pix_acc, mean(diag(cm)), per_node_acc, E, Eafter);
    scratchpad
end