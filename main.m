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
[corrConcNO, conversionNO, conversionNH3, kNO, kNH3] = reactorAsPFR(flueGasData,shomateVars, Hf298, 16, 620, 0.85);

%% Optimisation routine - this will take a while


