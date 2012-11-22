clear;
GtDir = 'd:\MATLAB\im_parser\LabelMeDataSet\SemanticLabels\';

suffix = 'Test';
%feature_names = cell(1);
load(['Index' suffix]);

ILP = [];%sparse(TotalSP, TotalSP);


for image_i = 1 : length(Index)
    
    curr_name = Index{image_i}.name;
    
    load( [GtDir curr_name '.mat']);
    if isempty(ILP)
        ILP = zeros(TotalSP, length(names));
    end
    
    ILP(Index{image_i}.offset + 1: Index{image_i}.offset + Index{image_i}.tot_sp, Index{image_i}.labels) = 1;
end
save(['ILP' suffix '.mat'],'ILP');
%'Graph', 'K', 'L')