load names
load ../MultiMIM/cm_Laz.mat
d = diag(cm)*100;

load CM_ERHF.mat
d = [d diag(cm)*100];
bar(d);
set(gca, 'xtick', 1:33, 'xTicklabel', names')
h=gca;
rotateticklabel(h,75);

%%
load ILP.mat
labels_corr = ILP'*ILP;
for i = 1 : 33
labels_corr(:,i) = labels_corr(:,i) / labels_corr(i,i);
end