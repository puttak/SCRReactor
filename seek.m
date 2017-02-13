function [ output_args ] = seek( vols, temps, ammoniaRatio )
%SEEK Summary of this function goes here
%   Detailed explanation goes here

%% Load ToolBox & Data
% Load the data from the function
flueGasData = initialFlueGasFlow();
[shomateVars, Hf298] = shomateLoader([{'NO'},{'N2'},{'NH3'},{'H2O'},{'O2'},{'CO2'}]);

%% Optimisation routine - this will take a while
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


end

