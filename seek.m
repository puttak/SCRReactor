function [ output_args ] = seek( vols, temps, ammoniaRatio )
%SEEK This function finds the maximum conversion of ammonia achieved that
%meets the legal specification of the NO concentration level. It does this
%using a brute-force approach, and may take some time. The inner for-loop
%is parallel-ised to speed up the process slightly.

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
        %parfor loop to run in parallel accross a parallel pool.
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

% Calc the optimised parameter - i.e. the highest conversion of ammonia
% that meets the specifications
[M,indicie] = max(res(:));
% Identify the co-ordinates of the maximised parameter
[x,y,z] = ind2sub(size(res),indicie);
fprintf('Optimised Reactor Parameters:\n');
fprintf('Highest Ammonia Conversion: %.2f %% @\n', M);
fprintf('Volume (m^3): %d\n', vols(x));
fprintf('Temperature (K): %d\n', temps(y));
fprintf('Ammonia Ratio: %.2f\n', ammoniaRatio(z));


end

