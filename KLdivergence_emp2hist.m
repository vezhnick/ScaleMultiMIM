function res = KLdivergence_emp2hist(data, freq)

data_freq = zeros(1,max(data));

for i = 1 : max(data)
    data_freq(i) = sum(data == i);
end

res = KLdivergence(freq, data_freq, 100);