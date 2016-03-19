function plotRun(runCode)

	Go = initialGate();
	load(['FitGate-',runCode,'.mat']);
	Gi = listToGate(x,Go);
	plotGate(Gi);
