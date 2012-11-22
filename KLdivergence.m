function res = KLdivergence(p,q,reg)

p = (p + reg )/ sum(p + reg);
q = (q + reg )/ sum(q + reg);
res = p * log(p./q)';