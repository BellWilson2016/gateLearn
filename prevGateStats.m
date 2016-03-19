function prevGateStats(wildcard)

	fitDir = '~/gateLearn/FitHistory/';
	matchingFiles = dir([fitDir,wildcard]);

	nDims = [];
	nSteps = [];

	for fileN = 1:length(matchingFiles)
		robustLoad([fitDir,matchingFiles(fileN).name],3);
		G = allGates{end};
		nSteps(end+1) = min(allFvals);
		nDims(end+1) = nnz(G.useDim);
	end

	scatter(nDims,nSteps,'bo');
	xlabel('nDims'); ylabel('bestF');
		
