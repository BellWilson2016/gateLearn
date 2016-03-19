function optManyGates()

	subSampleCode = 'SSMYC';
	%	subSampleCode = 'SingleSmoothMid';
	% subSampleCode = 'SingleSmoothMid8Only';
	
	runsPerHost = 20;
	nRuns = runsPerHost*5;

	for runN = 1:nRuns
		fHandlesAscent{runN} = @()optGateJAscent( subSampleCode, 'jAscMultiDim');
	end

	rechunkSubmit(fHandlesAscent, runsPerHost);
	%rechunkSubmit(fHandlesAscent, runsPerHost);
	%rechunkSubmit(fHandlesAscent, runsPerHost);
	%rechunkSubmit(fHandlesAscent, runsPerHost);
