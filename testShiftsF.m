function testShiftsF()
	
	% Tracks, time, dim
	tM = zeros(5,10,2);
	tM(1,1:10,1) = 1:10;
	nTracks = 5;

		nLags = 4;
		lagSt = 1:nLags;
		lagEn = lagSt + 2;

		a = tM(1,[1,2,3,4;2,3,4,5;3,4,5,6],:);
		tShiftMatrix = reshape(a,3,4,2);
		size(tShiftMatrix)
		squeeze(tShiftMatrix(1,:,:))
		squeeze(tShiftMatrix(2,:,:))
