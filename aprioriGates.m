function aprioriGates()

	Gtemp = initialGate();

	gates(1) = Gtemp;
	gates(1).name = 'PIgate';
	gates(1).tau = .5;
	gates(1).C(1,:) = [-14 -14 -14 -14 -14 -14];
	gates(1).W(1,:) = [ 14  14  14  14  14  14];

	gates(2) = Gtemp;
	gates(2).name = 'decPIgate';
	gates(2).tau = .5;
	gates(2).C(1,:) = [0,14,14,14,14,14];  
	gates(2).W(1,:) = [5,14,14,14,14,14];

	gates(3) = Gtemp;
	gates(3).name = 'negdecPIgate';
	gates(3).tau = .5;
	gates(3).C(1,:) = -[0,14,14,14,14,14];  
	gates(3).W(1,:) = [5,14,14,14,14,14];






