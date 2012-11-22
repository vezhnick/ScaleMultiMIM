clear;

ImageDir = '..\im_parser\LabelMe\Images\';
DescriptorsDir = '..\im_parser\LabelMe\Data\Descriptors\Global\';
GtDir = '..\im_parser\LabelMe\SemanticLabels\';
file_list = dir(ImageDir);

feature_names = cell(1);
load('IndexTest');

ImIdx = 1:2:length(Index);

descriptor_names{1} = 'coHist';
% descriptor_names{2} = 'SpatialPyr';
% descriptor_names{3} = 'SpatialPyrDense';
descriptor_names{2} = 'tinyIm';
descriptor_names{3} = 'gist';


ImIdxA = train_idx;
ImIdxB = test_idx;

Graph = sparse(TotalSP, TotalSP);

ILP = [];


for image_i = 1 : length(Index)

    curr_name = Index{image_i}.name;

    for i = 1 : length(descriptor_names)-1
        Index{image_i}.(descriptor_names{i}) = (load([DescriptorsDir descriptor_names{i} '\' curr_name '_' descriptor_names{i} '.mat']));
    end
    i = 3;
    Index{image_i}.(descriptor_names{i}) = load([DescriptorsDir descriptor_names{i} '\' curr_name '_' descriptor_names{i} '.txt']);

    Index{image_i}.coHist = Index{image_i}.coHist.coHist';
    Index{image_i}.tinyIm = double(Index{image_i}.tinyIm.tinyIm(:));
end
%%

load('ILP.mat');
predILP = zeros(size(ILP));

TotalLabels = size(ILP,2);

K = 5;
mult = 1;
neibs = zeros(length(Index), K);
for image_i = ImIdxA
    
    dist = zeros(length(descriptor_names),length(Index)) -1;
    
    for image_j = ImIdxB
        
        for i = 1 : length(descriptor_names)
            
            loc_dist = Index{image_i}.(descriptor_names{i}) - Index{image_j}.(descriptor_names{i});
            loc_sum = Index{image_i}.(descriptor_names{i}) + Index{image_j}.(descriptor_names{i});
            if i == 1
                dist(i, image_j) = 0.5 * sum(((loc_dist).^2) ./ (loc_sum + eps));
            else
                dist(i, image_j) = sqrt(loc_dist' * loc_dist);
            end
            
        end
        
    end
    for i = 1 : length(descriptor_names)
        dist(i, dist(i,:) > 0) = dist(i, dist(i,:) > 0) / max(dist(i, dist(i,:) > 0));
    end
    dist(:,ImIdxB) = exp(-mult*dist(:,ImIdxB));
    dist(:,ImIdxB) = dist(:,ImIdxB) ./ repmat(sum(dist(:,ImIdxB)), length(descriptor_names), 1);
    dist(dist == -1) = 100000;
    [val idx] = sort(dist);
    tot = 0;
    predILP_cur = zeros(1, TotalLabels);
    for i = 1 : K
        cur_im = idx(i);
        predILP_cur(Index{cur_im}.labels) = predILP_cur(Index{cur_im}.labels) + val(i);
        tot = tot + val(i);
    end
    predILP(Index{image_i}.offset + 1:Index{image_i}.offset + Index{image_i}.tot_sp, :) = ...
                    repmat(predILP_cur, Index{image_i}.tot_sp, 1) / tot;
    neibs(image_i,:) = idx(1:K);
    
end

for image_i = ImIdxB
    
    dist = zeros(length(descriptor_names),length(Index)) -1;
    
    for image_j = ImIdxA
        
        for i = 1 : length(descriptor_names)
            
            loc_dist = Index{image_i}.(descriptor_names{i}) - Index{image_j}.(descriptor_names{i});
            loc_sum = Index{image_i}.(descriptor_names{i}) + Index{image_j}.(descriptor_names{i});

            if i == 1
                dist(i, image_j) = 0.5 * sum(((loc_dist).^2) ./ (loc_sum + eps));
            else
                dist(i, image_j) = sqrt(loc_dist' * loc_dist);
            end
            
        end
        
    end
    for i = 1 : length(descriptor_names)
        dist(i, dist(i,:) > 0) = dist(i, dist(i,:) > 0) / max(dist(i, dist(i,:) > 0));
    end
    dist(:,ImIdxA) = exp(-mult*dist(:,ImIdxA));
    dist(:,ImIdxA) = dist(:,ImIdxA) ./ repmat(sum(dist(:,ImIdxA)), length(descriptor_names), 1);
    
    dist(dist == -1) = 100000;
    [val idx] = sort(dist);
    tot = 0;
    predILP_cur = zeros(1, TotalLabels);
    for i = 1 : K
        cur_im = idx(i);
        predILP_cur(Index{cur_im}.labels) = predILP_cur(Index{cur_im}.labels) + val(i);
        tot = tot + val(i);
    end
    predILP(Index{image_i}.offset + 1:Index{image_i}.offset + Index{image_i}.tot_sp, :) = ...
                    repmat(predILP_cur, Index{image_i}.tot_sp, 1) / tot;
    neibs(image_i,:) = idx(1:K);
    
end
InNeibs = neibs;
%%
% TotalLabels = size(ILP,2);
% avMeanAP = zeros(TotalLabels,1);
% avMeanAR = zeros(TotalLabels,1);
% for c = 1 : TotalLabels
%     predictions = predILP(:,c);
%     [trash idx] = sort(predictions, 'descend');
%     
%     Precision = zeros(1, length(predictions));
%     Recall    = zeros(1, length(predictions));
%     
%     count = 1;
%     relevant = 0;
%     
%     meanAP = 0;
%     meanAR = 0;
%     l = 1;
%     for r = idx'
%         if(predictions(r) < 0.5), break; end;
%         
%         if(ismember(c, Index{r}.labels))
%             relevant = relevant + 1;
%         end
%         meanAP = meanAP + relevant / count;
%         %meanAR = relevant / total_c_tst(c);
%         %Precision(l) = relevant / count;
%         %Recall(l) = relevant / total_c_tst(c);
%         count = count  +1;
%         l = l + 1;
%     end
%     
%     avMeanAP(c) = meanAP / count;
%     %avMeanAR(c) = meanAR / count;
% %      figure, plot(Recall(1:l-1), Precision(1:l-1));
% %      title(num2str(c));
% %      pause;
% end
% 
% mean(avMeanAP)

save('predILPandNeibTest.mat','predILP','InNeibs');
%'Graph', 'K', 'L')