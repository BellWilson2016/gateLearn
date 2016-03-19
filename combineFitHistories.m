function h = combineFitHistories(histWildcard, onlyBestOfStep, onlyLastStep)

	histDir = '/groups/wilson/FitHistory/';

	h.fVals = [];
	h.gates = {};
	h.scoresByFly = [];
	h.fitIX  = [];
	h.stepN = [];
	h.bestStep = onlyBestOfStep;
	h.lastStep = onlyLastStep;
	h.meanIX = [];

	% Collect fit histories from many runs...
	histList = dir([histDir,histWildcard]);
	for histN = 1:length(histList)
		
		allFitIX = [];
		disp(histList(histN).name);
		robustLoad([histDir,histList(histN).name],2);

		% Collect only best best value from each step (and throw out all the gradient evals)
		if (onlyBestOfStep)
			fitList = unique(allFitIX);
			bestIXlist = [];
			for fitNn = 1:length(fitList)
				fitN = fitList(fitNn);

				ix = find(allFitIX == fitN);
				stepList = unique(allStepNum(ix));

				if (~onlyLastStep)
					stepSeq = 1:length(stepList);
				else
					stepSeq = length(stepList);
				end
				for stepNn = stepSeq
					stepN = stepList(stepNn);

					ix = find((allFitIX == fitN) & (allStepNum == stepN));
					[B, ixx] = min(allFvals(ix));
					bestIXlist(end+1) = ix(ixx);
				end
			end

			subGates = {};
			for n=1:length(bestIXlist)
				subGates{n} = allGates{bestIXlist(n)};
			end
			allGates = subGates;
			allFvals = allFvals(bestIXlist);
			allScoresByFly = allScoresByFly(:,bestIXlist);
			allFitIX = allFitIX(bestIXlist);
			allStepNum = allStepNum(bestIXlist);
		end

		if length(allFitIX) > 0
			h.fVals = cat(2,h.fVals,allFvals); 
			h.gates = cat(2,h.gates,allGates); 
			h.scoresByFly = cat(2,h.scoresByFly,allScoresByFly); 
			h.fitIX = cat(2,h.fitIX,allFitIX);
			h.stepN = cat(2,h.stepN,allStepNum);
			h.meanIX = meanIX;
		end

	end


