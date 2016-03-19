function scores = applyGateFast(G, tM)

	samplePeriod = .05;
	plotOn = false;

	% Only use selected dims for calculating gate
	dimsToUse = find(G.useDim == 1);
	tM = tM(:,:,dimsToUse);
	nDim = length(dimsToUse);

	% Debug
	debug = false;
	if debug
		tM = zeros(size(tM,1),size(tM,2),size(tM,3));
		tM(1,1:100,1) = 1:100;
	end

	% Interpolate gate kernels to high-res for usable dims
	for dimNn = 1:nDim
		dimN = dimsToUse(dimNn);

		tVec = ([1:G.NPoints] - 1).*G.tau./(G.NPoints - 1);
		kPoints = (floor(G.tau/samplePeriod) + 1);
		kTVec = ([1:kPoints] - 1).*G.tau./(kPoints - 1);
		Ckernel(dimNn,:) = interp1(tVec,G.C(dimN,:),kTVec,'pchip');
		Wkernel(dimNn,:) = interp1(tVec,G.W(dimN,:),kTVec,'pchip');

		% plot(kTVec, Ckernel(dimN,:),'r'); hold on;
		% plot(tVec, G.C(dimN,:),'bo');
	end

	maxVals = (Ckernel + Wkernel)';
	minVals = (Ckernel - Wkernel)';

	nTracks  = size(tM,1);
	nSamples = size(tM,2);
	kWidth   = size(Ckernel,2);
	nLags = nSamples - kWidth + 1;

	% Construct maxShiftMatrix
	maxVals = reshape(maxVals,1,kWidth,nDim);
	minVals = reshape(minVals,1,kWidth,nDim);
	maxShiftMatrix = repmat(maxVals,nLags,1,1);
	minShiftMatrix = repmat(minVals,nLags,1,1);

	% Generate an indexing matrix for calculating lags
	sampSt = 1:nSamples;
	sqIX = fliplr(toeplitz(circshift(sampSt(:),1),flipud(sampSt(:))));
	sqIX = sqIX(1:nLags,1:kWidth);

	scores = zeros(nTracks,1);
	tShiftMatrix = zeros(nLags, kWidth, nDim);
	% For each track, find and score violations
	for trackN = 1:nTracks

		% Construct a tShiftMatrix
		tShiftMatrix = tM(trackN,sqIX,:);
		tShiftMatrix = reshape(tShiftMatrix,nLags,kWidth,nDim);

		violations = ((tShiftMatrix > maxShiftMatrix) |...
					  (tShiftMatrix < minShiftMatrix));
		violations = reshape(violations,nLags,kWidth*nDim);
		scores(trackN) = 1 - nnz(any(violations,2))/nLags;
		
	end		

