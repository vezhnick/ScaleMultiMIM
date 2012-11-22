clear;
summary = REDU_MeasureAgreement('.\Results\SuperZombie\init_file_2f.mat', '.\Results\SuperZombie\output', ones(1,33));
load .\Results\SuperZombie\init_file_2f;

%%
grid = zeros(4,20);
idx = [];
k = 1;
for i = 1 : length(alpha)
    %     if(abs(alpha{i}(1) - 0.24) < 0.005)
    grid(:,k) = alpha{i};
    idx = [idx i];
    k = k + 1;
    %     end
end

%%
% finest_grid = zeros(4,20); %)
% i = 1;
%
% alpha_kernels = cover_simplex(3,[0.0:0.01:1],1);
% k = 1;
% for alpha_unary = 0.24%:0.005:0.3
%     for j = 1 : length(alpha_kernels)
%         finest_grid(:,k) = [alpha_unary alpha_kernels{j}];
%         k = k + 1;
%     end
% end

measurements = summary.tot_per_class_aggr(idx) * 10000;

finest_grid = grid;

grid = grid(:,1:500:end);
full_measurements = measurements;
measurements = measurements(1,1:500:end);

%%
rounds_vs_max = zeros(1,iter_num + 1);
for i = 1 : 50
    [rounds_vs_max_cur measurements_cur] = SearchGridRandom(grid, finest_grid, full_measurements, measurements, iter_num);
    rounds_vs_max = rounds_vs_max + rounds_vs_max_cur;
end

plot(rounds_vs_max / 50, 'r');