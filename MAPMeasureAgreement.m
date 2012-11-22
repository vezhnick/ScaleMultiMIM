function MAPMeasureAgreement(init_file_name, alpha_idx, output_file_name)

alpha_idx = str2num(alpha_idx);

load(init_file_name);

results =  MeasureAgreement(Files, features_names, ImIdxA, ImIdxB, K,L, alpha{alpha_idx});

save(output_file_name, 'results');