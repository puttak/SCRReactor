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

data.totalMolarFlow = sum(cell2mat(struct2cell(data.molarFlows))); % This isn't pretty but does the job

data.moleFraction.oxygen = data.molarFlows.oxygen/data.totalMolarFlow;
data.moleFraction.carbonDioxide = data.molarFlows.carbonDioxide/data.totalMolarFlow;
data.moleFraction.water = data.molarFlows.water/data.totalMolarFlow;
data.moleFraction.ammonia = data.molarFlows.ammonia/data.totalMolarFlow;
data.moleFraction.nitrogen = data.molarFlows.nitrogen/data.totalMolarFlow;
data.moleFraction.hydrogenChloride = data.molarFlows.hydrogenChloride/data.totalMolarFlow;
data.moleFraction.sulphurDioxide = data.molarFlows.sulphurDioxide/data.totalMolarFlow;
data.moleFraction.sulphurTrioxide = data.molarFlows.sulphurTrioxide/data.totalMolarFlow;
data.moleFraction.nitrogenOxide = data.molarFlows.nitrogenOxide/data.totalMolarFlow;
data.moleFraction.nitrogenDioxide = data.molarFlows.nitrogenDioxide/data.totalMolarFlow;

data.molarWeight.oxygen = 32;
data.molarWeight.carbonDioxide = 44;
data.molarWeight.water = 18;
data.molarWeight.ammonia = 17;
data.molarWeight.nitrogen = 28;
data.molarWeight.hydrogenChloride = 36.5;
data.molarWeight.sulphurDioxide = 64;
data.molarWeight.sulphurTrioxide = 80;
data.molarWeight.nitrogenOxide = 30;
data.molarWeight.nitrogenDioxide = 46;

data.molarWeight.average = sum(cell2mat(struct2cell(data.molarWeight)).*cell2mat(struct2cell(data.moleFraction)));
end
