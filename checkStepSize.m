function checkStepSize(wildcard, remDiffs)

	h = combineFitHistories(wildcard,remDiffs,false);

	nGates = length(h.gates);

	for gateN = 1:nGates
		gateVector(gateN,:) = gateToList(h.gates{gateN});
	end

	gateVector
	incDiff = diff(gateVector);
	incDiff
	diffMag = sqrt(sum(incDiff.^2,2));
	diffMag

	hist(diffMag,round(4*sqrt(length(diffMag))));
