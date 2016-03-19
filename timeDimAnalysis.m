function timeDimAnalysis()

	load('/groups/wilson/gatePop/gatePopResults-totalPop150616preEpoch.mat');
	newMeanIX = meanIX;
	newMeanIX(:,1) = meanIX(:,3);
	newMeanIX(:,3) = meanIX(:,1);
	meanIX = newMeanIX;

	load('~/gateLearn/pcAxes.mat');

	scoreList = scoreList(:,gateRawOrder);
	scoreList = nanZscore(scoreList);
	ix = find(isnan(scoreList)); scoreList(ix) = 0;

	pcScores = scoreList*coeffs(:,1:3);
	odorScores = pcScores*orcoAx;
	genoScores = pcScores*genoAx;
	thermalScores = pcScores*thermalAx;

	plotScore = genoScores;

	allGenos = unique(genoList);
	for genoNn = 1:length(allGenos)
		genoN = allGenos(genoNn);
		for t = 1:128
			ix = find((genoList == genoN) &...
					  (allTrackIndex(:,4) == t));
			resp(t) = mean(plotScore(ix));
		end
		plot(1:128,resp,'Color',pretty(genoNn)); hold on;
	end

%	for p=1:8
%		ix = find((genoList == 18) & (allTrackIndex(:,1) == p));
%		resp(p) = mean(odorScores(ix));
%	end
%	resp
%	plot([1:8],resp,'b'); hold on;
%
%	for p=1:8
%		ix = find((genoList == 24) & (allTrackIndex(:,1) == p));
%		resp(p) = mean(odorScores(ix));
%	end
%	resp
%	plot([1:8],resp,'k');
