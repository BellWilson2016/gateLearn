function optGateJAscent(subSampleCode, runCode)

	global fitIX;
	global stepNumber;
	vectorHistory = [];
	fHistory = [];

	nSplits = 64;
	rng('shuffle');

	% A unique code to group tested points together
	fitIX = randi(10^15);
	stepNumber = 1;

	% Get initial conditions
	if false
		Go = gateFromRandomSnip(subSampleCode, initialGate());
	elseif false
		Go = gateFromDimAdd(subSampleCode, gateFromPrevGates(['*-',runCode,'.mat']));
	else
		Go = gateFromPrevGates(['*-',runCode,'.mat']);
	end
	plotGate(Go);
	pause(1);
	[x0,lb,ub] = gateToList(Go);

	load(['/groups/wilson/derived/subSample-',subSampleCode,'.mat']);

	% Define an objective function to use
	objFunc = @(x) evalGate(listToGate(x, Go), procTracks, sampleIX, nSplits, runCode);

	stepSizeSeq = [.05,.02,.1];
	minImprovement = .0001;
	maxFevals = 3000;
	jOptimize(objFunc, x0, lb, ub, minImprovement,stepSizeSeq,maxFevals);






