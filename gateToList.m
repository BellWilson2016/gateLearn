function [x0, lb, ub] = gateToList(G)

	x0 = [];
	ub = [];
	lb = [];
	for dimN = 1:G.Ndim
		if (G.useDim(dimN) == 1)
			x0 = cat(1,x0,normalizeByBoundary(G.C(dimN,:)',G.boundaryValues(dimN,:)));
			ub = cat(1,ub,  ones(G.NPoints,1));
			lb = cat(1,lb, -ones(G.NPoints,1));

			x0 = cat(1,x0,normalizeWidthByBoundary(G.W(dimN,:)',G.boundaryValues(dimN,:)));
			ub = cat(1,ub, ones(G.NPoints,1));
			lb = cat(1,lb, zeros(G.NPoints,1));
		end
	end

	x0 = cat(1,x0,normalizeTimeByBoundary(G.tau, G.timeScaleRange));
	ub = cat(1,ub,1);
	lb = cat(1,lb,0);

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
