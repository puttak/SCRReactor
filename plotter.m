function [] = plotter()
% This function plots a variety of graphs that are used to analysise the
% results of our reactor - the variables are modified directly in this
% file, and not at run-time.
%% Load ToolBox & Data
addpath('jsonlab');
% Load the data from the function
flueGasData = initialFlueGasFlow();
[shomateVars, Hf298] = shomateLoader([{'NO'},{'N2'},{'NH3'},{'H2O'},{'O2'},{'CO2'}]);
desiredVolume = 16;
%% Vol Limit - 0.5 ratio

vols = [10:0.5:desiredVolume];
parfor i=1:length(vols)
    [nox(i),xno2(i),xnh32(i)]=reactorAsPFR(flueGasData,shomateVars, Hf298, vols(i),615,0.5,1);
    [nox115(i),xno25(i),xnh325(i)]=reactorAsPFR(flueGasData,shomateVars, Hf298, vols(i),615,0.5,1.15);
    [nox85(i),xno26(i),xnh326(i)]=reactorAsPFR(flueGasData,shomateVars, Hf298, vols(i),615,0.5,0.85);
end


figure(1);
plot(vols,nox,vols,nox115,vols,nox85,[vols(1) vols(end)],[200 200]);
legend('NO_x 100%','NO_x 115%', 'NO_x 85%','NO_x Limit');
title('NO_x Concentrations at Stack vs. Catalyst Volume @ 0.5 mol ammonia per mol NO_x');
ylabel('NO_x Concentration mg/Nm^3');
xlabel('Catalyst Volume m^3');

%% Vol Limit - 1 ratio

vols = [10:0.5:desiredVolume];
parfor i=1:length(vols)
    [nox(i),xno2(i),xnh32(i)]=reactorAsPFR(flueGasData,shomateVars, Hf298, vols(i),615,1,1);
    [nox115(i),xno25(i),xnh325(i)]=reactorAsPFR(flueGasData,shomateVars, Hf298, vols(i),615,1,1.15);
    [nox85(i),xno26(i),xnh326(i)]=reactorAsPFR(flueGasData,shomateVars, Hf298, vols(i),615,1,0.85);
end


figure(1);
plot(vols,nox,vols,nox115,vols,nox85,[vols(1) vols(end)],[200 200]);
legend('NO_x 100%','NO_x 115%', 'NO_x 85%','NO_x Limit');
title('NO_x Concentrations at Stack vs. Catalyst Volume @ 1 mol ammonia per mol NO_x');
ylabel('NO_x Concentration mg/Nm^3');
xlabel('Catalyst Volume m^3');

%% Temp Conversion
temps = [550:5:800];
parfor i=1:length(temps)
    [~,xno(i),xnh3(i), kno(i),knh3(i)]=reactorAsPFR(flueGasData,shomateVars, Hf298, desiredVolume,temps(i),0.5,1);
end

figure(2);
plot(temps,xno,temps,xnh3);
legend('NO','NH3');
figure(5)
plot(temps,kno,temps,knh3);
legend('k_N_O','k_N_H_3');

%% Ammonia Conversion
ammoniaRatio = [0:0.01:2];
parfor i=1:length(ammoniaRatio)
    [~,xnon(i),xnh3n(i)]=reactorAsPBR(desiredVolume,620,ammoniaRatio(i));
end

figure(3);
plot(ammoniaRatio,xnon, ammoniaRatio,xnh3n);
legend('NO','NH3');


%% Ammonia Conversion Surface
temps = [590:5:620];
ammoniaRatio = [0:0.01:2];
for i=1:length(temps)
    parfor j=1:length(ammoniaRatio)
        [~,xnosurf(i,j),xnh3surf(i,j)]=reactorAsPFR(flueGasData,shomateVars, Hf298, desiredVolume,temps(i),ammoniaRatio(j),1);
    end
end
figure(4)
surf(ammoniaRatio,temps,xnh3surf);
figure(6)
surf(ammoniaRatio,temps,xnosurf);
end
