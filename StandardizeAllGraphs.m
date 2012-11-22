clear;
K = 3;
L = 21;

load('Index');

features_names{1} = 'dial_color_hist';
features_names{2} = 'sift_hist_dial';
features_names{3} = 'dial_text_hist_mr';
features_names{4} = 'sift_hist_int_';
features_names{5} = 'int_text_hist_mr';
features_names{6} = 'color_hist';



ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);

postfix = '_standard';

suffix{1,1} = 'A_zombie';
suffix{1,2} = 'A_full_zombie';
suffix{2,1} = 'B_zombie';
suffix{2,2} = 'A_full_zombie';

for i = 1 :length(features_names)
    for j = 1:length(suffix) % = ['A_zombie' 'B_zombie']
        
        disp([features_names{i} ' for ' suffix{j}]);
        
        load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix{j,1} '.mat']); 
        Mu = full(mean(Graph(Graph > 0)));
        Sigma = full(sqrt(var(Graph(Graph > 0))));
        
        Graph = StandardizeGraph(Graph, Mu, Sigma);

        save(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix{j,1} postfix  '.mat'], 'Graph', 'K', 'L');

        load(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix{j,2} '.mat']); 
        
        Graph = StandardizeGraph(Graph, Mu, Sigma);
        
        save(['Graph_' features_names{i} '_' num2str(K) '_' num2str(L) '_' suffix{j,2} postfix  '.mat'], 'Graph', 'K', 'L');
    end
end