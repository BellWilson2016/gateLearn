function checkNorm()

	BV = [-20 20];
	normalizeByBoundary([-20 -10 0 10 20],BV)

	normalizeWidthByBoundary([0 10 20],BV)

	BV = [.5 8];
	normalizeTimeByBoundary([.5 1 4 8],BV)

function normalizedX = normalizeByBoundary(unscaledX, BV)

	scale = diff(BV);
	offset = mean(BV);

	normalizedX = 2*(unscaledX - offset)./scale;


function normalizedWidth = normalizeWidthByBoundary(unscaledWidth, BV)

	scale = diff(BV);

	normalizedWidth = 2*(unscaledWidth)./scale;

function normalizedTime = normalizeTimeByBoundary(tau, BV)

	offset = BV(1);
	scale = diff(BV);

	normalizedTime = (tau - offset)./scale;
