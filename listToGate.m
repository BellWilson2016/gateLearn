function G = listToGate(L, Go)

	G = Go;
	ix = 1;
	for dimN = 1:G.Ndim
		if (Go.useDim(dimN) == 1)
			G.C(dimN,:) = denormByBoundary(L(ix:(ix + Go.NPoints - 1)),...
							Go.boundaryValues(dimN,:));
			ix = ix + Go.NPoints;
			G.W(dimN,:) = denormWidthByBoundary(L(ix:(ix + Go.NPoints - 1)),...
							Go.boundaryValues(dimN,:));
			ix = ix + Go.NPoints;
		end
	end
	G.tau = denormTimeByBoundary(L(end),G.timeScaleRange);

function descaledX = denormByBoundary(normalizedX, BV)

	scale = diff(BV);
	offset = mean(BV);

	descaledX = normalizedX*scale/2 + offset;

function descaledWidth = denormWidthByBoundary(normalizedWidth, BV)

	scale = diff(BV);

	descaledWidth = normalizedWidth*scale/2;

function tau = denormTimeByBoundary(normalizedTime, BV)

	offset = BV(1);
	scale = diff(BV);

	tau = normalizedTime*scale + offset;
