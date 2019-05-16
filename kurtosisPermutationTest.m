function [allKs,origK] = kurtosisPermutationTest(nIters,runPredictableGroup)


% Each row in the matrix below has the number of correct anticipations
% in the left column and the number of incorrect anticipations in the right
% column for a single infant in the group for whom the location of the
% target was PREDICTABLE from the quality (major vs. minor) of the stimulus
% presented on any given trial.

if nargin < 2
    runPredictableGroup = true;
end

if runPredictableGroup
    correctAndIncorrectResponses = [...
     1     3
     5     5
    13     3
     2     4
     1     2
     3     4
     6     0
     2     3
     5     3
     2     2
     4     3
     5     3
     6     0
     2     0
     4     0
     5     0
     3     3
    12    11
     4     4
     7     4
     1     0
     5     1
     4     2
     1     1
     6     0
     3     2
     5     4
     3     0
     7     6
     2     3];
else
% Each row in the matrix below has the number of correct anticipations
% in the left column and the number of incorrect anticipations in the right
% column for a single infant in the group for whom the location of the
% target was UNPREDICTABLE from the quality (major vs. minor) of the stimulus
% presented on any given trial.
    correctAndIncorrectResponses = [...
     1     1
     2     2
     4     2
     3     5
     3     6
     4     2
     4     4
     3     2
     3     3
     2     3
    12     9
     1     5
     2     1
     5     5
     5     3
     7     6
     1     1
     3     2
     4     2
     4     5];
end
 
corrAnts = correctAndIncorrectResponses(:,1);
totalAnts = sum(correctAndIncorrectResponses,2);

origK = getKurtosis(corrAnts,totalAnts);

nBabies = length(totalAnts);
urn = [zeros(sum(totalAnts)-sum(corrAnts),1);ones(sum(corrAnts),1)];


allKs = NaN(nIters,1);
for k=1:nIters
    urn = urn(randperm(length(urn)));
    nd = 0;
    simCorrAnts = NaN(nBabies,1);
    for h=1:nBabies
        st = nd+1;
        nd = nd+totalAnts(h);
        nxtBunch = urn(st:nd);
        simCorrAnts(h)=sum(nxtBunch);
    end
    allKs(k)=getKurtosis(simCorrAnts,totalAnts);
end

fprintf('p-value = %0.4f\n',sum(allKs < origK)/nIters)
figure
histogram(allKs,30)
hold
plot(origK, 0,'*r') 

% hist(simNPerfect)
end

function K = getKurtosis(corrAnts,totalAnts)
pCorrs = corrAnts./totalAnts;
uPCorrs = unique(pCorrs);
nUPcorrs = length(uPCorrs);
v = [];
for k=1:nUPcorrs
    n = sum(pCorrs==uPCorrs(k));
    v = [v uPCorrs(k)*ones(1,n)];
end
K = kurtosis(v,0);  % second argument says correct for bias
end
