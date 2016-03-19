function dimensionalAnalysis()


if true 
	% h = combineFitHistories('FitHistory-*-AscFullHistD2thin.mat',true,true);
	% h = combineFitHistories('FitHistory-*-jAscMultiDim.mat',true,true);
	% load('/groups/wilson/FitHistory/jAscMultiDim-path.mat');
	
%	 load('/groups/wilson/FitHistory/jAscMultiDim-endpoints.mat');
%	 scoresByFly = h.scoresByFly;
%	 meanIX = h.meanIX;
%	 load('~/gateSpec/allMetrics.mat');
%	 decPI = allMetrics(:,2);
%	 decPI(find(isnan(decPI))) = 0;

%	load('/groups/wilson/gatePop/gatePopResults-totalPop.mat');
%	newMeanIX = meanIX;
%	newMeanIX(:,1) = meanIX(:,3);
%	newMeanIX(:,3) = meanIX(:,1);
%	meanIX = newMeanIX;

	load('/groups/wilson/gatePop/gatePopResults-totalPop150616.mat');
	newMeanIX = meanIX;
	newMeanIX(:,1) = meanIX(:,3);
	newMeanIX(:,3) = meanIX(:,1);
	meanIX = newMeanIX;

%	load('/groups/wilson/gatePop/gatePopResults-totalPopStarts.mat');
%	newMeanIXs = meanIX;
%	newMeanIXs(:,1) = meanIX(:,3);
%	newMeanIXs(:,3) = meanIX(:,1);
%	scoresByFlyS = scoresByFly;
%	PIs = PI;
%	decPIs = decPI;
%	load('/groups/wilson/gatePop/gatePopResults-totalPopEnds.mat');
%	scoresByFlyE = scoresByFly;
%	scoresByFly = cat(2,scoresByFlyS,scoresByFlyE);
%	PI = PIs;
%	decPI = decPIs;
%	meanIX = newMeanIXs;


	% gateLearn data needs to be stratified by fly
	% load('~/gateLearn/GateScores.mat');
	% [scoresByFly, meanIX] = stratifyByFly(gateScores, sampleIX);
	
	% scoresByFly = h.scoresByFly;
	% meanIX = h.meanIX;



	plotTitle = 'Fit Metrics';
	for mN = 1:size(scoresByFly,2)
		metricLabels{mN} = ['G',num2str(mN,'%03d')];
	end
	scoresByFly = zscore(scoresByFly,0,1);
	classIX = uniqueTypes(meanIX);
else
	plotTitle = 'a priori Metrics';
	load('~/gateSpec/allMetrics.mat');
	scoresByFly = nanZscore(allMetrics);
	ix = find(isnan(scoresByFly)); scoresByFly(ix) = 0;
	meanIX = allMetricIX;
	classIX = uniqueTypes(meanIX);
end

	% Do the signal correlation
	[sigCorr, noiseCorr] = signalCorrelation(scoresByFly, classIX);

	% Resort by the signal auto-correlation
	[B, IX] = sort(diag(sigCorr),'descend');
	% IX = IX(1:nBest);
	sigCorr = sigCorr(IX,IX);
	noiseCorr = noiseCorr(IX,IX);
	scoresByFly = scoresByFly(:,IX);

	n = 1:100;
	[n(:) IX(1:100)]
	gateRawOrder = IX;


	% Display labels
	if false
		disp(' ');
		disp(' ');
		for n = 1:length(IX)
			ordLabels{n} = metricLabels{IX(n)};
			disp(['#:',num2str(n),'  ',ordLabels{n}]);
		end
		disp(' ');
		disp(' ');
		metricLabels = ordLabels;
	end

	ffsubplot(2,3,1);
	image(sigCorr,'CDataMapping','scaled');
	title('Sig. Corr.'); colorbar;
	axis square;

	ffsubplot(2,3,2);
	image(noiseCorr,'CDataMapping','scaled');
	title('Noise Corr.'); colorbar;
	axis square;

	ffsubplot(2,3,3);
	[coeffs,scores,latent,mu,expVar] = signalPCA(scoresByFly,classIX,64);
	plot(latent,'b.-'); hold on;
	xlim([0 10]);

	nPerms = 20;
	nFlies = size(scoresByFly,1);
	allLatents = zeros(nPerms,32);
if false
	for permN = 1:nPerms
		permN
		% Shuffle scores
		shuffledScores = permuteScores(scoresByFly, classIX);
		[scoeffs,sscores,slatent,smu,sexpVar] = signalPCA(shuffledScores,classIX,64);
		allLatents(permN,:) = slatent(1:32);
	end
	for PCn = 1:32
		lIX = round(.05*nPerms);
		uIX = round(.95*nPerms);
		sortedL = sort(allLatents(:,PCn),'ascend');
		lBound(PCn) = sortedL(lIX);
		uBound(PCn) = sortedL(uIX);
	end

	% plot(mean(allLatents,1),'k');
	% plot(lBound,'k--');
	plot(uBound,'k--');

	title(['First 3 PCs: ',num2str(sum(latent(1:3)))]);
	xlim([.5 10.5]);
	xlabel('PC #');
	axis square;

	cumsum(latent(1:5))
end

%	FF = ffsubplot(2,3,3);
%	FF.PDF('FullShuffle.pdf');




	for eigN = 1:4
		V = coeffs(:,eigN);
		[B,IX] = sort(abs(V),'descend');
		disp(['PC #',num2str(eigN)]);
		disp('--------------------');
		for loadN = 1:50
			disp([num2str(V(IX(loadN)),'%+1.3f'),' - #',num2str(IX(loadN)),' - ',metricLabels{IX(loadN)},'  ', num2str(gateRawOrder(IX(loadN)))]);
		end
		disp(' ');
	end

	



	transScoresByFly = scores;
	[transSigCov, transNoiseCov] = signalCovariance(transScoresByFly, classIX);

	ffsubplot(2,3,4);
	image(transSigCov./expVar,'CDataMapping','scaled');
	title('Signal cov. after sigPCA'); colorbar;
	xlim([.5 10.5]);
	ylim([.5 10.5]);
	axis square;

	ffsubplot(2,3,5);
	image(transNoiseCov./expVar,'CDataMapping','scaled');
	title('Noise Cov. after sigPCA'); colorbar;
	axis square;

	FF = ffsubplot(2,3,6);
	image((transSigCov + transNoiseCov)./expVar,'CDataMapping','scaled');
	title('Total cov. after sigPCA'); colorbar;

	FF.setTitle(plotTitle);	

	nullDimension(transScoresByFly, meanIX,scoresByFly,coeffs,sigCorr, decPI, gateRawOrder);

	return;

	figure;
	scatterByPower(transScoresByFly, meanIX,scoresByFly,coeffs,sigCorr, decPI);
	
	figure;
	plotRaster(transScoresByFly, meanIX, decPI);

	function shuffledScores = permuteScores(scoresByFly, classIX)

		nClasses = length(unique(classIX));
		for dimN = 1:size(scoresByFly,2)
			classMapping = randperm(nClasses);
			for destClass = 1:nClasses

				destIXs = find(classIX == destClass);
				sourceClass = classMapping(destClass);
				sourceIXs = find(classIX == sourceClass);
				sourceIX = sourceIXs(randi(length(sourceIXs),length(destIXs),1));
				shuffledScores(destIXs(:),dimN) = scoresByFly(sourceIX(:),dimN);
			end
		end




