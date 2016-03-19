function testShiftsFF()
	
	% Tracks, time, dim
	tM = zeros(5,10,2);
	tM(1,1:10,1) = 1:10;

	tShifts = repmat(reshape(tM,1,5,10,2),7,1,1,1);

	squeeze(tShifts(2,:,:,:))

	stIX = 1:7;
	enIX = stIX + 3;
	tShiftMatrix = tShifts(stIX,:,[1:4;2:5],:);
	size(tShiftMatrix)

	squeeze(tShiftMatrix(1,:,:,:))
	squeeze(tShiftMatrix(2,:,:,:))

