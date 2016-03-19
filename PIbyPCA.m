function PIbyPCA(X, meanIX)

	load('~/gateSpec/allMetrics.mat');
	decPI = allMetrics(:,2);

	decPI(find(isnan(decPI))) = 0;
	
	figure;
	scatter(X(:,1),X(:,2),9,decPI);
