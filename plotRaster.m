function plotRaster(scores, meanIX,decPI)

	% Sort by geno, then power, then fly number
	[B,newIX] = sortrows(meanIX,[3,1,2]);
	raster = zscore(scores(newIX,1:10),0,1)';
	key = zscore(meanIX(newIX,[1,3]),0,1)';
	image([raster;zscore(decPI)';key],'CDataMapping','scaled');

