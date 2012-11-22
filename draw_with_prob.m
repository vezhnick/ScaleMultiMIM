function n = draw_with_prob(probs)

com_probs = cumsum(probs);
com_probs = com_probs - com_probs(1);
M = max(com_probs);

idx = find( com_probs <= M * rand);

n = idx(end);