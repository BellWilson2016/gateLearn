function animateGate(stemName,gateN,repRange)

	for stepNn = 1:length(repRange)
		stepN = repRange(stepNn);

		load(['~/gatePop/gatePop-',stemName,'-',num2str(stepN),'.mat']);
		disp(stepN);
		plotGate(gatePop.gateList{gateN});
		drawnow;
	end
