function Graph = StandardizeGraph(Graph, Mu, Sigma)

population = full(Graph(Graph > 0));

population = 0.5 + 1/6 * (population - Mu) / Sigma;
population = max(0, population);

Graph(Graph > 0) = population;