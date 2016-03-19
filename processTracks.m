function pTracks = processTracks(sampleTracks, sampleIX)

	sampleInterval = .05;
	printOn = true;

	bodyXs = sampleTracks(:,:,1);
	bodyYs = sampleTracks(:,:,2);
	headXs = sampleTracks(:,:,3);
	headYs = sampleTracks(:,:,4);

	pTracks = zeros(size(sampleTracks,1),size(sampleTracks,2),9);
	headYtracks = zeros(size(sampleTracks,1),size(sampleTracks,2),1);

	for nTrace = 1:size(sampleTracks,1)

		if printOn
			disp([num2str(nTrace),' of ',num2str(size(sampleTracks,1))]);
		end

		LR = sampleIX(nTrace,2);
		bodyX = -bodyXs(nTrace,:)*LR; % Flip left traces, laser is on + side
		bodyY = bodyYs(nTrace,:);
		headX = -headXs(nTrace,:)*LR; % Flip left traces, laser is on + side
		headY = headYs(nTrace,:);

		bodyX = gaussianFilter(bodyX, .1, (1/sampleInterval));
		bodyY = gaussianFilter(bodyY, .1, (1/sampleInterval));
		headX = gaussianFilter(headX, .1, (1/sampleInterval));
		headY = gaussianFilter(headY, .1, (1/sampleInterval));

		headAngle = atan2(headY,headX);
		unwrappedAngle = unwrap(headAngle);
		dHeadAngle = [diff(unwrappedAngle(:));0]./sampleInterval;

		dX = [diff(bodyX(:));0]./sampleInterval;
		dY = [diff(bodyY(:));0]./sampleInterval;

		Vf = sum([dX dY].*[cos(headAngle(:)) sin(headAngle(:))],2);
		Vs = sum([dX dY].*[sin(headAngle(:)) cos(headAngle(:))],2);

		pTracks(nTrace,:,1) = bodyX(:);
		pTracks(nTrace,:,2) = bodyY(:);
		pTracks(nTrace,:,3) = dX(:);
		pTracks(nTrace,:,4) = dY(:);
		pTracks(nTrace,:,5) = sin(headAngle(:));
		pTracks(nTrace,:,6) = cos(headAngle(:));
		pTracks(nTrace,:,7) = dHeadAngle(:);
		pTracks(nTrace,:,8) = Vf(:);
		pTracks(nTrace,:,9) = Vs(:);
		
		headYtracks(nTrace,:,1) = bodyY(:) + headY(:);

%		clf
%		subplot(2,1,1);
%		plot([1:length(bodyX)].*sampleInterval, bodyX,'m'); hold on;
%		xlim([50 60]);
%		subplot(2,1,2);
%		plot([1:length(bodyX)].*sampleInterval, Vf,'b'); hold on;
%		plot([1:length(bodyX)].*sampleInterval, Vs,'m'); hold on;
%		plot([1:length(bodyX)].*sampleInterval, dX,'r'); hold on;
%		xlim([50 60]);
%		pause
	
	end	

	% Need to zero-center bodyY for each fly
	% Only move if adjustment is less than 1 mm
	% Use max counts?
	genoList = unique(sampleIX(:,9));
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		ix = find(sampleIX(:,9) == genoN);
		flyList = unique(sampleIX(ix,8));
		for flyNn = 1:length(flyList)
			flyN = flyList(flyNn);
			ix = find((sampleIX(:,8) == flyN) & (sampleIX(:,9) == genoN));
			allHeadY = headYtracks(ix,:,1);
			maxY = max(allHeadY(:));
			minY = min(allHeadY(:));
			meanY = mean(allHeadY(:));
			midY = mean([maxY,minY]);
			pTracks(ix,:,2) = pTracks(ix,:,2) - midY;
		end
	end

