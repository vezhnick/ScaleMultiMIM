close all
clear
results = REDU_MeasureAgreement('.\Results\GiantGhoul\init_file_2f.mat', '.\Results\GiantGhoul\output', ones(1,33))
load '.\Results\GiantGhoul\init_file_2f.mat'
transfer_cost_n = (results.transfer_cost + 34 * results.miss ) ./ (results.infer_cost);
transfer_cost_n = transfer_cost_n / max(transfer_cost_n);
transfer_cost_n = 1 - transfer_cost_n;
figure, plot(results.tot_per_pix_acc, 'r--')
hold on
plot(results.tot_per_class_aggr, 'm')
plot(transfer_cost_n, 'g')
%plot(results.infer_cost, 'black')
plot(results.miss / max(results.miss), 'black')
%legend('per pix accuracy test', 'per class agreement', 'transfer cost', 'Image label misses');%'per class accuracy');