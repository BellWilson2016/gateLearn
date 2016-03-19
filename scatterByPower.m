function scatterByPower( X, meanIX, scoresByFly, coeffs, sigCorr,decPI)

	% Dimensions to find PCodor and PCthermal in
	cDim1 = 1;
	cDim2 = 2;

	ffsubplot(2,2,1);
	for n = 1:8

		ix = find(meanIX(:,1) == (9-n));
		scatter(X(ix,1),X(ix,2),'.','MarkerEdgeColor',pretty(n)); hold on;
	end
	title('PC1/2 Flies, colored by Power');


	ffsubplot(2,2,2);
	genoList = unique(meanIX(:,3));
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		ix = find(meanIX(:,3) == genoN);
		scatter(X(ix,1),X(ix,2),'.','MarkerEdgeColor',pretty(genoNn)); hold on;
	end
	title('PC1/2 Flies, colored by Geno');
	

	X(:,2) = -X(:,2);
	X(:,1) = -X(:,1);
	ffsubplot(2,2,3);

%	load('~/gateSpec/allMetrics.mat');
%	decPI = allMetrics(:,2);
%	decPI(find(isnan(decPI))) = 0;
	scatter(X(:,cDim1),X(:,cDim2),16,decPI); hold on;
%	scatter(X(:,1),X(:,2),16,'b'); hold on;
	caxis([-.3 .8]); axis equal;
	xlims = xlim();
	ylims = ylim();

	ffsubplot(2,2,4);
	genoList = unique(meanIX(:,3));
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		
		for powerN = 1:8 
			ix = find((meanIX(:,3) == genoN) & (meanIX(:,1) == powerN));
			t1(powerN) = mean(X(ix,cDim1));
			t2(powerN) = mean(X(ix,cDim2));
		end

		if (genoN == 24)
			nullDir = [t1(8) - t1(1),t2(8) - t2(1)];

			nullDir = nullDir ./ 4;
			genoDir = [-nullDir(2), nullDir(1)];

			plot([0 nullDir(1)],[0 nullDir(2)],'k');
			plot([0 genoDir(1)],[0 genoDir(2)],'r');
		end

		plot(t1,t2,'.-','Color',pretty(genoNn)); hold on;
		plot(t1(1),t2(1),'o','Color',pretty(genoNn));
	end
	xlim(xlims); ylim(ylims);
	% title('PC1/2 Geno Averages by power');

	nullDir = nullDir./norm(nullDir);
	genoDir = -genoDir./norm(genoDir);

	genoScore = X(:,[cDim1,cDim2])*genoDir(:);
	nullScore = X(:,[cDim1,cDim2])*nullDir(:);
	% load('~/gateSpec/allMetrics.mat');
	% decPI = allMetrics(:,2);
	% decPI(find(isnan(decPI))) = 0;


	% For PC1/3, 2/3, 1/4, 2/4
	figure();
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		
		for powerN = 1:8 
			ix = find((meanIX(:,3) == genoN) & (meanIX(:,1) == powerN));
			t1(powerN) = mean(X(ix,1));
			t2(powerN) = mean(X(ix,2));
			t3(powerN) = mean(X(ix,3));
			t4(powerN) = mean(X(ix,4));
		end

		ffsubplot(3,2,1);
		plot(t1,t2,'.-','Color',pretty(genoNn)); hold on;
		plot(t1(1),t2(1),'o','Color',pretty(genoNn));
		title('1/2');

		ffsubplot(3,2,3);
		plot(t1,t3,'.-','Color',pretty(genoNn)); hold on;
		plot(t1(1),t3(1),'o','Color',pretty(genoNn));
		title('1/3');

		ffsubplot(3,2,4);
		plot(t2,t3,'.-','Color',pretty(genoNn)); hold on;
		plot(t2(1),t3(1),'o','Color',pretty(genoNn));
		title('2/3');

		ffsubplot(3,2,5);
		plot(t1,t4,'.-','Color',pretty(genoNn)); hold on;
		plot(t1(1),t4(1),'o','Color',pretty(genoNn));
		title('1/4');

		ffsubplot(3,2,6);
		plot(t2,t4,'.-','Color',pretty(genoNn)); hold on;
		plot(t2(1),t4(1),'o','Color',pretty(genoNn));
		title('2/4');
	end

	% Load this to get genotype names
	load('~/networkDiagrams/grandResults.mat');
	ffsubplot(3,2,2);
	plot(0,0); 
	ylim([-(length(genoList)/2 + 2) 2 ]);
	xlim([-.25 4.25]);
	for genoNn = 1:length(genoList)
		nameString = summaryResults{genoList(genoNn)}{1};
		text(2*floor((genoNn-1)/8),-mod(genoNn-1,8),nameString,'Color',pretty(genoNn));
		hold on;
	end
	set(gca,'XTick',[],'YTick',[]);

	figure;
	ffsubplot(2,2,1);
	scatter(decPI,genoScore,'.');
	xlabel('PI'); ylabel('PCgenotype Score');
	title(['R = ',num2str(corr(decPI,genoScore))]);
	ffsubplot(2,2,2);
	scatter(decPI,nullScore,'.');
	xlabel('PI'); ylabel('PCthermal Score');
	title(['R = ',num2str(corr(decPI,nullScore))]);

		[B,ix] = max(abs(genoScore));
		genoScore = genoScore*sign(genoScore(ix));

	figure;
	ffsubplot(3,2,1);
	genoList = unique(meanIX(:,3));
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		
		for powerN = 1:8 
			ix = find((meanIX(:,3) == genoN) & (meanIX(:,1) == powerN));
			t1(powerN) = mean(genoScore(ix));
			t2(powerN) = mean(nullScore(ix));
		end

		xVals = [1,2,4,8,12,16,32,64]*1.5/64;
		logLimits = [.75 96]*1.5/64;
		xTicks = [1*1.5/64,[.045:.015:.15],[.15+.15:.15:1.5]];
		xLabels = {'0','','','','','','','.15',...
					   '','','','','','','','','','1.5'};

		ffsubplot(3,2,1); 
		plot(xVals,t1,'Color',pretty(genoNn)); hold on;
		set(gca,'XScale','log'); xlim(logLimits);
		set(gca,'XTick',xTicks,'XTickLabel',xLabels);
		xlabel('Blue Power'); ylabel('PC odor');
		ffsubplot(3,2,2);
		plot(xVals,t2,'Color',pretty(genoNn)); hold on;
		set(gca,'XScale','log'); xlim(logLimits);
		set(gca,'XTick',xTicks,'XTickLabel',xLabels);
		xlabel('Blue Power'); ylabel('PC thermal');
	end

	% OK, plot some loadings
	% Coeffs are 1338 x 64
	figure
	nScores = 100;
	R = diag(sigCorr);
	ffsubplot(4,1,1);
	% plot(R(1:nScores),1:nScores);
	bar(R(1:nScores),'hist');
	title('Reliability');
	xlim([.5 nScores + .5]);

	ffsubplot(4,1,2);
	% load('~/gateSpec/allMetrics.mat');
	% decPI = allMetrics(:,2);
	% decPI(find(isnan(decPI))) = 0;
	PIcorr = corr(scoresByFly,decPI(:));
	size(PIcorr)
	% plot(abs(PIcorr(1:nScores)),1:nScores);
	bar((PIcorr(1:nScores)),'hist');
	title('PIcorr');
	xlim([.5 nScores + .5]);

	ffsubplot(4,1,3);
	genoCoeffs = coeffs(:,1:2)*genoDir(:);
	% plot(abs(genoCoeffs(1:nScores)),1:nScores);
	bar((genoCoeffs(1:nScores)),'hist');
	title('loadings on PCodor');
	xlim([.5 nScores + .5]);

	ffsubplot(4,1,4);
	nullCoeffs = coeffs(:,1:2)*nullDir(:);
	% plot(abs(nullCoeffs(1:nScores)),1:nScores);
	bar((nullCoeffs(1:nScores)),'hist');
	title('loadings on PCthermal');
	xlim([.5 nScores + .5]);

	return;




	ffsubplot(2,2,4);
	genoList = unique(meanIX(:,3));
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		
		for powerN = 1:8
			ix = find((meanIX(:,3) == genoN) & (meanIX(:,1) == powerN));
			t1(powerN) = mean(X(ix,3));
			t2(powerN) = mean(X(ix,4));
		end

		plot(t1,t2,'.-','Color',pretty(genoNn)); hold on;
		plot(t1(1),t2(1),'o','Color',pretty(genoNn));
	end
	title('PC3/4 Geno Averages by power');
