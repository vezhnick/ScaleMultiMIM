% load RF_FeaturesTest
% load TasksAndNeibsTest
% load LabelsTest;
% load Index
% 
% 
% idx = false(1, size(TotLeaf,2));
% train_sp_idx = idx;
% train_sp_idx(1:79600) = true;
% test_sp_idx = ~train_sp_idx;
% %TrainLeafs = TotLeaf(:,train_sp_idx);
% TestLeafs = TotLeaf(:,train_sp_idx);
% TestLabels = Labels(test_sp_idx);
% PredLabels = TestLabels * 0;


%%
% for im = test_idx
%     im
%     neibs_idx = false(1, length(Labels));
%     im_sp_idx = SPtoImage == im;
%     
%     for n = 1 : 200%size(Neibs,2)
%         neibs_idx(SPtoImage == Neibs( im - test_idx(1) + 1 ,n) ) = true;
%     end
%     
%     NeibLeafs = TotLeaf(:,neibs_idx);
%     NeibLabels = Labels(neibs_idx);
%     for sp = find(im_sp_idx)'
%         
%         Proxy = repmat(TotLeaf(:,sp), 1, size(NeibLeafs,2));
%         dist = sum(Proxy ~= NeibLeafs);
%         dist = full(dist);
%         [val rank] = sort(dist);
%         
%         candidates = NeibLabels(rank(1:10));
%         
%         h = hist(candidates, [0.5:1:32.5]); .* L_weights;
%         
%         [val l] = max(h);
%         PredLabels(sp) = l(1);
%     end
% end
% mean(PredLabels(test_sp_idx) == Labels(test_sp_idx))
% 
% %%
% cm = zeros(NClasses,NClasses);
% 
% for i = find(test_sp_idx)
%     if(Labels(i) ~= 0 )%labels_tr(i) ~= 0)
%         %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
%         cm(PredLabels(i), Labels(i)) = cm(PredLabels(i), Labels(i)) + 1;%mass_norm(i);
%     end
% end
% 
% for i = 1 : size(cm,1)
%     if( sum(cm(:,i)) > 0)
%         cm(:,i) = cm(:,i) / sum(cm(:,i));
%     end
% end
% 
% mean(diag(cm))

% k = 1;
% 
% pop_idx = 0;
% pop_stat = 0;
% max_pop = 0;
% for i = to_open_que%1 : length(tree)
% %     if tree{i}.isleaf || tree{i}.depth ~= 17
% %         continue
% %     end
%     max_pop = max(max_pop, tree{i}.depth);
%     pop_stat(k) = tree{i}.depth;
%     pop_idx(k) = i;
%     k = k + 1;
%     %tree{i}.isleaf = true;
% end
%%
pop_stat = 0;
max_pop = 0;
k = 1;
for i = 1 : length(tree)
     if tree{i}.depth < 60 || tree{i}.isleaf
         continue
     end

    max_pop = max(max_pop, tree{i}.count);
    pop_stat(k) = tree{i}.count;
    k = k + 1;
end

figure, hist(pop_stat,33)

% clear;
% 
% TotLeaf = [];
% 
% for i = 1 : 100
%     i
%     load(['./Trees/tree_' num2str(i) '_LID.mat']);
%     LeafId = sparse(LeafId);
%     LeafId = LeafId * 1.0;
%     TotLeaf = cat(1,TotLeaf, LeafId);
% end
% 
% save('RF_Features.mat', 'TotLeaf');