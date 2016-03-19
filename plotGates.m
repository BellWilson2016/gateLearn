function plotGates(gateList, fVals, nRows, nDim)

	dimensionLabels = {'X','Y','dX','dY','sin(T)','cos(T)','dT','Vf','Vs'};

	nGates = length(gateList);
	gateNList = 1:nGates;

	for gateNn = 1:nGates
		gateN = gateNList(gateNn);
		rowN = mod((gateNn - 1),nRows)+1;

		if mod(gateNn,nRows) == 1
			figure();
		end

		G = gateList{gateN};
		dimsUsed = find(G.useDim == 1);

		for dimNn = 1:min(nDim,length(dimsUsed))
			ffsubplot(nRows,nDim,(rowN-1)*nDim + dimNn);
			dimN = dimsUsed(dimNn);
			if G.useDim(dimN) == 1
				samplePeriod = .05;
				tVec = ([1:G.NPoints] - 1).*G.tau./(G.NPoints - 1);
				kPoints = (floor(G.tau/samplePeriod) + 1);
				kTVec = ([1:kPoints] - 1).*G.tau./(kPoints - 1);

				C = interp1(tVec,G.C(dimN,:),kTVec,'pchip');
				W = interp1(tVec,G.W(dimN,:),kTVec,'pchip');

				plot(tVec,G.C(dimN,:),'bo'); hold on;
				plot(tVec,G.C(dimN,:)+G.W(dimN,:),'ko');
				plot(tVec,G.C(dimN,:)-G.W(dimN,:),'ko');

				plot(kTVec,C,'b'); 
				plot(kTVec,C+W,'k--');
				plot(kTVec,C-W,'k--');
				ylabel(dimensionLabels{dimN});
				axis tight;
				ylim(G.boundaryValues(dimN,:));
				title(['G#',num2str(gateN),' sigCorr = ',num2str(abs(fVals(gateN)),'%1.3f')]);
			end
		end

	end	
