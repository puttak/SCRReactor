% This function stores and returns the molar flows in kmol/s 
function [data] = initialFlueGasFlow()

data.molarFlows.oxygen = 2.02e-1;
data.molarFlows.carbonDioxide = 5.04e-1;
data.molarFlows.water = 2.85e-1;
data.molarFlows.ammonia = 2.5e-7;
data.molarFlows.nitrogen = 2.7;
data.molarFlows.hydrogenChloride = 2.28e-4;
data.molarFlows.sulphurDioxide = 1.68e-5;
data.molarFlows.sulphurTrioxide = 6.84e-6;
data.molarFlows.nitrogenOxide = 1.34e-3;
data.molarFlows.nitrogenDioxide = 2.39e-6;
end
