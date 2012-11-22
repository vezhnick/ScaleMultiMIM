clear;
%close all;
summary = REDU_MeasureAgreement('.\Results\SupervisedThorough\init_file_2f.mat', '.\Results\SupervisedThorough\output', ones(1,33));
load .\Results\SupervisedThorough\init_file_2f;

iter_num = 200;

%%
grid = zeros(4,20);
idx = [];
k = 1;
for i = 1 : length(alpha)
    grid(:,i) = alpha{i};
end

measurements = summary.f_score * 10000;

finest_grid = grid;

grid = grid(:,1:1400:end);
full_measurements = measurements;
measurements = measurements(1,1:1400:end);
%%
rounds_vs_max = zeros(1,iter_num + 1);
for i = 1 : 50
    [rounds_vs_max_cur measurements_cur] = SearchGridRandom(grid, finest_grid, full_measurements, measurements, iter_num);
    rounds_vs_max = rounds_vs_max + rounds_vs_max_cur;
end

plot(rounds_vs_max / 50, 'r');