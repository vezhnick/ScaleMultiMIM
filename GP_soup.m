clear;
%close all;
summary = REDU_MeasureAgreement('.\Results\SupervisedThorough\init_file_2f.mat', '.\Results\SupervisedThorough\output', ones(1,33));
load .\Results\SupervisedThorough\init_file_2f;

%%
grid = zeros(4,20);
idx = [];
k = 1;
for i = 1 : length(alpha)
    %     if(abs(alpha{i}(1) - 0.24) < 0.005)
    grid(:,i) = alpha{i};
    %         idx = [idx i];
    %         k = k + 1;
    %     end
end

%%
% finest_grid = zeros(4,20); %)
% i = 1;
%
% alpha_kernels = cover_simplex(3,[0.0:0.05:1],1);
% k = 1;
% for alpha_unary = 0.01:0.01:0.3
%     for j = 1 : length(alpha_kernels)
%         finest_grid(:,k) = [alpha_unary alpha_kernels{j}];
%         k = k + 1;
%     end
% end

measurements = summary.f_score * 100000;

finest_grid = grid;

grid = grid(:,1:1400:end);
full_measurements = measurements;
measurements = measurements(1,1:1400:end);
%%

iter_num = 100;
figure;
beta = 10.01
[rounds_vs_max measurements_new cov_evolve it_is_const] = SearchGridGP(grid, finest_grid, full_measurements, measurements,iter_num, beta);
    
plot(rounds_vs_max, 'b');
hold on
plot(measurements_new(size(measurements,2):end) / 10000, 'r--');
% for beta = [0.001 0.01 0.1 1 ]
%     [rounds_vs_max measurements_new] = SearchGridGP(grid, finest_grid, full_measurements, measurements,iter_num, beta);
%     plot(rounds_vs_max, 'b');
% hold on
% end

% figure;
% hold on
% colors = ['r' 'g' 'b' 'y' 'm'];
% for i = 1 : 5
% plot(cov_evolve(i, :), colors(i));
% end
% plot(measurements_new / 1000, 'r--');
% plot(it_is_const * 10, 'b')


%%
rounds_vs_max = zeros(1,iter_num + 1);
for i = 1 : 100
    [rounds_vs_max_cur measurements_cur] = SearchGridRandom(grid, finest_grid, full_measurements, measurements, iter_num);
    rounds_vs_max = rounds_vs_max + rounds_vs_max_cur;
end

plot(rounds_vs_max / 100, 'r');

title('F-score optimization');
Xlabel('queried points');
Ylabel('found optimum / global optimum');