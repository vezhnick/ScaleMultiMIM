function res = KLdivergence_emp2emp(data1, data2)

data1_freq = zeros(1,max(data1));
data2_freq = zeros(1,max(data2));

for i = 1 : max(max(data1,data2))
    data1_freq(i) = sum(data1 == i);
    data2_freq(i) = sum(data2 == i);
end

res = KLdivergence(data1_freq, data2_freq, 100);