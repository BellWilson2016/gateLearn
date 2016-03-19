function negSigCorr = evalGate(aGate, trackMatrix, trackIndexMatrix, nSplits, runCode)

	global fitIX;
	global stepNumber;

	gateScores = applyGateFast(aGate, trackMatrix);
	
	[scoresByFly, meanIX] = stratifyByFly(gateScores(:), trackIndexMatrix);
	classIX = uniqueTypes(meanIX);
	[sigCorr, noiseCorr] = signalCorrelation(scoresByFly, classIX);
	negSigCorr = -sigCorr;

	fileName = ['/groups/wilson/FitHistory/FitHistory-',num2str(fitIX,'%d'),'-',runCode,'.mat'];
	a = dir(fileName);
	if length(a) > 0
		% Robustly try to load the file
		robustLoad(fileName,8);
	else
		allScoresByFly = [];
		allGates = {};
		allFvals = [];
		allFitIX = [];
		allStepNum = [];
	end

	allScoresByFly = cat(2,allScoresByFly,scoresByFly(:));
	allGates{end+1} = aGate;
	allFvals(end+1) = negSigCorr;
	allFitIX(end+1) = fitIX;
	allStepNum(end+1) = stepNumber;

	% Robust save
	nTries = 4;
	robustSave(fileName, nTries, 'allScoresByFly','allGates','allFvals','allFitIX','allStepNum','meanIX');


