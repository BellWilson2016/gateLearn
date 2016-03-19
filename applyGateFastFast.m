function scores = applyGateFastFast(G, tM)

	samplePeriod = .05;
	plotOn = false;

	% Only use selected dims for calculating gate
	dimsToUse = find(G.useDim == 1);
	tM = tM(:,:,dimsToUse);
	nDim = length(dimsToUse);

	% Debug
	debug = true;
	if debug
		tM = zeros(size(tM,1),size(tM,2),size(tM,3));
		tM(1,1:100,1) = 1:100;
		tM = tM(1:200,:,:);
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
	maxVals = reshape(maxVals,1,1,kWidth,nDim);
	minVals = reshape(minVals,1,1,kWidth,nDim);
	maxShiftMatrix = repmat(maxVals,nLags,nTracks,1,1);
	minShiftMatrix = repmat(minVals,nLags,nTracks,1,1);

	tic

		% Construct a tShiftMatrix
		sampSt = 1:nSamples;
		sqIX = fliplr(toeplitz(circshift(sampSt(:),1),flipud(sampSt(:))));
		sqIX = sqIX(1:nLags,1:kWidth);
		sq2 = reshape(sqIX,1,nLags,kWidth);
		bigLags = repmat(sq2,nTracks,1,1);

		size(bigLags)

		tracks2 = reshape(1:nTracks,nTracks,1,1);
		bigTracks = repmat(tracks2,1,nLags,kWidth);

		size(bigTracks)

		tShiftMatrix = tM(:,bigLags,:);
		tShiftMatrix = reshape(tShiftMatrix,nTracks,nLags,kWidth,nDim);

		size(tShiftMatrix)

		violations = ((tShiftMatrix > maxShiftMatrix) |...
					  (tShiftMatrix < minShiftMatrix));
		violations = reshape(violations,nLags,kWidth*nDim);
		scores(trackN) = 1 - nnz(any(violations,2))/nLags;
		
	toc

