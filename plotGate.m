function plotGate(G)

		G

		samplePeriod = .05;
		tVec = ([1:G.NPoints] - 1).*G.timeScale./(G.NPoints - 1);
		kPoints = (floor(G.timeScale/samplePeriod) + 1);
		kTVec = ([1:kPoints] - 1).*G.timeScale./(kPoints - 1);

		dimLabels = {'X','Y','dX','dY','sin(T)','cos(T)','dT','Vf','Vs'};

	dimsUsed = find(G.useDim == 1);
	NdimsUsed = length(dimsUsed);

	for dimNn = 1:NdimsUsed
		dimN = dimsUsed(dimNn);
		ffsubplot(4,3,dimNn);

		C = interp1(tVec,G.C(dimN,:),kTVec,'pchip');
		W = interp1(tVec,G.W(dimN,:),kTVec,'pchip');

%		plot(tVec,G.C(dimN,:),'bo'); hold on;
		fill([kTVec,fliplr(kTVec)],[C+W,fliplr(C-W)],[.8 .8 .8],'EdgeColor','none'); hold on;
		plot(tVec,G.C(dimN,:)+G.W(dimN,:),'k.'); hold on;
		plot(tVec,G.C(dimN,:)-G.W(dimN,:),'k.');

		plot(kTVec,C,'b'); hold on;
%		plot(kTVec,C+W,'k--');
%		plot(kTVec,C-W,'k--');

		ylabel(dimLabels{dimN});
		axis tight;
		ylim(G.boundaryValues(dimN,:).*1.1);

	end	
