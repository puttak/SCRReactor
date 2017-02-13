% This Script models a NOx removal by SCR unit. The reactor is modelled as
% a plug flow reactor, where the volume corresponds to the volume of the
% wall of the monolith honeycomb

% Before beginning make sure the workspace and command-line is clear.
clear
clc
%% Load ToolBox & Data
addpath('jsonlab');
% Load the data from the function
flueGasData = initialFlueGasFlow();
[shomateVars, Hf298] = shomateLoader([{'NO'},{'N2'},{'NH3'},{'H2O'},{'O2'},{'CO2'}]);


%% Size the Reactor
[corrConcNO, conversionNO, conversionNH3, kNO, kNH3] = reactorAsPFR(flueGasData,shomateVars, Hf298, 16, 620, 0.85,1);

%% Optimisation routine - this will take a while

vols = 1:1:16;
temps = 580:5:650;
ammoniaRatio = 0.5:0.1:1.5;

count = 0;
countPerRun = length(vols);
totalCount = length(vols)*length(temps)*length(ammoniaRatio);

% Preallocate the matrix for speed
res = zeros(length(vols),length(temps),length(ammoniaRatio));

for k=1:length(ammoniaRatio)
    ammoniaRatioForThisRun = ammoniaRatio(k);
    for j=1:length(temps)
        tempForThisRun = temps(j);
        parfor i=1:length(vols)
            [corrConcNO, ~, conversionNH3, ~, ~] = reactorAsPFR(flueGasData,shomateVars, Hf298, vols(i), tempForThisRun, ammoniaRatioForThisRun,1);
            if corrConcNO < 200 && corrConcNO > 160
                tempVolRet(i) = conversionNH3;
            else
                tempVolRet(i) = 0;
            end
        end
        tempTempRet(:,j) = tempVolRet;
        clc;
        count = count+countPerRun;
        fprintf('%d/%d\n', count, totalCount);
    end
    res(:,:,k) = tempTempRet;
end

% Calc the optimised parameter
[M,indicie] = max(res(:));
[x,y,z] = ind2sub(size(res),indicie);
fprintf('Optimised Reactor Parameters:\n');
fprintf('Highest Ammonia Conversion: %.2f %% @\n', M);
fprintf('Volume (m^3): %d\n', vols(x));
fprintf('Temperature (K): %d\n', temps(y));
fprintf('Ammonia Ratio: %.2f\n', ammoniaRatio(z));

