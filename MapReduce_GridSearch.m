clear;
K = 3;
L = 21;

Files.Index = 'Index';%Test';
Files.Features = 'HNRF_Features';%Test';
Files.ILP = 'ILP';%Test';
Files.Labels = 'Labels';%Test';
Files.predILP = 'predILP';%Test';
%Files.NeibsSuff = 'neibs';

load(Files.Index);

features_names{1} = 'sift_hist_int_';
% features_names{2} = 'sift_hist_dial';
% features_names{3} = 'color_hist';
% features_names{4} = 'dial_color_hist';
% features_names{5} = 'int_text_hist_mr';
% features_names{6} = 'dial_text_hist_mr';

% features_names{1} = 'sift_hist_int_';
% features_names{2} = 'color_hist';
% features_names{3} = 'int_text_hist_mr';
% features_names{4} = 'dial_color_hist';
% features_names{5} = 'int_text_hist_mr';
% features_names{6} = 'sift_hist_dial';


ImIdxA = 1:2:length(Index);
ImIdxB = 2:2:length(Index);
alpha = cell(1,20);
i = 1;

alpha_kernels = cover_simplex(1,[0.0:0.1:1],1);
k = 1;
for alpha_unary = 0.1:0.01:1
    for j = 1 : length(alpha_kernels)
        alpha{k} = [alpha_unary alpha_kernels{j}];
        k = k + 1;
    end
end

save('init_file_2f.mat');

for i = 1 : length(alpha)
    if(exist( ['./Results/output_' num2str(i) '.mat'] ) == 0);
        disp(num2str(i));
        system(['bsub -J ' 'job' num2str(i) ' -oo "./Output/%J.out"  -R "rusage[mem=5110]" -W 01:00 ./MAPMeasureAgreement init_file_2f ' num2str(i) ' ./Results/output_' num2str(i) '.mat']);
    end
end