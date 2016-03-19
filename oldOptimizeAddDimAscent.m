function oldOptimizeAddDimAscent(subSampleCode, runCode)

	global vectorHistory;
	global fHistory;
	vectorHistory = [];
	fHistory = [];

	nSplits = 64;
	rng('shuffle');

	% Get initial conditions
	Go = gateFromDimAdd(subSampleCode, '~/gateLearn/FitGates-Ascent.mat');
	[x0,lb,ub] = gateToList(Go);

	load(['~/derived/subSample-',subSampleCode,'.mat']);

	% Define an objective function to use
	objFunc = @(x) evalGate(listToGate(x, Go), procTracks, sampleIX, nSplits);

	options = optimoptions(@fmincon, 'Algorithm','sqp',...
							'MaxFunEvals',3000,'Diagnostics','off',...
							'Display','iter',...
							'DiffMaxChange',.2,'DiffMinChange',.01,...
							'FinDiffRelStep',.01,...
							'TolX',10^-3,...
							'TolFun',10^-5,...
							'TypicalX',ub./2,...
							'FunValCheck','off',...
							'OutputFcn',@outFcn);

	[x, fval, exitflag, output, lambda, grad, hessian] = fmincon(objFunc, x0,...
			[],[],[],[],...
			lb, ub,[],options);

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
	fVals = cat(1,fVals, fval);
	gTemplates = cat(1,gTemplates,Go);

	save(fileName,'gateVectors','fVals','runCode','gTemplates');


function stop = outFcn(x, optimValues, state)

	global fHistory;
	global vectorHistory;
	stop = false;

	fHistory = cat(1,fHistory,optimValues.fval);
	vectorHistory = cat(1,vectorHistory,x(:)');

	clf;
	subplot(1,2,1);
	plot(abs(fHistory),'bo-'); xlabel('Iteration'); ylabel('Sig. Corr.');

	subplot(1,2,2);
	[coeff,X] = princomp(vectorHistory);
	plot(X(:,1),X(:,2),'.-'); hold on;
	plot(X(1,1),X(1,2),'o');





