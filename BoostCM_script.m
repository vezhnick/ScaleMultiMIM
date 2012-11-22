[L_out, P_out, i_out, fixed_out] = BoostLI(['./Results/' ResultsDir '/init_file_2f.mat'], ['./Results/' ResultsDir '/output']);



model_chain = [];


load Labels

model_chain = [model_chain i_out];
[InfL trash] = find(L_out');
[per_class_acc, per_pix_acc, per_node_acc] = EvalAccuracy(InfL-1, Labels, p_per_sp)

for i = 1 : 10
    [L_out, P_out, i_out, fixed_out] = BoostLI(['./Results/' ResultsDir '/init_file_2f.mat'], ['./Results/' ResultsDir '/output'], L_out,P_out,fixed_out);
    model_chain = [model_chain i_out];
    [InfL trash] = find(L_out');
    [per_class_acc, per_pix_acc, per_node_acc] = EvalAccuracy(InfL-1, Labels, p_per_sp)
end