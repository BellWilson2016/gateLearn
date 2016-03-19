function PI = quickPI(tA)

	bodyX = squeeze(tA(:,:,1));
	sideX = (bodyX < 0);
	divisor = size(tA,2);

	PI = 2*(sum(sideX,2) - divisor/2)./divisor;

