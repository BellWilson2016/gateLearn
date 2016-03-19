function embedGateHistory()

		perplexity = 30;
		theta = .5;
		initialDims = 100;
		onlyBestOfStep = true;
		onlyLastStep = false; 

		% h = combineFitHistories('FitHistory-*-jAscMultiDim.mat',onlyBestOfStep,onlyLastStep);
		% h = combineFitHistories('FitHistory-*-AscFullHistD2thin.mat',onlyBestOfStep,onlyLastStep);

		load('/groups/wilson/FitHistory/jAscMultiDim-endpoints.mat');
		% load('/groups/wilson/FitHistory/jAscMultiDim-path.mat');

		fVals = h.fVals;
		allGates = h.gates;
		allFitIX = h.fitIX;
		allStepNum = h.stepN;
		allScoresByFly = h.scoresByFly;	
		size(allGates)
		
		% Make a vector representation of gates
		for gateN = 1:length(fVals)
			fullGateVectors(gateN,:) = gateToFullList(allGates{gateN});
		end

		% Score fly, and flip sign of metrics to correlate with best gate
		if (true)
			zScoreByFly = zscore(allScoresByFly,0,1);
			[B,bestIX] = max(abs(fVals));
			classIX = uniqueTypes(h.meanIX);
			for gateN = 1:size(zScoreByFly,2)
				aGate = zScoreByFly(:,gateN);
				bestGate = zScoreByFly(:,bestIX);
				% [sigCorr, noiseCorr] = signalCorrelation([aGate,bestGate], classIX, 4);
				sigCorr = corr([aGate,bestGate]);
				zScoreByFly(:,gateN) = sign(sigCorr(1,2)).*zScoreByFly(:,gateN);
			end
		end


		ffsubplot(1,1,1);
		% embedQty = fullGateVectors;
		 embedQty = zScoreByFly';
		 ix = find(isnan(embedQty));
		 embedQty(ix) = 0;
		X = fast_tsne(embedQty, initialDims, perplexity, theta);
		% [coeff, score] = princomp(embedQty);
		% X = score(:,1:2);
		plotEmbedding(X, fVals, allFitIX, allStepNum, allGates);
		title('tSNE embedding by fly scores jAsc2D1');


function plotEmbedding(X, fVals, allFitIX, allStepNum, allGates)

	markerSize = 16;

	plotFromClick = @(obj,event) clickFcn(obj, event, X, fVals, allGates);

	% scatter(X(:,1),X(:,2),markerSize,abs(fVals(:)),'ButtonDownFcn',plotFromClick); hold on;

	fitList = unique(allFitIX);
	for fitNn = 1:length(fitList)
		fitN = fitList(fitNn);

		ix = find(allFitIX == fitN);
		stepList = unique(allStepNum(ix));
		bigX = [];

		for stepNn = 1:length(stepList)
			stepN = stepList(stepNn);

			ix = find((allFitIX == fitN) & (allStepNum == stepN));
			[B, ixx] = max(abs(fVals(ix)));
			bigX(stepNn,1) = X(ix(ixx),1);
			bigX(stepNn,2) = X(ix(ixx),2);
		end

		plot(bigX(:,1),bigX(:,2),'k-'); hold on;
		% scatter(bigX(end,1),bigX(end,2),markerSize,abs(B),'filled');
	end

	set(gca,'ButtonDownFcn',plotFromClick); 
	scatter(X(:,1),X(:,2),markerSize,abs(fVals(:)),'filled','ButtonDownFcn',plotFromClick); hold on;
	colorbar;



function clickFcn(obj, event, X, fVals, allGates)

	coords = get(gca,'CurrentPoint');
	click = coords(1,1:2);

	ix = dsearchn(X, click);
	figure();
	aGate = allGates{ix};
	plotGate(aGate);
	sigString = ['sigCorr = ',num2str(abs(fVals(ix)))];
	disp(sigString);
	title(sigString);
	Po = get(gcf,'Position');
	plotSize = 180;
	%set(gcf,'Position',[Po(1),Po(2),plotSize*nnz(aGate.useDim),plotSize]);
