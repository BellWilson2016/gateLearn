function plotRepGates(gateList, fVals)

	nPeaks = 5;

	[B,IX] = sort(abs(fVals),'descend');

	[N,C] = hist(B,100);
	[Ns,hIX] = sort(N,'descend');
	histPeaks = sort(C(hIX(1:nPeaks)),'descend')

	for peakN=1:length(histPeaks)
		peakLoc = histPeaks(peakN);
		cIX = dsearchn(B(:),peakLoc);
		gateIXtoPlot = IX([(cIX-4):(cIX+5)]);
		for gateNn = 1:length(gateIXtoPlot)
			subGates{gateNn} = gateList{gateIXtoPlot(gateNn)};
		end
		subF = fVals(gateIXtoPlot);

		plotGates(subGates,subF,5,2);

	end
	


