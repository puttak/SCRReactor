function [corrConcNO, conversionNO, conversionNH3, kNO, kNH3] = reactorAsPFR(flueGasData,shomateVars, Hf298, vol, T, NOxToAmmoniaRatio, NOXpercent)
% This Script models a NOx removal by SCR unit. The reactor is modelled as
% a plug flow reactor, where the volume corresponds to the volume of the
% wall of the monolith honeycomb

% Reactions are as follows:
% (1) 4NO + 4NH3 + O2 -> 4N2 + 6H2O
% (2) 4NH3 + 3O2 -> 2N2 + 6H2O


%% Reactant Inital data:

NOxToOxygenRatio = NOxToAmmoniaRatio*20*0.21*NOXpercent;
NOxToNitrogenRation = NOxToAmmoniaRatio*20*0.79*NOXpercent;

initMolarFlows = [NOXpercent*(flueGasData.molarFlows.nitrogenOxide+flueGasData.molarFlows.nitrogenDioxide),...
    flueGasData.molarFlows.nitrogen+NOxToNitrogenRation*flueGasData.molarFlows.nitrogenOxide, flueGasData.molarFlows.ammonia+NOxToAmmoniaRatio*NOXpercent*flueGasData.molarFlows.nitrogenOxide,...
    flueGasData.molarFlows.water, flueGasData.molarFlows.oxygen+NOxToOxygenRatio*flueGasData.molarFlows.nitrogenOxide,...
    flueGasData.molarFlows.carbonDioxide+flueGasData.molarFlows.hydrogenChloride+...
    flueGasData.molarFlows.sulphurDioxide+flueGasData.molarFlows.sulphurTrioxide]';
initMolarFlows = initMolarFlows*1000; 
P = 200000;
R = 8.314;


%% Reaction Rate Laws & Constants
kNO = (1e6)*exp(-60e3/(R*T));
kNH3 = (6.8e7)*exp(-85e3/(R*T));
KNH3 = (2.57e-17)*exp(2.37e5/(R*T));

cp = @(x,T) x(1)+x(2)*(T/1000)+x(3)*(T/1000)^2+x(4)*(T/1000)^3+x(5)/((T/1000)^2);
Hf = @(x,T,H298) H298+x(1)*(T/1000)+x(2)*((T/1000)^2)/2+x(3)*((T/1000)^3)/3+x(4)*((T/1000)^4)/4-x(5)/(T/1000)+x(6)-x(8);
%% ODE for Length

    function dfadw = odewfa(y,c)
        volume = sum(c)*R*c(7)/P;
        conc = c./volume;
        r1 = 0.575*(kNO*KNH3*conc(1)*conc(3))/(1+KNH3*conc(3));
        r2 = kNH3*conc(3);
        dfadw = zeros(length(c),1);
        dfadw(1) = -r1;
        dfadw(2) = r1+0.5*r2;
        dfadw(3) = -r1-r2;
        dfadw(4) = 1.5*r1+1.5*r2;
        dfadw(5) = -r1/4-(3/4)*r2;
        dfadw(6) = 0;
        
        % Calculate the heats of reaction
        r1Balance = [-4 4 -4 6 -1 0];
        r2Balance = [0 2 -4 6 -3 0];
        
        for i=1:length(r1Balance)
            if r1Balance(i)>=0
                r1HRxn(i) = 0;
            else
                tBalance = r1Balance./abs(r1Balance(i));
                sumForRxn = 0;
                for j=1:length(r1Balance)
                    
                    sumForRxn(j) = Hf(shomateVars(j,:),c(7),Hf298(j))*1000;
                    
                end
                sumForRxn = sumForRxn.*tBalance;
                r1HRxn(i) = sum(sumForRxn);
            end
        end
        for i=1:length(r2Balance)
            if r2Balance(i)>=0
                r2HRxn(i) = 0;
            else
                tBalance = r2Balance./abs(r2Balance(i));
                sumForRxn = 0;
                for j=1:length(r2Balance);
                    
                    sumForRxn(j) = Hf(shomateVars(j,:),c(7),Hf298(j))*1000;
                    
                end
                sumForRxn = sumForRxn.*tBalance;
                r2HRxn(i) = sum(sumForRxn);
            end
        end
        
        relRate1 = (r1Balance./4).*r1;
        deltaHRr1 = sum(relRate1.*r1HRxn);
        relRate2 = (r2Balance./4).*r2;
        deltaHRr2 = sum(relRate2.*r2HRxn);
        numerator = deltaHRr1+deltaHRr2;
        
        for i=1:6
            cpa(i)=cp(shomateVars(i,:),c(7));
        end
        denominator = sum(c(1:6)'.*cpa);
        dfadw(7) = numerator/denominator;
        
    end
options = odeset('Refine',1,'NonNegative',1);
[w, fa] = ode23(@odewfa,0:0.01:vol,[initMolarFlows; T],options);
 
%% Output Conversions and Normallised Stack Concentration
% Stack concentration assumes 99% of the CO2 will be removed in the
% following process and also discounts any additional water added.

conversionNO = ((initMolarFlows(1)-fa(end,1))/initMolarFlows(1))*100;
conversionNH3 = ((initMolarFlows(3)-fa(end,3))/initMolarFlows(3))*100;

% Calculate the approximate mg/Nm3 

% Total moles of gas dry / s

totalMolesDry = sum(fa(end,:))-fa(end,4)-0.9*(flueGasData.molarFlows.carbonDioxide*1000);

% Nm3 occupied by dry weight
volSC = totalMolesDry*R*273.15/100000; %m3

% O2 correction factor
o2CorrectionFactor = (0.21-0.11)/(0.21-(fa(end,5)/totalMolesDry));

mrNO = 30; %g/mol

GNO = fa(end,1)*mrNO;

concNO = (GNO/volSC)*1000; %mg/Nm3

corrConcNO = concNO * o2CorrectionFactor;






end