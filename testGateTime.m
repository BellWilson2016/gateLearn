function testGateTime()

	load('~/derived/subSample-E.mat');
	nSplits = 10;

	Go = initialGate();

%	gateScores = applyGateFastFast(Go, sampleTracks);
%	gateScores(50:60)

	gateScores = applyGateFast(Go, sampleTracks);
	gateScores(50:60)
