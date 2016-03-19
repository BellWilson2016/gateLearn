function scores = runGates()

	% NbestGates = 200;

%	gateFiles = {'~/gateLearn/FitGates-Xwhole.mat',...
%				 '~/gateLearn/FitGates-XwholeSearch.mat',...
%				 '~/gateLearn/FitGates-XwholeSmooth.mat'};
	gateFiles = {'~/gateLearn/FitGates-AscentD2.mat'};
	
	allFvals = [];
	allVec = [];
	allTemplates = [];
	for fileN = 1:length(gateFiles)
		load(gateFiles{fileN});
		allFvals = cat(1,allFvals,fVals);
		allVec   = cat(1,allVec,gateVectors);
		allTemplates = cat(1,allTemplates,gTemplates);
	end
	fVals = allFvals;
	gateVectors = allVec;
	gTemplates = allTemplates;

	[B, IX] = sort(fVals,'ascend');
	fVals = fVals(IX);
	gateVectors = gateVectors(IX,:);

	gateOrderList = [1:length(fVals)];

	load('~/derived/subSample-SingleSmoothMid.mat');

	gateScores = zeros(size(procTracks,1),length(gateOrderList));
	[B, gateOrder] = sort(fVals,'ascend');

	for gateNnn = 1:length(gateOrderList)
		gateNn = gateOrderList(gateNnn)
		gateN = gateOrder(gateNn);
	
		x = gateVectors(gateN, :);
		G = listToGate(x, gTemplates(gateN));

		gateScores(:,gateNnn) = applyGateFast(G, procTracks);
	end

	save('~/gateLearn/GateScores.mat','gateScores','sampleIX','gateVectors','fVals');



