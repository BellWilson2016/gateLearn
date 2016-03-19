function out = gaussianFilter(signal, sigma, sampleRate)

	coverageFactor = 5;
	tVec = [-5*sigma:(1/sampleRate):5*sigma];
	kernel = 1/(sigma*sqrt(2*pi))*exp(-tVec.^2/(2*sigma^2))*(1/sampleRate);

	%plot(tVec, kernel)
	%sum(kernel)*1/sampleRate

	out = conv(signal, kernel, 'same');
