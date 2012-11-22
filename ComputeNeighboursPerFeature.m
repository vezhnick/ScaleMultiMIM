function Neibs = ComputeNeighboursPerFeature(ImagesDB_train, ImagesDB_test, f, k)


for tst_im = 1 : length(ImagesDB_test)
    
    kNN = zeros(1,k) + 100;
    dist = zeros(1,k) + 100;
    cur_test_im = ImagesDB_test{tst_im};
    
    for train_im = 1 : length(ImagesDB_train)
        cur_train_im = ImagesDB_train{train_im};
        total_dist = zeros(1,length(cur_train_im.Features));
        
        loc_dist = cur_train_im.Features{f} - cur_test_im.Features{f};
        total_dist(f) = norm(loc_dist);
        if(f == 1)
            total_dist(f) = norm(loc_dist);
        elseif(f > 2 && f < 9)
            total_dist(f) = 0.5 * sum(((loc_dist).^2) ./ (cur_train_im.Features{f} + cur_test_im.Features{f} + eps));
            total_dist(f) = norm(loc_dist,2);
            total_dist(f) = sum(min (cur_train_im.Features{f}, cur_test_im.Features{f})) / sum(cur_test_im.Features{f});
        else
            total_dist(f) = norm(loc_dist);
            total_dist(f) = 0.5 * sum(((loc_dist).^2) ./ (cur_train_im.Features{f} + cur_test_im.Features{f} + eps));
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
    
    ImagesDB_test{tst_im}.kNN = kNN;

end


Neibs = zeros(length(ImagesDB_test), k);

for i = 1 : length(ImagesDB_test)
    Neibs(i,:) = ImagesDB_test{i}.kNN;
end