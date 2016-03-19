function outMat = vectCircShift(vectToShift, shiftVector)

	[n,m] = size(vectToShift);
	if n > m
		inds = (1:n)';
		i = toeplitz(flipud(inds),circshift(inds,[1 0]));
		outMat = vectToShift(i(shiftVector,:));
	else
		inds = 1:m;
		i = toeplitz(fliplr(inds),circshift(inds,[0 1]));
		outMat = vectToShift(i(shiftVector,:));
	end

