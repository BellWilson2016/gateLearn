function scores = applyGate(G, tM)

	samplePeriod = .05;
	plotOn = false;

	% Only use selected dims for calculating gate
	dimsToUse = find(G.useDim == 1);
	tM = tM(:,:,dimsToUse);

	% Interpolate gate kernels to high-res for usable dims
	for dimNn = 1:length(dimsToUse)
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

tic

	nSamples = size(tM,2);
	kWidth   = size(Ckernel,2);
	nLags = nSamples - kWidth + 1;
	for trackN = 1:size(tM,1)
		
		gateTrue = zeros(nSamples,1);
		for lagN = 1:nLags
			aSnip = (tM(trackN,[lagN:(lagN + kWidth - 1)],:));
			[aSnip,nShifts] = shiftdim(aSnip,1); % Remove dim1
			violations = ((aSnip > maxVals) | (aSnip < minVals));
			if sum(violations(:)) == 0
				gateTrue(lagN) = 1;
			
				if plotOn	
					plotGate(G); 
					hold on; 
					for dimN = 1:G.Ndim 
						subplot(G.Ndim,1,dimN);
						plot(kTVec,aSnip(:,dimN),'r');
					end
				end
			end
		end
		scores(trackN) = sum(gateTrue)./nLags;
	end

toc


