load RF_FeaturesTest
load TasksAndNeibsTest
load LabelsTest;
load Index
load L_weights

load TrainLabelsFromMIM

idx = false(1, size(TotLeaf,2));
train_sp_idx = idx;
train_sp_idx(1:79600) = true;
test_sp_idx = ~train_sp_idx;
%TrainLeafs = TotLeaf(:,train_sp_idx);
TestLeafs = TotLeaf(:,train_sp_idx);
TestLabels = Labels(test_sp_idx);
PredLabels = TestLabels * 0;
NClasses = 33;
PredPot = zeros(length(PredLabels), 33);

Labels(train_sp_idx) = labels_train;

L_table = zeros(33, size(Labels,1));

for l =  1 : 33
    L_table(l,:) = (Labels == l) * L_weights(l);  %freq;
end

L_table = sparse(L_table');


for im = test_idx
    im
    neibs_idx = false(1, length(Labels));
    im_sp_idx = SPtoImage == im;
    
    for n = 1 : 200%size(Neibs,2)
        neibs_idx(SPtoImage == Neibs( im - test_idx(1) + 1 ,n) ) = true;
    end
    
    NeibLeafs = TotLeaf(:,neibs_idx);
    FeatWeight = NeibLeafs * L_table(neibs_idx ,:);
    inv_mass = 1 ./ sum(FeatWeight');
    inv_mass(isinf(inv_mass)) = 0;
    Proxy = sparse(length(inv_mass),length(inv_mass));
    Proxy = spdiags(inv_mass',0, Proxy);
    

    NewPot = TotLeaf(:,im_sp_idx)'* Proxy* FeatWeight;
    NewPot = full(NewPot);
    [tmp PredLabels_loc] = max(NewPot');
    PredPot(im_sp_idx,:) = NewPot;
    PredLabels(im_sp_idx) = PredLabels_loc;

%     for c = 1 : size(FeatWeight,2)
%         L_prior = sum(Labels(neibs_idx) == c) / sum(neibs_idx);
%         if(sum(FeatWeight(:,c)) > 0)
%             FeatWeight(:,c) = FeatWeight(:,c) / sum(FeatWeight(:,c)) * L_prior;% / freq(c);
%         end
%     end
    %NewPot = TotLeaf(:,im_sp_idx)' * FeatWeight;
    
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
%         h = hist(candidates, [0.5:1:32.5]); %.* L_weights;
%         
%         [val l] = max(h);
%         PredLabels(sp) = l(1);
%     end
end
%%
mass_norm = p_per_sp / sum(p_per_sp(test_sp_idx' & Labels > 0));

%per_pix_acc = sum((new_labels(Labels ~= 0)+1 == Labels(Labels ~= 0)) .* mass_norm(Labels ~= 0));

sum( (Labels(test_sp_idx' & Labels > 0) == PredLabels(test_sp_idx' & Labels > 0)) .* mass_norm(test_sp_idx' & Labels > 0))
%%
cm = zeros(NClasses,NClasses);

for i = find(test_sp_idx)
    if(Labels(i) ~= 0 )%labels_tr(i) ~= 0)
        %cm(init(i), Labels(i)+1) = cm(init(i), Labels(i)+1)+1;
        cm(PredLabels(i), Labels(i)) = cm(PredLabels(i), Labels(i)) + mass_norm(i);
    end
end

for i = 1 : size(cm,1)
    if( sum(cm(:,i)) > 0)
        cm(:,i) = cm(:,i) / sum(cm(:,i));
    end
end

%%
actualL = unique(Labels(test_sp_idx));
actualL = actualL(2:end);
d = diag(cm)

mean(d(actualL))