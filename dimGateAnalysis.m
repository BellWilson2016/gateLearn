function dimGateAnalysis()

if false
	load('~/gateLearn/GateScores.mat');
	[scoresByFly, meanIX] = stratifyByFly(gateScores, sampleIX);

	classIX = uniqueTypes(meanIX);
	[sigCorr, noiseCorr] = signalCorrelation(scoresByFly, classIX, 128);
	autoCorr = abs(diag(sigCorr));

	flyScores = scoresByFly';
	size(flyScores)
	flyScores = zscore(flyScores,0,1);

	X = fast_tsne(flyScores,100,30,.2);

	scatter(X(:,1),X(:,2),9,autoCorr(:));
	colorbar
end

load('~/gateLearn/FitHistory-AscFullHist.mat');

	fVals = allFvals;

	for gateN = 1:length(fVals)
		fullGateVectors(gateN,:) = gateToFullList(allGates{gateN});
	end
	size(fullGateVectors)

	X = fast_tsne(fullGateVectors,100,3,.2);
	% [coeff, scores, latent] = princomp(gateVectors);
	% plot(cumsum(latent)./sum(latent),'b.-');
	% X = scores(:,1:2);
	% figure

	scatter(X(:,1),X(:,2),16,abs(fVals(:)));
	colorbar
