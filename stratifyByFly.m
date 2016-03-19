%           1      2     3     4       5          6       7     8      9
% tAIX = [powerN, LR, presN, laneN, roomTemp, trialTime, repN, flyN, genoN
function [meanMetrics, meanIX] = stratifyByFly(metrics, tAIX)

    flyList = unique(tAIX(:,8));
    powerList = unique(tAIX(:,1));
	genoList = unique(tAIX(:,9));
    
    meanMetrics = [];
    meanIX = [];
	for genoNn = 1:length(genoList)
		genoN = genoList(genoNn);
		for flyNn = 1:length(flyList)
			flyN = flyList(flyNn);
			for powerNn = 1:length(powerList)
				powerN = powerList(powerNn);
			
				ix = find((tAIX(:,8) == flyN) &...
					  	  (tAIX(:,1) == powerN) &...
						  (tAIX(:,9) == genoN));

				if length(ix) > 0
					meanVal = nanmean(metrics(ix,:),1);
					
					meanMetrics = cat(1, meanMetrics, meanVal);
					meanIX      = cat(1, meanIX, [powerN flyN genoN]);
				end
				
			end
		end
	end
		
		
