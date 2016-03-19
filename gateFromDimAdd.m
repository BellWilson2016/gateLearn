function Go = gateFromDimAdd(subSampleCode, gateInput)

	rng('shuffle');
	samplePeriod = .05;

	% If we pass in a string, load it as a file
	if ischar(gateInput)
		gateFile = gateInput;
		% Pick an existing gate from the gateFile as a starting point
		load(gateFile);
		nGates = size(gTemplates,1);
		startingGateN = randi(nGates);
		Go = listToGate(gateVectors(startingGateN,:),gTemplates(startingGateN));
	% Otherwise, assume it's a gate
	else
		Go = gateInput;
	end
	
	% Load the subSample to get some sample tracks
	load(['~/derived/subSample-',subSampleCode,'.mat']);
	sampleTracks = procTracks;
	nTracks = size(sampleTracks,1);

	% Find gateAcceptances in the dataset
	% Pick a start segment based on them
	gateAcceptance = applyGateFastDetail(Go, procTracks);
	if nnz(gateAcceptance(:)) > 0
		trackHits = find(any(gateAcceptance,2));
		trackN = trackHits(randi(length(trackHits)));
		trackAcceptance = gateAcceptance(trackN,:);
		onSamples = find(trackAcceptance == 1);
		stSamp = onSamples(randi(length(onSamples)));
	else
		% If there aren't actually any matches...
		% Pick a random spot
		trackN = randi(size(procTracks,1));
		stSamp = randi(size(procTracks,2));
	end

	% Create a vector of points
	tSamples = round(Go.tau/samplePeriod);
	ptVec = round(linspace(0,tSamples,Go.NPoints));
	
	% Pick a new dimension to use	
	% Sample it from the chosen snippet, knock width down to 1/2
	unusedDims = find(Go.useDim == 0);
	newDim = unusedDims(randi(length(unusedDims)));
	Go.useDim(newDim) = 1;
	Go.C(newDim,:) = sampleTracks(trackN,stSamp+ptVec,newDim);
	Go.W(newDim,:) = Go.W(newDim,:)./(2^(randi(3)));

	debug = false;
	if debug
		dimsUsed = find(Go.useDim == 1);
		NdimsUsed = length(dimsUsed);
		plotGate(Go); 
		for dimNn = 1:NdimsUsed
			dimN = dimsUsed(dimNn);
			subplot(1,NdimsUsed,dimNn); hold on;
			plot([0:tSamples].*samplePeriod,procTracks(trackN,stSamp+[0:tSamples],dimN),'r');
		end
	end


