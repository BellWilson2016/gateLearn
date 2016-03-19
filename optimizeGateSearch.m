function optimizeGateSearch(subSampleCode, runCode)

	nSplits = 64;
	rng('shuffle');

	% Get initial conditions
	Go = gateFromRandomSnip(subSampleCode, initialGate);
	[x0,lb,ub] = gateToList(Go);

	load(['~/derived/subSample-',subSampleCode,'.mat']);

	% Define an objective function to use
	objFunc = @(x) evalGate(listToGate(x, Go), procTracks, sampleIX, nSplits);

	options = optimset('Display','iter','FunValCheck','off',...
					   'TolFun',10^-5,'TolX',10^-3,...
					   'MaxFunEvals', 500,...
					   'OutputFcn', @outFcn);
	
	[x, fval, exitflag, output] = fminsearch(objFunc, x0, options);

	% Save the data...
	fileName = ['~/gateLearn/FitGates-',runCode,'.mat'];
	a = dir(fileName);
	if length(a) > 0
		load(fileName);
	else
		gateVectors = [];
		fVals = [];
		gTemplates = [];
	end
	gateVectors = cat(1,gateVectors,x(:)');
	fVals = cat(1,fVals,fval);
	gTemplates = cat(1,gTemplates,Go);

	save(fileName,'gateVectors','fVals','runCode','gTemplates');

	function stop = outFcn(x, optimValues, state)

		stop = false;
		disp(x(:)');


	


