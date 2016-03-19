function subSampleTracks(useGenos, timeSamples, selectProb, sampleHash)

	baseDir = '/groups/wilson/derived/';
	printOn = true;

	% Pre allocate arrays
	sampleTracks = zeros(40000,3000,4);
	sampleIX = zeros(40000,9);

	nTracks = 0;
	for genoNn = 1:length(useGenos)
		genoN = useGenos(genoNn);
		if printOn
			disp(['Loading geno ',num2str(genoN),'...']);
		end
		load([baseDir,'geno',num2str(genoN,'%03d'),'.mat']);

		uniqueFlies = unique(trackIndex(:,8));
		flyIX = find(rand(length(uniqueFlies),1) < selectProb);
		for flyNn = 1:length(flyIX)
			disp([num2str(flyNn),' of ',num2str(length(flyIX))]);
			ix = find(trackIndex(:,8) == uniqueFlies(flyIX(flyNn)));

			sampleTracks(nTracks + [1:length(ix)],:,:) = trackArray(ix,:,:);
			sampleIX(nTracks + [1:length(ix)],:) = trackIndex(ix,:);
			nTracks = nTracks + length(ix);
		end
	end

	% Reduce size in case over-allocated
	sampleTracks = sampleTracks(1:nTracks,:,:);
	sampleIX = sampleIX(1:nTracks,:);

	if printOn
		disp(['Found ',num2str(size(sampleTracks,1)),' tracks.']);
	end

	procTracks = processTracks(sampleTracks, sampleIX);
	procTracks = procTracks(:,timeSamples,:);
	rawTracks = sampleTracks;

	save([baseDir,'subSample-',sampleHash,'.mat'],'sampleHash','procTracks','sampleIX','-v7.3');
	% save([baseDir,'subSample-',sampleHash,'.mat'],'sampleHash','procTracks','rawTracks','sampleIX','-v7.3');

			


