function Go = gateFromRandomSnip(subSampleCode, Gtemplate)

	rng('shuffle');

	Go = Gtemplate;
	% Go.NPoints;
	% Go.timeScaleRange;
	% Go.useDim
	samplePeriod = .05;

	% Log-distribute time scales
	logTau = (log(Go.timeScaleRange(2)) - log(Go.timeScaleRange(1)))*rand() +...
				log(Go.timeScaleRange(1));
	Go.tau = exp(logTau);
	tSamples = round(Go.tau/samplePeriod);

	load(['~/derived/subSample-',subSampleCode,'.mat']);
	sampleTracks = procTracks;
	nTracks = size(sampleTracks,1);
	% Select a random track
	trackN = randi(nTracks);
	% Select a random start time
	stSamp = randi(size(sampleTracks,2) - tSamples + 1);
	ptVec = round(linspace(0,tSamples,Go.NPoints));

	% Pick random trace dimensions to use (up to 4)
	nDimsToUse = randi(4);
	dims = zeros(Go.Ndim,1); dims(1:nDimsToUse) = 1;
	Go.useDim = dims(randperm(Go.Ndim));

	% Take the trace values as the center, knock the width down to 1/2
	for dimN = 1:Go.Ndim
		if (Go.useDim(dimN) == 1)
			Go.C(dimN,:) = sampleTracks(trackN,stSamp+ptVec,dimN);
			Go.W(dimN,:) = Go.W(dimN,:)./(2^(randi(3)));
		end
	end

	debug = true;
	if debug
		plotGate(Go);
		dimsToUse = find(Go.useDim);
		for dimNn = 1:length(dimsToUse)
			dimN = dimsToUse(dimNn);
			subplot(1,nDimsToUse,dimNn); hold on;
			plot([0:tSamples].*samplePeriod,sampleTracks(trackN,stSamp+[0:tSamples],dimN),'r');
		end
	end


