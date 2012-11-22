function [Neibs, ImagesDB] = FindNeibours(ImagesDB, k)


TestPrediction = zeros(length(ImagesDB), 33);
TestLabels = zeros(length(ImagesDB), 33);

label_weights = zeros(1,33);
total_c = zeros(1,33);
% calculating label weights
for im = 1 : length(ImagesDB)
    
    cur_im = ImagesDB{im};
    for c = cur_im.labels
        if(c ~= 0)
            total_c(c) = total_c(c) + 1;
        end
    end    
end

label_weights = 1 ./ total_c;
label_weights = label_weights / min(label_weights);

total_c_tst = zeros(1,33);
% calculating label weights
for im = 1 : length(ImagesDB)
    
    cur_im = ImagesDB{im};
    for c = cur_im.labels
        if(c ~= 0)
            total_c_tst(c) = total_c_tst(c) + 1;
        end
    end    
end
%%
accuracy = zeros(33,1);
recall = zeros(33,1);

for tst_im = 1 : length(ImagesDB)
    
    kNN = zeros(1,k) + 100;
    dist = zeros(1,k) + 100;
    cur_test_im = ImagesDB{tst_im};
    
    for train_im = 1 : length(ImagesDB)
        
        cur_train_im = ImagesDB{train_im};
                
        if(train_im == tst_im || isempty(intersect(cur_train_im.labels , cur_test_im.labels)))
            continue;
        end
        total_dist = zeros(1,length(cur_train_im.Features));
        
        for f = 1 : length(cur_train_im.Features)
            loc_dist = cur_train_im.Features{f} - cur_test_im.Features{f};
            total_dist(f) = norm(loc_dist);
            if(f == 1)
                total_dist(f) = norm(loc_dist);
            elseif(f > 2 && f < 9)
                total_dist(f) = 0.5 * sum(((loc_dist).^2) ./ (cur_train_im.Features{f} + cur_test_im.Features{f} + eps));
                %total_dist(f) = norm(loc_dist,2);
                %total_dist(f) = sum(min (cur_train_im.Features{f}, cur_test_im.Features{f})) / sum(cur_test_im.Features{f});
            else
                total_dist(f) = norm(loc_dist);
                %total_dist(f) = 0.5 * sum(((loc_dist).^2) ./ (cur_train_im.Features{f} + cur_test_im.Features{f} + eps));
            end
        end
        
        total_dist = sum(total_dist(1:end));% GIST_dist + PHOW_dist;
        %total_dist = total_dist * cur_train_im.w;% GIST_dist + PHOW_dist;
        %total_dist = total_dist * w(:,train_im);
        
        if(total_dist < max(dist))
            ins_idx = find(dist == max(dist));
            ins_idx = ins_idx(1);
            dist(ins_idx) = total_dist;
            kNN(ins_idx) = train_im; %WRONG!
        end        
    end
    
    pred_labels = zeros(1,33);
    w_loc = 5;
    dist = exp(-dist*w_loc) / sum(exp(-dist*w_loc));
%     [dist idx] = sort(dist, 'descend');
%     kNN = kNN(idx);

    ImagesDB{tst_im}.kNN = kNN;

    for i = 1 : k
        cur_neib = ImagesDB{kNN(i)};
        for c = 1 : length(cur_neib.labels)
            if(cur_neib.labels(c) ~= 0)
                pred_labels(cur_neib.labels(c)) = pred_labels(cur_neib.labels(c)) + dist(i);
            end
        end
    end
    
end
recall = recall ./ total_c_tst';
accuracy = (mean(TestLabels == TestPrediction > 0.5))';
mean(recall)
%mean(accuracy)
mean(mean(TestLabels == TestPrediction > 0.5))

accuracy_plus = (mean(TestLabels(TestLabels == 1) == TestPrediction(TestLabels == 1) > 0.5))';
for i = 1 : 33
accuracy_plus(i) = mean(TestPrediction(TestLabels(:,i) == 1,i))';
end
accuracy_plus = accuracy_plus';

accuracy_minus = (mean(TestLabels(TestLabels == 1) == TestPrediction(TestLabels == 1) > 0.5))';
for i = 1 : 33
accuracy_minus(i) = mean(1 - TestPrediction(TestLabels(:,i) == 0,i))';
end
accuracy_minus = accuracy_minus';
accuracy_balanced = 0.5  * (accuracy_minus + accuracy_plus);

%%
avMeanAP = zeros(33,1);
avMeanAR = zeros(33,1);
for c = 1 : 33
    predictions = TestPrediction(:,c);
    [trash idx] = sort(predictions, 'descend');
    
    Precision = zeros(1, length(predictions));
    Recall    = zeros(1, length(predictions));
    
    count = 1;
    relevant = 0;
    
    meanAP = 0;
    meanAR = 0;
    l = 1;
    for r = idx'
        if(predictions(r) < 0.5), break; end;
        
        if(ismember(c, ImagesDB_test{r}.labels))
            relevant = relevant + 1;
        end
        meanAP = meanAP + relevant / count;
        meanAR = relevant / total_c_tst(c);
        Precision(l) = relevant / count;
        Recall(l) = relevant / total_c_tst(c);
        count = count  +1;
        l = l + 1;
    end
    
    avMeanAP(c) = meanAP / count;
    avMeanAR(c) = meanAR / count;
%      figure, plot(Recall(1:l-1), Precision(1:l-1));
%      title(num2str(c));
%      pause;
end

mean(avMeanAP)

Neibs = zeros(length(ImagesDB), k);

for i = 1 : length(ImagesDB)
    Neibs(i,:) = ImagesDB{i}.kNN;
end
%%
% res_dir = 'E:\Work\STF_Test\datasets\Sift_flow\TagPropILP\';
% 
% for tst_im = 1 : length(ImagesDB_test)
%     cur_im = ImagesDB_test{tst_im};
%     fid = fopen( [res_dir ImagesDB_test{tst_im}.name '_ilp.dat'], 'w');
%     fwrite(fid, TestPrediction(tst_im,:) ,'double');
%     fclose(fid);
%     
%     fid = fopen( [res_dir ImagesDB_test{tst_im}.name '_kNN.dat'], 'w');
%     for nn = 1 : k
%         fprintf(fid, [ImagesDB_train{cur_im.kNN(nn)}.name(1:end-4) '\n']);
%     end
%     fclose(fid);
%     
% end
