function G = gateFromPrevGates(wildcard)

	fitDir = '/groups/wilson/FitHistory/';
	matchingFiles = dir([fitDir,wildcard]);

	% Load files until there's a non-zero Fval
	bestF = 0;
	while (bestF == 0)
		fileN = randi(length(matchingFiles)); 

		robustLoad([fitDir,matchingFiles(fileN).name],8);
		[bestF, bestIX] = min(allFvals);
		G = allGates{bestIX};
	end
