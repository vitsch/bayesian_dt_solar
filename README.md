Bayesian averaging over Decition Tree models with Markov Chain Monte Carlo

Matlab scripts and functions: 
	bdt_main
    prop_ratio
    mc_load_data
    mc_split
	mc_log_lik
	mc_create_move
	mc_shrink
	mc_prop_ratio
	mc_prob
	mc_test
	mc_rpt

The script has been used for interpretation of solar flares from UCI ML repository https://archive.ics.uci.edu/ml/datasets/Solar+Flare. 

Details are given in the book chapter V. Schetinin, V. Zharkova and S. Zharkov "Bayesian Decision Tree Averaging for the Probabilistic Interpretation of Solar Flare Occurrences", In: Knowledge-Based Intelligent Information and Engineering Systems. Lecture Notes in Computer Science Volume 4253, 2006, pp 523-53, http://link.springer.com/chapter/10.1007%2F11893011_67. 

Abstract

Bayesian averaging over Decision Trees (DTs) allows the class posterior probabilities to be estimated, while the DT models are understandable for domain experts. The use of Markov Chain Monte Carlo (MCMC) technique of stochastic approximation makes the Bayesian DT averaging feasible. In this paper we describe a new Bayesian MCMC technique exploiting a sweeping strategy allowing the posterior distribution to be estimated accurately under a lack of prior information. In our experiments with the solar flares data, this technique has revealed a better performance than that obtained with the standard Bayesian DT technique.


