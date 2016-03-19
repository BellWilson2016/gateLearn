function nullDimension( X, meanIX, scoresByFly, coeffs, sigCorr,decPI,gateRawOrder)

	laserPowers = [1,2,4,8,12,16,32,64].*(1.5/64);
	xTicks = [1.5/64, [.045:.015:.15],[.15+.15:.15:1.5]];

	genoList = unique(meanIX(:,3));

	% Find the direction that controls vary in
    genoN = 24;		
	for powerN = 1:8 
		ix = find((meanIX(:,3) == genoN) & (meanIX(:,1) == powerN));
		n1(powerN) = mean(X(ix,1));
		n2(powerN) = mean(X(ix,2));
		n3(powerN) = mean(X(ix,3));
	end
	nullDir = [n1(:),n2(:),n3(:)];
	[coeff, score] = princomp(nullDir);
	nullAx = -coeff(:,1);
	nullAx = nullAx./norm(nullAx);

	% Find the direction orco varies in
    genoN = 18;		
	for powerN = 1:8 
		ix = find((meanIX(:,3) == genoN) & (meanIX(:,1) == powerN));
		o1(powerN) = mean(X(ix,1));
		o2(powerN) = mean(X(ix,2));
		o3(powerN) = mean(X(ix,3));
	end
	orcoDir = [o1(:),o2(:),o3(:)];
	% Remove the component of null variation
	nonNullOrcoDir = orcoDir - ((orcoDir*nullAx)*nullAx');
	% Find the first non-control component of orco, normalized
	[coeff, score] = princomp(nonNullOrcoDir);
	orcoAx = 1*coeff(:,1);
	orcoAx = 1*orcoAx./norm(orcoAx);

	ax2 = -cross(nullAx, orcoAx);

	% nullScore = X(:,[1:3])*nullDir(:);

	figure();
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		
		for powerN = 1:8 
			ix = find((meanIX(:,3) == genoN) & (meanIX(:,1) == powerN));
			t1(powerN) = mean(X(ix,1));
			t2(powerN) = mean(X(ix,2));
			t3(powerN) = mean(X(ix,3));
		end

		T = [t1(:),t2(:),t3(:)];

		% Remove the null variation
		% T = T - ((T*nullAx)*nullAx');

		% Rotate s/t orcoAx is in X, and nullAx is in Y by projecting onto [orcoAx,ax2,nullAx]
		T = [T*orcoAx,T*ax2,T*nullAx];

		ffsubplot(3,2,1);
		plot(T(:,1),T(:,2),'.-','Color',pretty(genoNn)); hold on;
		plot(T(1,1),T(1,2),'o','Color',pretty(genoNn));
		xlabel('Odor Axis'); ylabel('Genotype Axis');

		ffsubplot(3,2,3);
		semilogx(laserPowers,T(:,3),'.-','Color',pretty(genoNn)); hold on;
		semilogx(laserPowers(1),T(1,3),'o','Color',pretty(genoNn));
		xlabel('Laser power'); ylabel('Thermal Axis');
		xlim([.75 96].*1.5/64);
		set(gca,'XTick',xTicks,'XTickLabel',{});

		ffsubplot(3,2,5);
		semilogx(laserPowers,T(:,1),'.-','Color',pretty(genoNn)); hold on;
		semilogx(laserPowers(1),T(1,1),'o','Color',pretty(genoNn));
		xlabel('Laser power'); ylabel('Odor Axis');
		xlim([.75 96].*1.5/64);
		set(gca,'XTick',xTicks,'XTickLabel',{});

		ffsubplot(3,2,6);
		semilogx(laserPowers,T(:,2),'.-','Color',pretty(genoNn)); hold on;
		semilogx(laserPowers(1),T(1,2),'o','Color',pretty(genoNn));
		xlabel('Laser power'); ylabel('Genotype Axis');
		xlim([.75 96].*1.5/64);
		set(gca,'XTick',xTicks,'XTickLabel',{});

%		plot3(T(:,1),T(:,2),T(:,3),'.-','Color',pretty(genoNn)); hold on;
%		plot3(T(1,1),T(1,2),T(1,3),'o','Color',pretty(genoNn));

	end


	orcoAx = orcoAx;
	genoAx = ax2;
	thermalAx = nullAx;
%	save('~/gateLearn/pcAxes.mat','orcoAx','genoAx','thermalAx','coeffs','gateRawOrder');


	% Load this to get genotype names
	load('~/networkDiagrams/grandResults.mat');
	ffsubplot(3,2,4);
	plot(0,0); 
	ylim([-(length(genoList)/2 + 2) 2 ]);
	xlim([-.25 4.25]);
	for genoNn = 1:length(genoList)
		nameString = summaryResults{genoList(genoNn)}{1};
		text(2*floor((genoNn-1)/8),-mod(genoNn-1,8),nameString,'Color',pretty(genoNn));
		hold on;
	end
	set(gca,'XTick',[],'YTick',[]);


	orcoAxScores = X(:,1:3)*orcoAx;
	genoAxScores = X(:,1:3)*ax2;
	thermalAxScores = X(:,1:3)*nullAx;




	ptSize = 16;

	figure;
	ffsubplot(3,2,1);
	scatter(orcoAxScores,genoAxScores,ptSize,decPI(:));
	xlabel('Odor Axis'); ylabel('Genotype Axis');
	title('Color: decPI');
	
	ffsubplot(3,2,3);
	scatter(orcoAxScores,thermalAxScores,ptSize,decPI(:));
	xlabel('Odor Axis'); ylabel('Thermal Axis');
	title('Color: decPI');

	ffsubplot(3,2,4);
	scatter(genoAxScores,thermalAxScores,ptSize,decPI(:));
	xlabel('Genotype Axis'); ylabel('Thermal Axis');
	title('Color: decPI');


	corrMatrix(:,1) = nancorr(scoresByFly,orcoAxScores);
	corrMatrix(:,2) = nancorr(scoresByFly,genoAxScores);
	corrMatrix(:,3) = nancorr(scoresByFly,thermalAxScores);
	corrMatrix(isnan(corrMatrix)) = 0;

	nLoads = 20;
	for dimN = 1:3
		[B,IX] = sort(abs(corrMatrix(:,dimN)),'descend');
		disp(['Dim #',num2str(dimN)]);
		disp('---------------------');
		for loadN = 1:nLoads
			disp(['IX: ',num2str(IX(loadN)),'   ',...
				  'G',num2str(gateRawOrder(IX(loadN))),'   ',...
				  num2str(sigCorr(IX(loadN))),'   ',...
				  num2str(corrMatrix(IX(loadN),dimN))]);
		end
		disp(' ');
		disp(' ');
	end

	figure;
	ffsubplot(1,4,1);
	nScores = 64;
	R = diag(sigCorr);
	h = barh(R(1:nScores),'hist');
	set(h,'EdgeColor','none');
	set(gca,'YDir','reverse');
	title('Reliability');
	ylim([.5 nScores+.5]);
	xlim([0 .55]);

%	ffsubplot(5,1,2);
%	PIcorr = corr(scoresByFly,decPI(:));
%	bar(PIcorr(1:nScores),'hist');
%	title('PIcorr');
%	xlim([.5 nScores+.5]);

	ffsubplot(1,4,2);
	OrcoCorr = corr(scoresByFly,orcoAxScores);
	h = barh(OrcoCorr(1:nScores),'hist');
	set(h,'EdgeColor','none');
	set(gca,'YDir','reverse');
	title('OrcoAx Corr');
	ylim([.5 nScores+.5]);
	
	ffsubplot(1,4,3);
	GenoCorr = corr(scoresByFly,genoAxScores);
	h = barh(GenoCorr(1:nScores),'hist');
	set(h,'EdgeColor','none');
	set(gca,'YDir','reverse');
	title('GenoAx Corr');
	ylim([.5 nScores+.5]);
	
	ffsubplot(1,4,4);
	ThermalCorr = corr(scoresByFly,thermalAxScores);
	h = barh(ThermalCorr(1:nScores),'hist');
	set(h,'EdgeColor','none');
	set(gca,'YDir','reverse');
	title('ThermalAx Corr');
	ylim([.5 nScores+.5]);


	orcoSpec = abs(OrcoCorr)./(abs(GenoCorr) + abs(ThermalCorr));
	genoSpec = abs(GenoCorr)./(abs(OrcoCorr) + abs(ThermalCorr));
	thermalSpec = abs(ThermalCorr)./(abs(OrcoCorr) + abs(GenoCorr));

	ix = find(isnan(orcoSpec)); orcoSpec(ix) = 0;
	ix = find(isnan(genoSpec)); genoSpec(ix) = 0;
	ix = find(isnan(thermalSpec)); thermalSpec(ix) = 0;


	DescMatrix = [[1:length(orcoSpec)]', gateRawOrder(:), OrcoCorr(:),GenoCorr(:),ThermalCorr(:),...
						  orcoSpec(:), genoSpec(:), thermalSpec(:)];
	ix = find(isnan(DescMatrix)); DescMatrix(ix) = 0;

	[B,orcoIX] = sort(orcoSpec,'descend');
	[B,genoIX] = sort(genoSpec,'descend');
	[B,thermalIX] = sort(thermalSpec,'descend');

	disp('Orco Specificity');
	DescMatrix(orcoIX(1:10),:)

	disp('Geno Specificity');
	DescMatrix(genoIX(1:10),:)

	disp('Thermal Specificity');
	DescMatrix(thermalIX(1:10),:)




	% figure;
	% scatter3(OrcoCorr, GenoCorr, ThermalCorr,'o');
