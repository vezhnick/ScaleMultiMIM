clear;
% close all;
ResultsDir = 'ERHF_PPix';
    
summary = REDU_MeasureAgreement(['./Results/' ResultsDir '/init_file_2f.mat'], ['./Results/' ResultsDir '/output'], ones(1,33))

%%
figure, plot(summary.tot_per_class_aggr, 'b');
hold on, plot(summary.tot_per_pix_acc, 'r')
%plot(summaryColor.tot_per_class_acc, 'g')
plot(summary.tot_per_class_acc, 'g')
plot(summary.tot_per_pix_aggr, 'm')
%plot(summaryColor.patrick_base, 'b-*');
%plot(summaryColor.tot_ik_lz, 'b-*');
% 
% summarySuper = REDU_MeasureAgreement('.\Results\RFZombie\init_file_2f.mat', '.\Results\RFZombie\output', ones(1,33));
% %%
% figure, plot(summarySuper.tot_per_class_aggr, 'b');
% hold on, plot(summarySuper.tot_per_pix_acc, 'r')
% %plot(summarySuper.tot_per_class_acc, 'g')
% plot(summarySuper.agreement_entropy, 'g')
