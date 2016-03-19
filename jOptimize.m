%%
%	Fixed step-size gradient descent minimizer
%
function jOptimize(objFunc, x0, lb, ub, minImprovement, stepSizes, maxEvals)

	global nEvals;
	nEvals = 0;
	global stepNumber;
	stepNumber = 0;

	% Define a wrapper function so we can count evals
	testFunc = @(x) runObj(x, objFunc);

	% Get the number of dimensions, start with the first step size
	nDim = length(x0);
	nStepSizes = length(stepSizes);
	stepSizeN = 1;

	% Calculate the initial start point
	currX = protectBounds(x0,lb,ub);
	currF = testFunc(currX);
	bestF = currF;
	bestX = currX;

	% Print the output headers to the console window
	printStatusLine(stepNumber, currF, nEvals, stepSizes(stepSizeN),' ');

	% If we haven't done too many evals or exhausted our 
	% step sizes without improvement, keep going!
	while ((nEvals < maxEvals) & (stepSizeN <= nStepSizes))
		stepNumber = stepNumber + 1;

		setOfTestX = [];
		setOfTestF = [];
		% Calculate gradient
		for dimN = 1:nDim
			testX = currX;
		    testX(dimN)	= testX(dimN) + stepSizes(stepSizeN);
			testX = protectBounds(testX,lb,ub);
			testF = testFunc(testX);
			setOfTestX(end+1,:) = testX(:);
			setOfTestF(end+1) = testF;
			grad(dimN) = (testF - currF)/stepSizes(stepSizeN);
		end

		% Always try the composite gradient, in case of negative 
		% partial derivatives
		% Calculate a composite step down the gradient
		compX = currX(:) - grad(:)*stepSizes(stepSizeN)/norm(grad);
		compX = protectBounds(compX,lb,ub);
		setOfTestX(end+1,:) = compX;
		setOfTestF(end+1) = testFunc(compX);

		% Find the best testX from the current tested set
		[setMinF, bestSetIX] = min(setOfTestF);
		% If there's enough improvement over the current point, use it
		if (setMinF < (currF - abs(minImprovement)))
			currF = setOfTestF(bestSetIX);
			currX = setOfTestX(bestSetIX,:);
			bestF = currF;
			bestX = currX;
			% Figure if we chose a composite step
			if (bestSetIX == length(setOfTestF))
				stepKind = 'C';
			else
				stepKind = num2str(bestSetIX);
			end
			printStatusLine(stepNumber, currF, nEvals, stepSizes(stepSizeN),stepKind);
			% Since we stepped, bump the step-size back to the first size
			stepSizeN = 1;
		% If we couldn't find enough improvement, try a different step-size
		else
			stepKind = 'X';
			printStatusLine(stepNumber, currF, nEvals, stepSizes(stepSizeN),stepKind);
			stepSizeN = stepSizeN + 1;
		end
	end

	% Run the objective function one last time on the best X
	% to make sure it's in the logs.
	testFunc(bestX);

	% If we exited because we ran out of step sizes, we're at a plateau
	if (stepSizeN > nStepSizes)
		stepKind = 'Fplateau';
		sSize = stepSizes(end);
	% Otherwise we must have reached our limit of function evals
	else
		stepKind = 'FmaxEvals';
		sSize = stepSizes(stepSizeN);
	end
	printStatusLine(stepNumber, currF, nEvals, sSize, stepKind);

function printStatusLine(nRounds, currF, nEvals, stepSize, stepKind)

	if (nRounds == 0)
		disp('                                                       ');
		disp('       Fixed Step Steepest Descent Minimizer           ');
		disp('                                                       ');
		disp(' Iter #:      f(x):   nEvals:   Step size:   Step kind:');
		disp('--------------------------------------------------------');
		disp([' ',sprintf('%7d',nRounds),'    ',sprintf('%6.4f',currF),'    ',...
		  sprintf('%6d',nEvals),'       ','      ','     ','  x0  ']);
	else
		disp([' ',sprintf('%7d',nRounds),'    ',sprintf('%6.4f',currF),'    ',...
		  sprintf('%6d',nEvals),'       ',sprintf('%6.4f',stepSize),'        ',stepKind]);
	end


function val = runObj(x, objFunc)

	global nEvals;
	val = objFunc(x);
	nEvals = nEvals + 1;

function x = protectBounds(x,lb, ub)

	ix = find(x(:) < lb(:));
	x(ix) = lb(ix);
	ix = find(x(:) > ub(:));
	x(ix) = ub(ix);



