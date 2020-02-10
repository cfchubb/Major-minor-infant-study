function [allKs,origK] = randpermTestP1SpikeHeight(nIters)

% Conduct the random permutation test described "Sensitivity to Major 
% Versus Minor Musical Modes is Bimodally Distributed in Young Infants."
% The input argument (nIters) determines the number of simulations performed.

% Each row in the matrix below has the number of correct anticipations
% in the left column and the number of incorrect anticipations in the right
% column for a single infant in the group for whom the location of the
% target was PREDICTABLE from the quality (major vs. minor) of the stimulus
% presented on any given trial.

global urn nBabies nAnticipationsEachBaby

actualCorrIncorr = [1     3
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
spikeContributors = actualCorrIncorr(:,2)==0;
spikeHeight = sum(actualCorrIncorr(spikeContributors,1));

nBabies = length(actualCorrIncorr);
totalIncorrectAnticipations = sum(actualCorrIncorr(:,2));
totalCorrectAnticipations = sum(actualCorrIncorr(:,1));
urn = [ones(totalCorrectAnticipations,1);zeros(totalIncorrectAnticipations,1)];
nAnticipationsEachBaby = sum(actualCorrIncorr,2);

simSpikeHeights = NaN(nIters,1);
for k=1:nIters
    D = simData;
    spikeContributors = D(:,2)==0;
    simSpikeHeights(k) = sum(D(spikeContributors,1));
end

pVal = sum(simSpikeHeights >= spikeHeight)/nIters;

end

function D = simData

global urn nBabies nAnticipationsEachBaby

urn = urn(randperm(length(urn)));
prevEnd = 0;
D = NaN(nBabies,2);
for k=1:nBabies
    st = prevEnd+1;
    nd = prevEnd+nAnticipationsEachBaby(k);
    prevEnd = nd;
    nxtBunch = urn(st:nd);
    D(k,1) = sum(nxtBunch==1);
    D(k,2) = sum(nxtBunch==0);
end
end
