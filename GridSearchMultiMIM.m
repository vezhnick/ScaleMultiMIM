clear;
K = 3;
L = 21;

load('Index');

features_names{1} = 'dial_color_hist';
features_names{2} = 'sift_hist_dial';
%features_names{3} = 'dial_text_hist_mr';
% features_names{4} = 'sift_hist_int_';
% features_names{5} = 'int_text_hist_mr';
% features_names{6} = 'color_hist';

ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);

per_pix_agreement = zeros(1,9);
per_node_agreement = zeros(1,9);

i = 1;
for a = 0.1 : 0.1: 1
    alpha = [a 1-a];
    [per_pix_agreement(i), per_node_agreement(i)] =  MeasureAgreement(features_names, ImIdxA, ImIdxB, K,L, alpha);
    
    i = i + 1;
end